enum AppRoute {
  home('/home'),
  services('/services'),
  requests('/requests'),
  profile('/profile');

  const AppRoute(this.path);

  final String path;
}
