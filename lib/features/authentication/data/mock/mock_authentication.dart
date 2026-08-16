enum MockAuthenticationFlow { signIn, registration }

class MockAuthenticationState {
  const MockAuthenticationState({
    this.flow,
    this.phone = '',
    this.isOtpVerified = false,
    this.fullName = '',
    this.hasAcceptedTerms = false,
    this.isComplete = false,
  });

  final MockAuthenticationFlow? flow;
  final String phone;
  final bool isOtpVerified;
  final String fullName;
  final bool hasAcceptedTerms;
  final bool isComplete;

  MockAuthenticationState copyWith({
    MockAuthenticationFlow? flow,
    String? phone,
    bool? isOtpVerified,
    String? fullName,
    bool? hasAcceptedTerms,
    bool? isComplete,
  }) {
    return MockAuthenticationState(
      flow: flow ?? this.flow,
      phone: phone ?? this.phone,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      fullName: fullName ?? this.fullName,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
