import '../domain/models/authentication_state.dart';
import '../../../core/router/app_route.dart';

abstract final class AuthFlowNavigation {
  static String verificationPath({
    required AuthenticationFlow flow,
    required String phone,
  }) {
    final String path = flow == AuthenticationFlow.registration
        ? AppRoute.registrationVerification.path
        : AppRoute.signInVerification.path;
    return Uri(
      path: path,
      queryParameters: <String, String>{'phone': phone.trim()},
    ).toString();
  }
}
