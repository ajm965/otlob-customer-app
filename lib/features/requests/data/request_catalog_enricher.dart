import '../../../../core/errors/integration_failure.dart';
import '../../services/domain/models/customer_service.dart';
import '../../services/domain/repositories/service_catalog_repository.dart';
import '../domain/models/customer_request.dart';

class RequestCatalogEnricher {
  const RequestCatalogEnricher({required this.catalogRepository});

  final ServiceCatalogRepository catalogRepository;

  Future<List<CustomerRequest>> enrichRequests(
    List<CustomerRequest> requests,
  ) async {
    if (requests.isEmpty) {
      return requests;
    }
    final Map<String, CustomerService> servicesById = await _resolveServices(
      requests.map((CustomerRequest request) => request.serviceId).toSet(),
    );
    return enrichRequestsWithServices(requests, servicesById);
  }

  Future<CustomerRequest?> enrichRequest(CustomerRequest? request) async {
    if (request == null) {
      return null;
    }
    final Map<String, CustomerService> servicesById = await _resolveServices(
      <String>{request.serviceId},
    );
    return applyCatalogService(request, servicesById[request.serviceId]);
  }

  Future<Map<String, CustomerService>> _resolveServices(
    Set<String> serviceIds,
  ) async {
    final IntegrationResult<List<CustomerService>> listResult =
        await catalogRepository.listServices();
    final Map<String, CustomerService> servicesById = switch (listResult) {
      IntegrationSuccess<List<CustomerService>>(:final value) =>
        <String, CustomerService>{
          for (final CustomerService service in value) service.id: service,
        },
      _ => <String, CustomerService>{},
    };

    for (final String serviceId in serviceIds) {
      if (servicesById.containsKey(serviceId)) {
        continue;
      }
      final IntegrationResult<CustomerService?> result = await catalogRepository
          .getService(serviceId);
      if (result case IntegrationSuccess<CustomerService?>(
        :final CustomerService? value,
      ) when value != null) {
        servicesById[serviceId] = value;
      }
    }
    return servicesById;
  }
}

List<CustomerRequest> enrichRequestsWithServices(
  List<CustomerRequest> requests,
  Map<String, CustomerService> servicesById,
) {
  return requests
      .map(
        (CustomerRequest request) =>
            applyCatalogService(request, servicesById[request.serviceId]),
      )
      .toList(growable: false);
}

CustomerRequest applyCatalogService(
  CustomerRequest request,
  CustomerService? service,
) {
  if (service == null) {
    return request;
  }
  return request.withCatalogTitles(
    titleAr: service.titleAr,
    titleEn: service.titleEn,
  );
}
