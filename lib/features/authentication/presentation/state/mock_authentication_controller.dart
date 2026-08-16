import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/mock_authentication.dart';

final NotifierProvider<MockAuthenticationController, MockAuthenticationState>
mockAuthenticationProvider =
    NotifierProvider<MockAuthenticationController, MockAuthenticationState>(
      MockAuthenticationController.new,
    );

class MockAuthenticationController extends Notifier<MockAuthenticationState> {
  static final RegExp _e164Pattern = RegExp(r'^\+[1-9]\d{7,14}$');

  @override
  MockAuthenticationState build() => const MockAuthenticationState();

  static bool isValidKsaPhone(String value) {
    final String phone = value.trim();
    return phone.startsWith('+966') && _e164Pattern.hasMatch(phone);
  }

  void begin(MockAuthenticationFlow flow, String phone) {
    state = MockAuthenticationState(flow: flow, phone: phone.trim());
  }

  bool verifyOtpLocally(String otp) {
    if (otp.trim().isEmpty || state.flow == null || state.phone.isEmpty) {
      return false;
    }
    state = state.copyWith(isOtpVerified: true);
    if (state.flow == MockAuthenticationFlow.signIn) {
      state = state.copyWith(isComplete: true);
    }
    return true;
  }

  bool completeRegistration({
    required String fullName,
    required bool hasAcceptedTerms,
  }) {
    if (state.flow != MockAuthenticationFlow.registration ||
        !state.isOtpVerified ||
        !hasAcceptedTerms) {
      return false;
    }
    state = state.copyWith(
      fullName: fullName.trim(),
      hasAcceptedTerms: true,
      isComplete: true,
    );
    return true;
  }
}
