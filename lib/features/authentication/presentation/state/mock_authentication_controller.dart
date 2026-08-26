import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_flow_coordinator.dart';
import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/authentication_state.dart';
import '../../domain/repositories/authentication_repository.dart';

final Provider<AuthenticationRepository> authenticationRepositoryProvider =
    Provider<AuthenticationRepository>(
      (Ref ref) =>
          throw StateError('Authentication repository was not provided.'),
    );

final Provider<AuthFlowCoordinator?> authFlowCoordinatorProvider =
    Provider<AuthFlowCoordinator?>((Ref ref) => null);

final NotifierProvider<MockAuthenticationController, AuthenticationState>
mockAuthenticationProvider =
    NotifierProvider<MockAuthenticationController, AuthenticationState>(
      MockAuthenticationController.new,
    );

class MockAuthenticationController extends Notifier<AuthenticationState> {
  String? lastBeginError;
  String? lastCompleteError;

  @override
  AuthenticationState build() => const AuthenticationState();

  bool isValidKsaPhone(String value) =>
      ref.read(authenticationRepositoryProvider).isValidKsaPhone(value);

  /// Restores flow state saved by [AuthFlowCoordinator] after reCAPTCHA handoff.
  void syncFromCoordinator() {
    final AuthFlowCoordinator? coordinator = ref.read(authFlowCoordinatorProvider);
    if (coordinator == null) {
      return;
    }
    final AuthenticationState coordinatorState = coordinator.state;
    if (coordinatorState.phone.isEmpty) {
      return;
    }
    if (state.verificationId == null &&
        coordinatorState.verificationId != null) {
      state = coordinatorState;
      return;
    }
    if (state.phone.isEmpty) {
      state = coordinatorState;
    }
  }

  void restore(AuthenticationState value) {
    state = value;
  }

  Future<bool> begin(AuthenticationFlow flow, String phone) async {
    lastBeginError = null;
    final AuthFlowCoordinator? coordinator = ref.read(authFlowCoordinatorProvider);
    if (coordinator?.isVerifying ?? false) {
      coordinator?.resetInFlight();
    }
    coordinator?.markVerifying(flow, phone);
    final IntegrationResult<AuthenticationState> result = await ref
        .read(authenticationRepositoryProvider)
        .beginPhoneAuthentication(flow, phone);
    if (result case IntegrationSuccess<AuthenticationState>(:final value)) {
      state = value;
      coordinator?.markReady(value);
      return true;
    }
    if (result case IntegrationError<AuthenticationState>(:final failure)) {
      lastBeginError = failure.message ?? failure.kind.name;
    }
    coordinator?.markFailed();
    return false;
  }

  Future<bool> verifyOtpLocally(String otp) async {
    final IntegrationResult<AuthenticationState> result = await ref
        .read(authenticationRepositoryProvider)
        .verifyCode(state, otp);
    if (result case IntegrationSuccess<AuthenticationState>(:final value)) {
      state = value;
      ref.read(authFlowCoordinatorProvider)?.markReady(value);
      return true;
    }
    return false;
  }

  Future<bool> completeRegistration({
    required String fullName,
    required bool hasAcceptedTerms,
  }) async {
    lastCompleteError = null;
    final IntegrationResult<AuthenticationState> result = await ref
        .read(authenticationRepositoryProvider)
        .completeRegistration(
          state,
          fullName: fullName,
          hasAcceptedTerms: hasAcceptedTerms,
        );
    if (result case IntegrationSuccess<AuthenticationState>(:final value)) {
      state = value;
      ref.read(authFlowCoordinatorProvider)?.markReady(value);
      return true;
    }
    if (result case IntegrationError<AuthenticationState>(:final failure)) {
      lastCompleteError = failure.message ?? failure.kind.name;
    }
    return false;
  }
}
