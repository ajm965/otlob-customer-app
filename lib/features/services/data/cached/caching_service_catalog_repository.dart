import '../../../../core/errors/integration_failure.dart';
import '../../domain/models/customer_service.dart';
import '../../domain/repositories/service_catalog_repository.dart';

/// In-memory decorator that warms a service map from [listServices] and reuses
/// it for subsequent [getService] lookups within the app session.
class CachingServiceCatalogRepository implements ServiceCatalogRepository {
  CachingServiceCatalogRepository({required this.delegate});

  final ServiceCatalogRepository delegate;

  List<ServiceCategory>? _categories;
  Map<String, CustomerService>? _servicesById;

  @override
  Future<IntegrationResult<List<ServiceCategory>>> listCategories() async {
    if (_categories != null) {
      return IntegrationSuccess<List<ServiceCategory>>(_categories!);
    }
    final IntegrationResult<List<ServiceCategory>> result = await delegate
        .listCategories();
    if (result case IntegrationSuccess<List<ServiceCategory>>(:final value)) {
      _categories = List<ServiceCategory>.unmodifiable(value);
    }
    return result;
  }

  @override
  Future<IntegrationResult<List<CustomerService>>> listServices() async {
    if (_servicesById != null) {
      return IntegrationSuccess<List<CustomerService>>(
        List<CustomerService>.unmodifiable(_servicesById!.values),
      );
    }

    final IntegrationResult<List<CustomerService>> result = await delegate
        .listServices();
    if (result case IntegrationSuccess<List<CustomerService>>(:final value)) {
      _cacheServices(value);
    }
    return result;
  }

  @override
  Future<IntegrationResult<CustomerService?>> getService(
    String serviceId,
  ) async {
    final String trimmedId = serviceId.trim();
    if (trimmedId.isEmpty) {
      return const IntegrationError<CustomerService?>(
        IntegrationFailure(IntegrationFailureKind.validation),
      );
    }

    final CustomerService? cached = _servicesById?[trimmedId];
    if (cached != null) {
      return IntegrationSuccess<CustomerService?>(cached);
    }

    final IntegrationResult<CustomerService?> result = await delegate.getService(
      trimmedId,
    );
    if (result case IntegrationSuccess<CustomerService?>(:final CustomerService? value)
        when value != null) {
      _servicesById ??= <String, CustomerService>{};
      _servicesById![trimmedId] = value;
    }
    return result;
  }

  void _cacheServices(List<CustomerService> services) {
    _servicesById = <String, CustomerService>{
      for (final CustomerService service in services) service.id: service,
    };
  }
}
