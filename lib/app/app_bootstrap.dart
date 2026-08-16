import 'package:flutter/widgets.dart';

import '../config/app_config/app_config.dart';
import '../config/environment/environment_config.dart';
import '../core/errors/bootstrap_error_handler.dart';
import '../core/router/app_router.dart';
import 'otlob_app.dart';

abstract final class AppBootstrap {
  static Future<void> run({
    EnvironmentConfig? environment,
    BootstrapErrorHandler? errorHandler,
  }) async {
    final BootstrapErrorHandler handler =
        errorHandler ?? BootstrapErrorHandler();
    handler.installFrameworkBoundary();

    await handler.run(() async {
      final EnvironmentConfig resolvedEnvironment =
          environment ?? EnvironmentConfig.fromDartDefine();
      final AppConfig config = AppConfig.fromEnvironment(resolvedEnvironment);
      final AppRouter router = AppRouter();

      runApp(OtlobApp(config: config, router: router));
    });
  }
}
