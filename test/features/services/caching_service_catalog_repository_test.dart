import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/features/services/data/cached/caching_service_catalog_repository.dart';
import 'package:otlob_customer_app/features/services/data/mock/mock_services.dart';
import 'package:otlob_customer_app/features/services/domain/models/customer_service.dart';
import 'package:otlob_customer_app/features/services/domain/repositories/service_catalog_repository.dart';

void main() {
  test('caching repository reuses listServices for repeated getService calls', () async {
    final _CountingCatalogRepository delegate = _CountingCatalogRepository();
    final CachingServiceCatalogRepository repository =
        CachingServiceCatalogRepository(delegate: delegate);

    await repository.listServices();
    await repository.getService('home-cleaning');
    await repository.getService('ac-maintenance');

    expect(delegate.listServicesCalls, 1);
    expect(delegate.getServiceCalls, 0);
  });

  test('caching repository falls back to delegate getService on cache miss', () async {
    final _CountingCatalogRepository delegate = _CountingCatalogRepository();
    final CachingServiceCatalogRepository repository =
        CachingServiceCatalogRepository(delegate: delegate);

    final IntegrationResult<CustomerService?> result = await repository
        .getService('home-cleaning');

    expect(delegate.listServicesCalls, 0);
    expect(delegate.getServiceCalls, 1);
    expect(
      (result as IntegrationSuccess<CustomerService?>).value?.titleEn,
      'Home cleaning',
    );

    await repository.getService('home-cleaning');
    expect(delegate.getServiceCalls, 1);
  });
}

class _CountingCatalogRepository implements ServiceCatalogRepository {
  int listServicesCalls = 0;
  int getServiceCalls = 0;

  @override
  Future<IntegrationResult<List<ServiceCategory>>> listCategories() async {
    return const IntegrationSuccess<List<ServiceCategory>>(
      MockServices.categories,
    );
  }

  @override
  Future<IntegrationResult<List<CustomerService>>> listServices() async {
    listServicesCalls++;
    return const IntegrationSuccess<List<CustomerService>>(MockServices.popular);
  }

  @override
  Future<IntegrationResult<CustomerService?>> getService(
    String serviceId,
  ) async {
    getServiceCalls++;
    for (final CustomerService service in MockServices.popular) {
      if (service.id == serviceId) {
        return IntegrationSuccess<CustomerService?>(service);
      }
    }
    return const IntegrationSuccess<CustomerService?>(null);
  }
}
