enum AuthenticationFlow { signIn, registration }

class AuthenticationState {
  const AuthenticationState({
    this.flow,
    this.phone = '',
    this.verificationId,
    this.forceResendingToken,
    this.isOtpVerified = false,
    this.fullName = '',
    this.hasAcceptedTerms = false,
    this.isComplete = false,
    this.needsProfileBootstrap = false,
  });

  final AuthenticationFlow? flow;
  final String phone;
  final String? verificationId;
  final int? forceResendingToken;
  final bool isOtpVerified;
  final String fullName;
  final bool hasAcceptedTerms;
  final bool isComplete;
  final bool needsProfileBootstrap;

  AuthenticationState copyWith({
    AuthenticationFlow? flow,
    String? phone,
    String? verificationId,
    int? forceResendingToken,
    bool? isOtpVerified,
    String? fullName,
    bool? hasAcceptedTerms,
    bool? isComplete,
    bool? needsProfileBootstrap,
  }) {
    return AuthenticationState(
      flow: flow ?? this.flow,
      phone: phone ?? this.phone,
      verificationId: verificationId ?? this.verificationId,
      forceResendingToken: forceResendingToken ?? this.forceResendingToken,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      fullName: fullName ?? this.fullName,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      isComplete: isComplete ?? this.isComplete,
      needsProfileBootstrap: needsProfileBootstrap ?? this.needsProfileBootstrap,
    );
  }
}
