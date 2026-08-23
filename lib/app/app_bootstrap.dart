import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../config/app_config/app_config.dart';
import '../config/environment/environment_config.dart';
import '../core/errors/bootstrap_error_handler.dart';
import '../core/network/platform_api_client.dart';
import '../core/router/app_router.dart';
import '../features/addresses/data/http/http_customer_address_repository.dart';
import '../features/requests/data/http/http_customer_request_repository.dart';
import '../features/services/data/cached/caching_service_catalog_repository.dart';
import '../features/services/data/http/http_service_catalog_repository.dart';
import '../features/services/domain/repositories/service_catalog_repository.dart';
import '../firebase_options.dart';
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
      WidgetsFlutterBinding.ensureInitialized();

      final EnvironmentConfig resolvedEnvironment =
          environment ?? EnvironmentConfig.fromDartDefine();

      final AppConfig config = AppConfig.fromEnvironment(resolvedEnvironment);

      final PlatformApiClient apiClient = PlatformApiClient(
        client: http.Client(),
        baseUrl: config.apiBaseUrl,
      );

      final ServiceCatalogRepository serviceRepository =
          CachingServiceCatalogRepository(
            delegate: HttpServiceCatalogRepository(apiClient: apiClient),
          );

      final AppRouter router = AppRouter(
        serviceRepository: serviceRepository,
        requestRepository: HttpCustomerRequestRepository(apiClient: apiClient),
        addressRepository: HttpCustomerAddressRepository(apiClient: apiClient),
      );

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      runApp(OtlobApp(config: config, router: router));
    });
  }
}
