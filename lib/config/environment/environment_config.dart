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

  /// Override with `--dart-define=API_BASE_URL=...` for a local backend.
  /// Default targets the deployed otlob-platform-dev API for device/simulator runs.
  static const String defaultApiBaseUrl =
      'https://api-lfp2bv24wq-ew.a.run.app';

  final AppEnvironment environment;
  final String apiBaseUrl;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.production;
}
