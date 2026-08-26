import 'package:flutter/foundation.dart';

import '../../features/authentication/domain/models/authentication_state.dart';
import '../router/app_route.dart';

/// Holds in-progress phone auth state at app level so GoRouter can resume the
/// correct step after the iOS reCAPTCHA web view dismisses.
class AuthFlowCoordinator extends ChangeNotifier {
  AuthenticationState _state = const AuthenticationState();
  bool _isVerifying = false;

  AuthenticationState get state => _state;

  bool get isVerifying => _isVerifying;

  String? get resumeLocation {
    final AuthenticationState auth = _state;
    if (_isVerifying || auth.flow == null || auth.phone.isEmpty) {
      return null;
    }
    if (auth.isComplete) {
      return null;
    }
    if (auth.isOtpVerified) {
      if (auth.flow == AuthenticationFlow.registration ||
          auth.needsProfileBootstrap) {
        return AppRoute.registrationProfile.path;
      }
      return AppRoute.authenticationSuccess.path;
    }
    if (auth.verificationId != null && auth.verificationId!.isNotEmpty) {
      return auth.flow == AuthenticationFlow.registration
          ? AppRoute.registrationVerification.path
          : AppRoute.signInVerification.path;
    }
    return null;
  }

  Uri? get resumeUri {
    final String? location = resumeLocation;
    if (location == null) {
      return null;
    }
    if (_state.phone.isEmpty) {
      return Uri(path: location);
    }
    return Uri(
      path: location,
      queryParameters: <String, String>{'phone': _state.phone},
    );
  }

  void markVerifying(AuthenticationFlow flow, String phone) {
    _isVerifying = true;
    _state = AuthenticationState(flow: flow, phone: phone.trim());
    notifyListeners();
  }

  void markReady(AuthenticationState state) {
    _isVerifying = false;
    _state = state.isComplete ? const AuthenticationState() : state;
    notifyListeners();
  }

  void markFailed() {
    _isVerifying = false;
    final bool hasPendingVerification =
        _state.verificationId != null && _state.verificationId!.isNotEmpty;
    if (!hasPendingVerification) {
      _state = const AuthenticationState();
    }
    notifyListeners();
  }

  void resetInFlight() {
    _isVerifying = false;
    notifyListeners();
  }

  void clear() {
    _isVerifying = false;
    _state = const AuthenticationState();
    notifyListeners();
  }
}
