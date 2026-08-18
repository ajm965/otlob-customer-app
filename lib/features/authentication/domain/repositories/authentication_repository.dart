import '../../../../core/errors/integration_failure.dart';
import '../models/authentication_state.dart';

abstract interface class AuthenticationRepository {
  bool isValidKsaPhone(String phone);

  Future<IntegrationResult<AuthenticationState>> beginPhoneAuthentication(
    AuthenticationFlow flow,
    String phone,
  );

  Future<IntegrationResult<AuthenticationState>> verifyCode(
    AuthenticationState state,
    String code,
  );

  Future<IntegrationResult<AuthenticationState>> completeRegistration(
    AuthenticationState state, {
    required String fullName,
    required bool hasAcceptedTerms,
  });
}
