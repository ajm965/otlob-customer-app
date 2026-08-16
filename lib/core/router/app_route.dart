enum AppRoute {
  home('/home'),
  services('/services'),
  requests('/requests'),
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
}
