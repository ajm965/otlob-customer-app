import 'app_environment.dart';

class EnvironmentConfig {
  const EnvironmentConfig({
    required this.environment,
    this.apiBaseUrl = defaultApiBaseUrl,
  });

  factory EnvironmentConfig.fromDartDefine() {
    const String configuredEnvironment = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    const String configuredApiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: defaultApiBaseUrl,
    );
    return EnvironmentConfig(
      environment: AppEnvironment.fromName(configuredEnvironment),
      apiBaseUrl: configuredApiBaseUrl,
    );
  }

  /// Local placeholder origin. Override with `--dart-define=API_BASE_URL=...`.
  /// This is not a production host.
  static const String defaultApiBaseUrl = 'http://127.0.0.1:8080';

  final AppEnvironment environment;
  final String apiBaseUrl;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.production;
}
