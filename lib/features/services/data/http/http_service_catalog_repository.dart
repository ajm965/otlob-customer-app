import '../../../../core/errors/integration_failure.dart';
import '../../../../core/network/platform_api_client.dart';
import '../../domain/models/customer_service.dart';
import '../../domain/repositories/service_catalog_repository.dart';
import 'catalog_json.dart';

class HttpServiceCatalogRepository implements ServiceCatalogRepository {
  const HttpServiceCatalogRepository({required this.apiClient});

  final PlatformApiClient apiClient;

  static const Map<String, String> _activeOnly = <String, String>{
    'activeOnly': 'true',
  };

  @override
  Future<IntegrationResult<List<ServiceCategory>>> listCategories() {
    return _getList('/v1/categories', parseCategory);
  }

  @override
  Future<IntegrationResult<List<CustomerService>>> listServices() {
    return _getList('/v1/services', parseService);
  }

  @override
  Future<IntegrationResult<CustomerService?>> getService(String serviceId) async {
    final String trimmedId = serviceId.trim();
    if (trimmedId.isEmpty) {
      return const IntegrationError<CustomerService?>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }

    final IntegrationResult<Object?> result = await apiClient.get(
      '/v1/services/${Uri.encodeComponent(trimmedId)}',
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<CustomerService?>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseService(value)),
    };
  }

  Future<IntegrationResult<List<T>>> _getList<T>(
    String path,
    T Function(Object? json) parseItem,
  ) async {
    final IntegrationResult<Object?> result = await apiClient.get(
      path,
      query: _activeOnly,
    );
    return switch (result) {
      IntegrationError<Object?>(:final IntegrationFailure failure) =>
        IntegrationError<List<T>>(failure),
      IntegrationSuccess<Object?>(:final Object? value) =>
        _parse(() => parseCatalogItems(value, parseItem)),
    };
  }

  IntegrationResult<T> _parse<T>(T Function() parse) {
    try {
      return IntegrationSuccess<T>(parse());
    } on FormatException catch (error) {
      return IntegrationError<T>(
        IntegrationFailure(IntegrationFailureKind.unknown, message: error.message),
      );
    }
  }
}
