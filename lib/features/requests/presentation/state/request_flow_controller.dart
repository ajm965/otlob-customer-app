import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/integration_failure.dart';
import '../../../addresses/domain/models/customer_address.dart';
import '../../../addresses/domain/repositories/customer_address_repository.dart';
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

final Provider<CustomerAddressRepository> customerAddressRepositoryProvider =
    Provider<CustomerAddressRepository>(
      (Ref ref) =>
          throw StateError('Customer address repository was not provided.'),
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
    return RequestDraft(serviceId: ref.read(requestFlowServiceIdProvider));
  }

  void updateDescription(String description) {
    state = RequestDraft(
      serviceId: state.serviceId,
      description: description,
      address: state.address,
      submission: state.submission,
    );
  }

  void selectAddress(CustomerAddress address) {
    state = RequestDraft(
      serviceId: state.serviceId,
      description: state.description,
      address: address,
      submission: state.submission,
    );
    if (kDebugMode) {
      debugPrint(
        '[RequestFlow] selectAddress '
        'controller=${identityHashCode(this)} '
        'addressId=${address.id} '
        'canSubmit=${state.canSubmit}',
      );
    }
  }

  Future<bool> submit() async {
    if (kDebugMode) {
      debugPrint(
        '[RequestFlow] submit '
        'controller=${identityHashCode(this)} '
        'addressId=${state.address?.id ?? 'null'} '
        'canSubmit=${state.canSubmit}',
      );
    }
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
    final IntegrationResult<CustomerRequest> publishResult = await ref
        .read(customerRequestRepositoryProvider)
        .publishRequest(submission.reference);
    if (publishResult case IntegrationError<CustomerRequest>()) {
      return false;
    }
    state = RequestDraft(
      serviceId: state.serviceId,
      description: state.description,
      address: state.address,
      submission: submission,
    );
    return true;
  }
}
