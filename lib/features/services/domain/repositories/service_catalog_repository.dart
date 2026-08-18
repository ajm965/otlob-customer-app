import '../../../../core/errors/integration_failure.dart';
import '../models/customer_service.dart';

abstract interface class ServiceCatalogRepository {
  Future<IntegrationResult<List<ServiceCategory>>> listCategories();

  Future<IntegrationResult<List<CustomerService>>> listServices();

  Future<IntegrationResult<CustomerService?>> getService(String serviceId);
}
