import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/mock_request_creation.dart';

final Provider<String> requestFlowServiceIdProvider = Provider<String>(
  (Ref ref) => throw StateError('Request flow service ID was not provided.'),
);

final NotifierProvider<RequestFlowController, MockRequestDraft>
requestFlowProvider = NotifierProvider<RequestFlowController, MockRequestDraft>(
  RequestFlowController.new,
);

class RequestFlowController extends Notifier<MockRequestDraft> {
  @override
  MockRequestDraft build() {
    return MockRequestDraft(serviceId: ref.watch(requestFlowServiceIdProvider));
  }

  void updateDescription(String description) {
    state = MockRequestDraft(
      serviceId: state.serviceId,
      description: description,
      address: state.address,
      submission: state.submission,
    );
  }

  void selectAddress(MockRequestAddress address) {
    state = MockRequestDraft(
      serviceId: state.serviceId,
      description: state.description,
      address: address,
      submission: state.submission,
    );
  }

  bool submitMock() {
    if (!state.canSubmit) {
      return false;
    }
    state = MockRequestDraft(
      serviceId: state.serviceId,
      description: state.description,
      address: state.address,
      submission: MockRequestCreationData.submission,
    );
    return true;
  }
}
