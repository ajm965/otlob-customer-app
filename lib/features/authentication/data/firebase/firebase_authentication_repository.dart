import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/authentication_state.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../http/auth_api_client.dart';

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  FirebaseAuthenticationRepository({
    FirebaseAuth? firebaseAuth,
    AuthApiClient? authApiClient,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _authApiClient = authApiClient;

  final FirebaseAuth _firebaseAuth;
  final AuthApiClient? _authApiClient;

  static final RegExp _e164Pattern = RegExp(r'^\+[1-9]\d{7,14}$');

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

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: normalizedPhone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (completer.isCompleted) {
          return;
        }
        try {
          await _firebaseAuth.signInWithCredential(credential);
          final IntegrationResult<AuthenticationState> verified =
              await _stateAfterSignIn(
            AuthenticationState(flow: flow, phone: normalizedPhone, isOtpVerified: true),
          );
          completer.complete(verified);
        } on FirebaseAuthException catch (error) {
          completer.complete(_authError(error));
        } catch (_) {
          completer.complete(
            const IntegrationError<AuthenticationState>(
              IntegrationFailure(IntegrationFailureKind.unknown),
            ),
          );
        }
      },
      verificationFailed: (FirebaseAuthException error) {
        if (!completer.isCompleted) {
          completer.complete(_authError(error));
        }
      },
      codeSent: (String verificationId, int? _) {
        if (!completer.isCompleted) {
          completer.complete(
            IntegrationSuccess<AuthenticationState>(
              AuthenticationState(
                flow: flow,
                phone: normalizedPhone,
                verificationId: verificationId,
              ),
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return completer.future;
  }

  @override
  Future<IntegrationResult<AuthenticationState>> verifyCode(
    AuthenticationState state,
    String code,
  ) async {
    final String trimmedCode = code.trim();
    if (trimmedCode.isEmpty ||
        state.flow == null ||
        state.phone.isEmpty ||
        state.verificationId == null) {
      return const IntegrationError<AuthenticationState>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
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

    final IntegrationResult<Object?> currentUser = await authApiClient.getCurrentUser();
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
        message: error.message,
      ),
    );
  }
}
