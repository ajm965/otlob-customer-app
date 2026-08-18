import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/config/app_config/app_config.dart';
import 'package:otlob_customer_app/config/environment/app_environment.dart';
import 'package:otlob_customer_app/config/environment/environment_config.dart';
import 'package:otlob_customer_app/config/flavors/app_flavor.dart';

void main() {
  group('EnvironmentConfig', () {
  test('exposes environment state and a configurable API base URL placeholder', () {
    const EnvironmentConfig config = EnvironmentConfig(
      environment: AppEnvironment.staging,
    );

    expect(config.isDevelopment, isFalse);
    expect(config.isStaging, isTrue);
    expect(config.isProduction, isFalse);
    expect(config.apiBaseUrl, EnvironmentConfig.defaultApiBaseUrl);
    expect(config.apiBaseUrl, 'http://127.0.0.1:8080');
  });

  test('accepts an explicit non-production API base URL', () {
    const EnvironmentConfig config = EnvironmentConfig(
      environment: AppEnvironment.development,
      apiBaseUrl: 'http://127.0.0.1:9000',
    );

    expect(config.apiBaseUrl, 'http://127.0.0.1:9000');
  });

    test('rejects unsupported environment names', () {
      expect(() => AppEnvironment.fromName('preview'), throwsArgumentError);
    });
  });

  test('app config and flavor derive from the injected environment', () {
    const EnvironmentConfig environment = EnvironmentConfig(
      environment: AppEnvironment.production,
    );
    final AppConfig config = AppConfig.fromEnvironment(environment);

    expect(config.environment, same(environment));
    expect(config.apiBaseUrl, EnvironmentConfig.defaultApiBaseUrl);
    expect(
      AppFlavor.fromEnvironment(config.environment.environment),
      AppFlavor.production,
    );
  });
}
