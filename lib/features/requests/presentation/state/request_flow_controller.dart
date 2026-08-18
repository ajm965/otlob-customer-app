import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/integration_failure.dart';
import '../../../services/domain/repositories/service_catalog_repository.dart';
import '../../domain/models/customer_request.dart';
import '../../domain/repositories/customer_request_repository.dart';

final Provider<String> requestFlowServiceIdProvider = Provider<String>(
  (Ref ref) => throw StateError('Request flow service ID was not provided.'),
);

final Provider<CustomerRequestRepository> customerRequestRepositoryProvider =
    Provider<CustomerRequestRepository>(
      (Ref ref) =>
          throw StateError('Customer request repository was not provided.'),
    );

final Provider<ServiceCatalogRepository> serviceCatalogRepositoryProvider =
    Provider<ServiceCatalogRepository>(
      (Ref ref) =>
          throw StateError('Service catalog repository was not provided.'),
    );

final NotifierProvider<RequestFlowController, RequestDraft>
requestFlowProvider = NotifierProvider<RequestFlowController, RequestDraft>(
  RequestFlowController.new,
);

class RequestFlowController extends Notifier<RequestDraft> {
  @override
  RequestDraft build() {
    return RequestDraft(serviceId: ref.watch(requestFlowServiceIdProvider));
  }

  void updateDescription(String description) {
    state = RequestDraft(
      serviceId: state.serviceId,
      description: description,
      address: state.address,
      submission: state.submission,
    );
  }

  void selectAddress(RequestAddress address) {
    state = RequestDraft(
      serviceId: state.serviceId,
      description: state.description,
      address: address,
      submission: state.submission,
    );
  }

  Future<bool> submitMock() async {
    if (!state.canSubmit) {
      return false;
    }
    final IntegrationResult<RequestSubmission> result = await ref
        .read(customerRequestRepositoryProvider)
        .createRequest(state);
    if (result case IntegrationError<RequestSubmission>()) {
      return false;
    }
    final RequestSubmission submission =
        (result as IntegrationSuccess<RequestSubmission>).value;
    state = RequestDraft(
      serviceId: state.serviceId,
      description: state.description,
      address: state.address,
      submission: submission,
    );
    return true;
  }
}
