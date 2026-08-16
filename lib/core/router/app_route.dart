enum AppRoute {
  authentication('/auth'),
  signIn('/auth/sign-in'),
  signInVerification('/auth/sign-in/verification'),
  registration('/auth/registration'),
  registrationVerification('/auth/registration/verification'),
  registrationProfile('/auth/registration/profile'),
  authenticationSuccess('/auth/success'),
  home('/home'),
  services('/services'),
  requests('/requests'),
  requestDetail('/requests/:requestId'),
  profile('/profile'),
  requestStart('/request/new/:serviceId'),
  requestDetails('/request/new/:serviceId/details'),
  requestLocation('/request/new/:serviceId/location'),
  requestReview('/request/new/:serviceId/review'),
  requestSuccess('/request/new/:serviceId/success');

  const AppRoute(this.path);

  final String path;

  String pathForService(String serviceId) {
    assert(path.contains(':serviceId'), 'Route does not accept a service ID.');
    return path.replaceFirst(':serviceId', Uri.encodeComponent(serviceId));
  }

  String pathForRequest(String requestId) {
    assert(path.contains(':requestId'), 'Route does not accept a request ID.');
    return path.replaceFirst(':requestId', Uri.encodeComponent(requestId));
  }
}
