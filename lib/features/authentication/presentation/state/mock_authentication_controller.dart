import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/authentication_state.dart';
import '../../domain/repositories/authentication_repository.dart';

final Provider<AuthenticationRepository> authenticationRepositoryProvider =
    Provider<AuthenticationRepository>(
      (Ref ref) =>
          throw StateError('Authentication repository was not provided.'),
    );

final NotifierProvider<MockAuthenticationController, AuthenticationState>
mockAuthenticationProvider =
    NotifierProvider<MockAuthenticationController, AuthenticationState>(
      MockAuthenticationController.new,
    );

class MockAuthenticationController extends Notifier<AuthenticationState> {
  @override
  AuthenticationState build() => const AuthenticationState();

  bool isValidKsaPhone(String value) =>
      ref.read(authenticationRepositoryProvider).isValidKsaPhone(value);

  Future<bool> begin(AuthenticationFlow flow, String phone) async {
    final IntegrationResult<AuthenticationState> result = await ref
        .read(authenticationRepositoryProvider)
        .beginPhoneAuthentication(flow, phone);
    if (result case IntegrationSuccess<AuthenticationState>(:final value)) {
      state = value;
      return true;
    }
    return false;
  }

  Future<bool> verifyOtpLocally(String otp) async {
    final IntegrationResult<AuthenticationState> result = await ref
        .read(authenticationRepositoryProvider)
        .verifyCode(state, otp);
    if (result case IntegrationSuccess<AuthenticationState>(:final value)) {
      state = value;
      return true;
    }
    return false;
  }

  Future<bool> completeRegistration({
    required String fullName,
    required bool hasAcceptedTerms,
  }) async {
    final IntegrationResult<AuthenticationState> result = await ref
        .read(authenticationRepositoryProvider)
        .completeRegistration(
          state,
          fullName: fullName,
          hasAcceptedTerms: hasAcceptedTerms,
        );
    if (result case IntegrationSuccess<AuthenticationState>(:final value)) {
      state = value;
      return true;
    }
    return false;
  }
}
