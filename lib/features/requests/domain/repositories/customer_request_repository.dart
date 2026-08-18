import '../../../../core/errors/integration_failure.dart';
import '../models/customer_request.dart';

abstract interface class CustomerRequestRepository {
  Future<IntegrationResult<List<CustomerRequest>>> listRequests();

  Future<IntegrationResult<CustomerRequest?>> getRequest(String requestId);

  Future<IntegrationResult<RequestSubmission>> createRequest(
    RequestDraft draft,
  );

  Future<IntegrationResult<List<RequestAddress>>> listSelectableAddresses();
}
