import 'app_environment.dart';

class EnvironmentConfig {
  const EnvironmentConfig({required this.environment});

  factory EnvironmentConfig.fromDartDefine() {
    const String configuredEnvironment = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    return EnvironmentConfig(
      environment: AppEnvironment.fromName(configuredEnvironment),
    );
  }

  final AppEnvironment environment;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.production;
}
