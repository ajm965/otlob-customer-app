import '../environment/environment_config.dart';

class AppConfig {
  const AppConfig({required this.environment, this.initialLocale});

  factory AppConfig.fromEnvironment(EnvironmentConfig environment) {
    return AppConfig(environment: environment);
  }

  final EnvironmentConfig environment;
  final String? initialLocale;

  String get apiBaseUrl => environment.apiBaseUrl;
}
