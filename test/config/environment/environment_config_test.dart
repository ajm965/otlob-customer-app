import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/config/app_config/app_config.dart';
import 'package:otlob_customer_app/config/environment/app_environment.dart';
import 'package:otlob_customer_app/config/environment/environment_config.dart';
import 'package:otlob_customer_app/config/flavors/app_flavor.dart';

void main() {
  group('EnvironmentConfig', () {
    test('exposes environment state without endpoint or credential data', () {
      const EnvironmentConfig config = EnvironmentConfig(
        environment: AppEnvironment.staging,
      );

      expect(config.isDevelopment, isFalse);
      expect(config.isStaging, isTrue);
      expect(config.isProduction, isFalse);
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
    expect(
      AppFlavor.fromEnvironment(config.environment.environment),
      AppFlavor.production,
    );
  });
}
