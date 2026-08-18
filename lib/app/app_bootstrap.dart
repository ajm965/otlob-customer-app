import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../config/app_config/app_config.dart';
import '../config/environment/environment_config.dart';
import '../core/errors/bootstrap_error_handler.dart';
import '../core/network/platform_api_client.dart';
import '../core/router/app_router.dart';
import '../features/services/data/http/http_service_catalog_repository.dart';
import '../firebase_options.dart';
import 'otlob_app.dart';

abstract final class AppBootstrap {
  static Future<void> run({
    EnvironmentConfig? environment,
    BootstrapErrorHandler? errorHandler,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    final BootstrapErrorHandler handler =
        errorHandler ?? BootstrapErrorHandler();
    handler.installFrameworkBoundary();

    await handler.run(() async {
      final EnvironmentConfig resolvedEnvironment =
          environment ?? EnvironmentConfig.fromDartDefine();
      final AppConfig config = AppConfig.fromEnvironment(resolvedEnvironment);
      final AppRouter router = AppRouter(
        serviceRepository: HttpServiceCatalogRepository(
          apiClient: PlatformApiClient(
            client: http.Client(),
            baseUrl: config.apiBaseUrl,
          ),
        ),
      );

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      runApp(OtlobApp(config: config, router: router));
    });
  }
}
