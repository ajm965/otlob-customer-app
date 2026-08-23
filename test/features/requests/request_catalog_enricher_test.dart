import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/features/requests/data/request_catalog_enricher.dart';
import 'package:otlob_customer_app/features/requests/domain/models/customer_request.dart';
import 'package:otlob_customer_app/features/services/data/mock/mock_services.dart';
import 'package:otlob_customer_app/features/services/domain/models/customer_service.dart';
import 'package:otlob_customer_app/features/services/domain/repositories/service_catalog_repository.dart';

void main() {
  test('enrichRequests resolves catalog titles in one listServices call', () async {
    final _RecordingCatalogRepository repository = _RecordingCatalogRepository();
    final RequestCatalogEnricher enricher = RequestCatalogEnricher(
      catalogRepository: repository,
    );

    final List<CustomerRequest> enriched = await enricher.enrichRequests(
      const <CustomerRequest>[
        CustomerRequest(
          id: 'request-pending',
          serviceId: 'home-cleaning',
          serviceTitleAr: 'home-cleaning',
          serviceTitleEn: 'Home Cleaning',
          reference: 'REQ-1042',
          descriptionAr: 'desc',
          descriptionEn: 'desc',
          locationAr: 'loc',
          locationEn: 'loc',
          dateLabelAr: 'today',
          dateLabelEn: 'today',
          status: CustomerRequestStatus.pending,
        ),
        CustomerRequest(
          id: 'request-progress',
          serviceId: 'ac-maintenance',
          serviceTitleAr: 'ac-maintenance',
          serviceTitleEn: 'Ac Maintenance',
          reference: 'REQ-1038',
          descriptionAr: 'desc',
          descriptionEn: 'desc',
          locationAr: 'loc',
          locationEn: 'loc',
          dateLabelAr: 'today',
          dateLabelEn: 'today',
          status: CustomerRequestStatus.inProgress,
        ),
      ],
    );

    expect(repository.listServicesCalls, 1);
    expect(repository.getServiceCalls, 0);
    expect(enriched.first.serviceTitleEn, 'Home cleaning');
    expect(enriched.last.serviceTitleAr, 'صيانة المكيف');
  });

  test('enrichRequest uses getService for a single request', () async {
    final _RecordingCatalogRepository repository = _RecordingCatalogRepository();
    final RequestCatalogEnricher enricher = RequestCatalogEnricher(
      catalogRepository: repository,
    );

    final CustomerRequest? enriched = await enricher.enrichRequest(
      const CustomerRequest(
        id: 'request-pending',
        serviceId: 'home-cleaning',
        serviceTitleAr: 'home-cleaning',
        serviceTitleEn: 'Home Cleaning',
        reference: 'REQ-1042',
        descriptionAr: 'desc',
        descriptionEn: 'desc',
        locationAr: 'loc',
        locationEn: 'loc',
        dateLabelAr: 'today',
        dateLabelEn: 'today',
        status: CustomerRequestStatus.pending,
      ),
    );

    expect(repository.listServicesCalls, 1);
    expect(repository.getServiceCalls, 0);
    expect(enriched?.serviceTitleEn, 'Home cleaning');
  });
}

class _RecordingCatalogRepository implements ServiceCatalogRepository {
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
