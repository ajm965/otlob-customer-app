import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/features/addresses/data/mock/mock_addresses.dart';
import 'package:otlob_customer_app/features/addresses/domain/models/customer_address.dart';
import 'package:otlob_customer_app/features/requests/data/http/request_json.dart';
import 'package:otlob_customer_app/features/requests/domain/models/customer_request.dart';
import 'package:otlob_customer_app/features/requests/domain/repositories/customer_request_repository.dart';
import 'package:otlob_customer_app/features/requests/presentation/state/request_flow_controller.dart';

void main() {
  group('RequestFlowController', () {
    late ProviderContainer container;
    late TrackingCustomerRequestRepository repository;

    setUp(() {
      repository = TrackingCustomerRequestRepository();
      container = ProviderContainer(
        overrides: [
          requestFlowServiceIdProvider.overrideWithValue('home-cleaning'),
          customerRequestRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('selectAddress stores CustomerAddress in RequestDraft', () {
      final CustomerAddress address = MockAddresses.all.first;
      container.read(requestFlowProvider.notifier).selectAddress(address);

      final RequestDraft draft = container.read(requestFlowProvider);
      expect(draft.address, address);
      expect(draft.canSubmit, isTrue);
    });

    test('updateDescription preserves selected address', () {
      final CustomerAddress address = MockAddresses.all.first;
      final RequestFlowController notifier =
          container.read(requestFlowProvider.notifier);
      notifier.selectAddress(address);
      notifier.updateDescription('Kitchen leak');

      final RequestDraft draft = container.read(requestFlowProvider);
      expect(draft.description, 'Kitchen leak');
      expect(draft.address, address);
      expect(draft.canSubmit, isTrue);
    });

    test('submit without address is rejected', () async {
      final bool submitted = await container
          .read(requestFlowProvider.notifier)
          .submit();

      expect(submitted, isFalse);
      expect(repository.createRequestCalls, isEmpty);
    });

    test('submit after selecting address calls createRequest', () async {
      final CustomerAddress address = MockAddresses.all.first;
      final RequestFlowController notifier =
          container.read(requestFlowProvider.notifier);
      notifier.updateDescription('Kitchen leak');
      notifier.selectAddress(address);

      final bool submitted = await notifier.submit();

      expect(submitted, isTrue);
      expect(repository.createRequestCalls, hasLength(1));
      expect(
        repository.createRequestCalls.single.address,
        address,
      );
    });

    test('createRequest body includes location and excludes addressId', () {
      final CustomerAddress address = MockAddresses.all.first;
      container.read(requestFlowProvider.notifier).selectAddress(address);
      container
          .read(requestFlowProvider.notifier)
          .updateDescription('Kitchen leak');

      final Map<String, Object?> body = buildCreateRequestBody(
        container.read(requestFlowProvider),
      );

      expect(body['serviceId'], 'home-cleaning');
      expect(body['description'], 'Kitchen leak');
      expect(body.containsKey('addressId'), isFalse);
      expect(
        body['location'],
        <String, Object?>{
          'latitude': address.latitude,
          'longitude': address.longitude,
        },
      );
    });
  });
}

class TrackingCustomerRequestRepository implements CustomerRequestRepository {
  final List<RequestDraft> createRequestCalls = <RequestDraft>[];

  @override
  Future<IntegrationResult<RequestSubmission>> createRequest(
    RequestDraft draft,
  ) async {
    createRequestCalls.add(draft);
    return const IntegrationSuccess<RequestSubmission>(
      RequestSubmission(reference: 'req-track-001'),
    );
  }

  @override
  Future<IntegrationResult<CustomerRequest?>> getRequest(String requestId) {
    throw UnimplementedError();
  }

  @override
  Future<IntegrationResult<List<CustomerRequest>>> listRequests() {
    throw UnimplementedError();
  }
}
