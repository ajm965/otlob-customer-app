enum AuthenticationFlow { signIn, registration }

class AuthenticationState {
  const AuthenticationState({
    this.flow,
    this.phone = '',
    this.isOtpVerified = false,
    this.fullName = '',
    this.hasAcceptedTerms = false,
    this.isComplete = false,
  });

  final AuthenticationFlow? flow;
  final String phone;
  final bool isOtpVerified;
  final String fullName;
  final bool hasAcceptedTerms;
  final bool isComplete;

  AuthenticationState copyWith({
    AuthenticationFlow? flow,
    String? phone,
    bool? isOtpVerified,
    String? fullName,
    bool? hasAcceptedTerms,
    bool? isComplete,
  }) {
    return AuthenticationState(
      flow: flow ?? this.flow,
      phone: phone ?? this.phone,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      fullName: fullName ?? this.fullName,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
