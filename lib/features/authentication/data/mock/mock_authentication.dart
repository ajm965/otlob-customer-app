import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/authentication_state.dart';
import '../../domain/repositories/authentication_repository.dart';

typedef MockAuthenticationFlow = AuthenticationFlow;
typedef MockAuthenticationState = AuthenticationState;

class MockAuthenticationRepository implements AuthenticationRepository {
  const MockAuthenticationRepository();

  static final RegExp _e164Pattern = RegExp(r'^\+[1-9]\d{7,14}$');

  @override
  bool isValidKsaPhone(String phone) =>
      phone.trim().startsWith('+966') && _e164Pattern.hasMatch(phone.trim());

  @override
  Future<IntegrationResult<AuthenticationState>> beginPhoneAuthentication(
    AuthenticationFlow flow,
    String phone,
  ) async => IntegrationSuccess<AuthenticationState>(
    AuthenticationState(flow: flow, phone: phone.trim()),
  );

  @override
  Future<IntegrationResult<AuthenticationState>> verifyCode(
    AuthenticationState state,
    String code,
  ) async {
    if (code.trim().isEmpty || state.flow == null || state.phone.isEmpty) {
      return const IntegrationError<AuthenticationState>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }
    AuthenticationState verified = state.copyWith(isOtpVerified: true);
    if (state.flow == AuthenticationFlow.signIn) {
      verified = verified.copyWith(isComplete: true);
    }
    return IntegrationSuccess<AuthenticationState>(verified);
  }

  @override
  Future<IntegrationResult<AuthenticationState>> completeRegistration(
    AuthenticationState state, {
    required String fullName,
    required bool hasAcceptedTerms,
  }) async {
    if (state.flow != AuthenticationFlow.registration ||
        !state.isOtpVerified ||
        !hasAcceptedTerms) {
      return const IntegrationError<AuthenticationState>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }
    return IntegrationSuccess<AuthenticationState>(
      state.copyWith(
        fullName: fullName.trim(),
        hasAcceptedTerms: true,
        isComplete: true,
      ),
    );
  }
}
