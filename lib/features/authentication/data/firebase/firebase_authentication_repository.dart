import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/authentication_state.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../http/auth_api_client.dart';

typedef PhoneVerificationStarter = Future<void> Function({
  required String phoneNumber,
  required void Function(PhoneAuthCredential credential) verificationCompleted,
  required void Function(FirebaseAuthException error) verificationFailed,
  required void Function(String verificationId, int? resendToken) codeSent,
  required void Function(String verificationId) codeAutoRetrievalTimeout,
  Duration? timeout,
  int? forceResendingToken,
});

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  FirebaseAuthenticationRepository({
    FirebaseAuth? firebaseAuth,
    AuthApiClient? authApiClient,
    PhoneVerificationStarter? phoneVerificationStarter,
    this.verificationTimeout = const Duration(seconds: 60),
  })  : _firebaseAuthOverride = firebaseAuth,
        _authApiClient = authApiClient,
        _phoneVerificationStarterOverride = phoneVerificationStarter;

  final FirebaseAuth? _firebaseAuthOverride;
  final AuthApiClient? _authApiClient;
  final PhoneVerificationStarter? _phoneVerificationStarterOverride;
  final Duration verificationTimeout;

  FirebaseAuth get _firebaseAuth =>
      _firebaseAuthOverride ?? FirebaseAuth.instance;

  PhoneVerificationStarter get _phoneVerificationStarter =>
      _phoneVerificationStarterOverride ??
      _defaultPhoneVerificationStarter(_firebaseAuth);

  static final RegExp _e164Pattern = RegExp(r'^\+[1-9]\d{7,14}$');

  static PhoneVerificationStarter _defaultPhoneVerificationStarter(
    FirebaseAuth firebaseAuth,
  ) {
    return ({
      required String phoneNumber,
      required void Function(PhoneAuthCredential credential) verificationCompleted,
      required void Function(FirebaseAuthException error) verificationFailed,
      required void Function(String verificationId, int? resendToken) codeSent,
      required void Function(String verificationId) codeAutoRetrievalTimeout,
      Duration? timeout,
      int? forceResendingToken,
    }) {
      return firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: timeout ?? const Duration(seconds: 60),
        forceResendingToken: forceResendingToken,
      );
    };
  }

  @override
  bool isValidKsaPhone(String phone) =>
      phone.trim().startsWith('+966') && _e164Pattern.hasMatch(phone.trim());

  @override
  Future<IntegrationResult<AuthenticationState>> beginPhoneAuthentication(
    AuthenticationFlow flow,
    String phone,
  ) async {
    final String normalizedPhone = phone.trim();
    if (!isValidKsaPhone(normalizedPhone)) {
      return const IntegrationError<AuthenticationState>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }

    final Completer<IntegrationResult<AuthenticationState>> completer =
        Completer<IntegrationResult<AuthenticationState>>();

    void completeOnce(IntegrationResult<AuthenticationState> result) {
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    }

    Timer? timeoutTimer;
    timeoutTimer = Timer(verificationTimeout + const Duration(seconds: 5), () {
      completeOnce(
        const IntegrationError<AuthenticationState>(
          IntegrationFailure(
            IntegrationFailureKind.network,
            message: 'Phone verification timed out. Please try again.',
          ),
        ),
      );
    });

    try {
      await _phoneVerificationStarter(
        phoneNumber: normalizedPhone,
        timeout: verificationTimeout,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _firebaseAuth.signInWithCredential(credential);
            final IntegrationResult<AuthenticationState> verified =
                await _stateAfterSignIn(
              AuthenticationState(
                flow: flow,
                phone: normalizedPhone,
                isOtpVerified: true,
              ),
            );
            completeOnce(verified);
          } on FirebaseAuthException catch (error) {
            completeOnce(_authError(error));
          } catch (_) {
            completeOnce(
              const IntegrationError<AuthenticationState>(
                IntegrationFailure(IntegrationFailureKind.unknown),
              ),
            );
          }
        },
        verificationFailed: (FirebaseAuthException error) {
          completeOnce(_authError(error));
        },
        codeSent: (String verificationId, int? resendToken) {
          if (verificationId.trim().isEmpty) {
            completeOnce(
              const IntegrationError<AuthenticationState>(
                IntegrationFailure(
                  IntegrationFailureKind.unknown,
                  message: 'Missing verification ID from Firebase Phone Auth.',
                ),
              ),
            );
            return;
          }
          completeOnce(
            IntegrationSuccess<AuthenticationState>(
              AuthenticationState(
                flow: flow,
                phone: normalizedPhone,
                verificationId: verificationId,
                forceResendingToken: resendToken,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Prefer codeSent; if it never fired, keep a usable verificationId.
          if (completer.isCompleted || verificationId.trim().isEmpty) {
            return;
          }
          completeOnce(
            IntegrationSuccess<AuthenticationState>(
              AuthenticationState(
                flow: flow,
                phone: normalizedPhone,
                verificationId: verificationId,
              ),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      completeOnce(_authError(error));
    } catch (error) {
      completeOnce(
        IntegrationError<AuthenticationState>(
          IntegrationFailure(
            IntegrationFailureKind.unknown,
            message: error.toString(),
          ),
        ),
      );
    }

    try {
      return await completer.future;
    } finally {
      timeoutTimer.cancel();
    }
  }

  @override
  Future<IntegrationResult<AuthenticationState>> verifyCode(
    AuthenticationState state,
    String code,
  ) async {
    final String trimmedCode = code.trim();
    final String? verificationId = state.verificationId?.trim();
    if (trimmedCode.isEmpty ||
        state.flow == null ||
        state.phone.isEmpty ||
        verificationId == null ||
        verificationId.isEmpty) {
      return const IntegrationError<AuthenticationState>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: trimmedCode,
      );
      await _firebaseAuth.signInWithCredential(credential);
      return _stateAfterSignIn(state.copyWith(isOtpVerified: true));
    } on FirebaseAuthException catch (error) {
      return _authError(error);
    } catch (_) {
      return const IntegrationError<AuthenticationState>(
        IntegrationFailure(IntegrationFailureKind.unknown),
      );
    }
  }

  @override
  Future<IntegrationResult<AuthenticationState>> completeRegistration(
    AuthenticationState state, {
    required String fullName,
    required bool hasAcceptedTerms,
  }) async {
    if (!state.isOtpVerified || !hasAcceptedTerms || fullName.trim().isEmpty) {
      return const IntegrationError<AuthenticationState>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }

    final AuthApiClient? authApiClient = _authApiClient;
    if (authApiClient == null) {
      return const IntegrationError<AuthenticationState>(
        IntegrationFailure(IntegrationFailureKind.unknown),
      );
    }

    final IntegrationResult<Object?> bootstrap = await authApiClient.bootstrap(
      fullName: fullName.trim(),
      locale: 'ar',
    );
    if (bootstrap case IntegrationError<Object?>(:final failure)) {
      return IntegrationError<AuthenticationState>(failure);
    }

    return IntegrationSuccess<AuthenticationState>(
      state.copyWith(
        fullName: fullName.trim(),
        hasAcceptedTerms: true,
        isComplete: true,
      ),
    );
  }

  Future<IntegrationResult<AuthenticationState>> _stateAfterSignIn(
    AuthenticationState state,
  ) async {
    if (state.flow == AuthenticationFlow.registration) {
      return IntegrationSuccess<AuthenticationState>(state);
    }

    final AuthApiClient? authApiClient = _authApiClient;
    if (authApiClient == null) {
      return IntegrationSuccess<AuthenticationState>(
        state.copyWith(isComplete: true),
      );
    }

    final IntegrationResult<Object?> currentUser =
        await authApiClient.getCurrentUser();
    if (currentUser case IntegrationSuccess<Object?>()) {
      return IntegrationSuccess<AuthenticationState>(
        state.copyWith(isComplete: true),
      );
    }
    if (currentUser case IntegrationError<Object?>(:final failure)) {
      if (failure.kind == IntegrationFailureKind.notFound) {
        return IntegrationSuccess<AuthenticationState>(
          state.copyWith(needsProfileBootstrap: true),
        );
      }
      return IntegrationError<AuthenticationState>(failure);
    }

    return IntegrationSuccess<AuthenticationState>(state);
  }

  IntegrationError<AuthenticationState> _authError(FirebaseAuthException error) {
    return IntegrationError<AuthenticationState>(
      IntegrationFailure(
        IntegrationFailureKind.validation,
        message: error.message ?? error.code,
      ),
    );
  }
}
