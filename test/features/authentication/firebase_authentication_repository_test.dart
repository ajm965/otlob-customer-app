import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/features/authentication/data/firebase/firebase_authentication_repository.dart';
import 'package:otlob_customer_app/features/authentication/domain/models/authentication_state.dart';

void main() {
  group('FirebaseAuthenticationRepository phone flow', () {
    test('rejects invalid KSA phone without starting verification', () async {
      var started = false;
      final FirebaseAuthenticationRepository repository =
          FirebaseAuthenticationRepository(
        phoneVerificationStarter: ({
          required String phoneNumber,
          required void Function(PhoneAuthCredential credential)
              verificationCompleted,
          required void Function(FirebaseAuthException error) verificationFailed,
          required void Function(String verificationId, int? resendToken) codeSent,
          required void Function(String verificationId)
              codeAutoRetrievalTimeout,
          Duration? timeout,
          int? forceResendingToken,
        }) async {
          started = true;
        },
      );

      final IntegrationResult<AuthenticationState> result =
          await repository.beginPhoneAuthentication(
        AuthenticationFlow.signIn,
        '0551234567',
      );

      expect(started, isFalse);
      expect(result, isA<IntegrationError<AuthenticationState>>());
      expect(
        (result as IntegrationError<AuthenticationState>).failure.kind,
        IntegrationFailureKind.validation,
      );
    });

    test('stores verificationId from codeSent', () async {
      final FirebaseAuthenticationRepository repository =
          FirebaseAuthenticationRepository(
        phoneVerificationStarter: ({
          required String phoneNumber,
          required void Function(PhoneAuthCredential credential)
              verificationCompleted,
          required void Function(FirebaseAuthException error) verificationFailed,
          required void Function(String verificationId, int? resendToken) codeSent,
          required void Function(String verificationId)
              codeAutoRetrievalTimeout,
          Duration? timeout,
          int? forceResendingToken,
        }) async {
          codeSent('vid-123', 42);
        },
      );

      final IntegrationResult<AuthenticationState> result =
          await repository.beginPhoneAuthentication(
        AuthenticationFlow.signIn,
        '+966501234567',
      );

      expect(result, isA<IntegrationSuccess<AuthenticationState>>());
      final AuthenticationState state =
          (result as IntegrationSuccess<AuthenticationState>).value;
      expect(state.verificationId, 'vid-123');
      expect(state.forceResendingToken, 42);
      expect(state.phone, '+966501234567');
      expect(state.isOtpVerified, isFalse);
    });

    test('returns safe failure on verificationFailed', () async {
      final FirebaseAuthenticationRepository repository =
          FirebaseAuthenticationRepository(
        phoneVerificationStarter: ({
          required String phoneNumber,
          required void Function(PhoneAuthCredential credential)
              verificationCompleted,
          required void Function(FirebaseAuthException error) verificationFailed,
          required void Function(String verificationId, int? resendToken) codeSent,
          required void Function(String verificationId)
              codeAutoRetrievalTimeout,
          Duration? timeout,
          int? forceResendingToken,
        }) async {
          verificationFailed(
            FirebaseAuthException(code: 'too-many-requests', message: 'Quota'),
          );
        },
      );

      final IntegrationResult<AuthenticationState> result =
          await repository.beginPhoneAuthentication(
        AuthenticationFlow.registration,
        '+966501234567',
      );

      expect(result, isA<IntegrationError<AuthenticationState>>());
      final IntegrationFailure failure =
          (result as IntegrationError<AuthenticationState>).failure;
      expect(failure.kind, IntegrationFailureKind.validation);
      expect(failure.message, 'Quota');
    });

    test('returns safe failure when codeSent verificationId is empty', () async {
      final FirebaseAuthenticationRepository repository =
          FirebaseAuthenticationRepository(
        phoneVerificationStarter: ({
          required String phoneNumber,
          required void Function(PhoneAuthCredential credential)
              verificationCompleted,
          required void Function(FirebaseAuthException error) verificationFailed,
          required void Function(String verificationId, int? resendToken) codeSent,
          required void Function(String verificationId)
              codeAutoRetrievalTimeout,
          Duration? timeout,
          int? forceResendingToken,
        }) async {
          codeSent('   ', null);
        },
      );

      final IntegrationResult<AuthenticationState> result =
          await repository.beginPhoneAuthentication(
        AuthenticationFlow.signIn,
        '+966501234567',
      );

      expect(result, isA<IntegrationError<AuthenticationState>>());
    });

    test('verifyCode rejects missing verificationId without crash', () async {
      final FirebaseAuthenticationRepository repository =
          FirebaseAuthenticationRepository(
        phoneVerificationStarter: ({
          required String phoneNumber,
          required void Function(PhoneAuthCredential credential)
              verificationCompleted,
          required void Function(FirebaseAuthException error) verificationFailed,
          required void Function(String verificationId, int? resendToken) codeSent,
          required void Function(String verificationId)
              codeAutoRetrievalTimeout,
          Duration? timeout,
          int? forceResendingToken,
        }) async {},
      );

      final IntegrationResult<AuthenticationState> result =
          await repository.verifyCode(
        const AuthenticationState(
          flow: AuthenticationFlow.signIn,
          phone: '+966501234567',
          isOtpVerified: false,
        ),
        '123456',
      );

      expect(result, isA<IntegrationError<AuthenticationState>>());
      expect(
        (result as IntegrationError<AuthenticationState>).failure.kind,
        IntegrationFailureKind.validation,
      );
    });

    test('timeout path completes with network failure', () async {
      final FirebaseAuthenticationRepository repository =
          FirebaseAuthenticationRepository(
        verificationTimeout: const Duration(milliseconds: 20),
        phoneVerificationStarter: ({
          required String phoneNumber,
          required void Function(PhoneAuthCredential credential)
              verificationCompleted,
          required void Function(FirebaseAuthException error) verificationFailed,
          required void Function(String verificationId, int? resendToken) codeSent,
          required void Function(String verificationId)
              codeAutoRetrievalTimeout,
          Duration? timeout,
          int? forceResendingToken,
        }) async {
          // Never invoke callbacks — simulates hung native flow.
        },
      );

      final IntegrationResult<AuthenticationState> result =
          await repository.beginPhoneAuthentication(
        AuthenticationFlow.signIn,
        '+966501234567',
      );

      expect(result, isA<IntegrationError<AuthenticationState>>());
      expect(
        (result as IntegrationError<AuthenticationState>).failure.kind,
        IntegrationFailureKind.network,
      );
    });
  });
}
