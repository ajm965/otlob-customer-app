import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/core/errors/integration_failure.dart';
import 'package:otlob_customer_app/core/router/app_router.dart';
import 'package:otlob_customer_app/features/addresses/data/mock/mock_addresses.dart';
import 'package:otlob_customer_app/features/requests/domain/models/customer_request.dart';
import 'package:otlob_customer_app/features/requests/domain/repositories/customer_request_repository.dart';
import 'package:otlob_customer_app/features/requests/presentation/request_flow_scope.dart';
import 'package:otlob_customer_app/features/requests/presentation/state/request_flow_controller.dart';
import 'package:otlob_customer_app/features/services/data/mock/mock_services.dart';

void main() {
  testWidgets('RequestFlowScope keeps selected address across shell rebuilds', (
    WidgetTester tester,
  ) async {
    late void Function(VoidCallback) rebuildShell;
    final FlowTrackingRequestRepository repository =
        FlowTrackingRequestRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            rebuildShell = setState;
            return RequestFlowScope(
              key: AppRouter.requestFlowScopeKey('home-cleaning'),
              serviceId: 'home-cleaning',
              repository: repository,
              addressRepository: const MockCustomerAddressRepository(),
              serviceRepository: const MockServiceCatalogRepository(),
              child: const _DraftProbe(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('select-address'));
    await tester.pumpAndSettle();
    expect(find.text('Mock home'), findsOneWidget);

    rebuildShell(() {});
    await tester.pumpAndSettle();
    expect(find.text('Mock home'), findsOneWidget);

    await tester.tap(find.text('submit-draft'));
    await tester.pumpAndSettle();

    expect(repository.createRequestCalls, hasLength(1));
    expect(
      repository.createRequestCalls.single.address,
      MockAddresses.all.first,
    );
  });
}

class _DraftProbe extends ConsumerWidget {
  const _DraftProbe();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RequestDraft draft = ref.watch(requestFlowProvider);
    return Column(
      children: <Widget>[
        Text(draft.address?.label ?? 'none'),
        TextButton(
          onPressed: () => ref
              .read(requestFlowProvider.notifier)
              .selectAddress(MockAddresses.all.first),
          child: const Text('select-address'),
        ),
        TextButton(
          onPressed: () => ref.read(requestFlowProvider.notifier).submit(),
          child: const Text('submit-draft'),
        ),
      ],
    );
  }
}

class FlowTrackingRequestRepository implements CustomerRequestRepository {
  final List<RequestDraft> createRequestCalls = <RequestDraft>[];

  @override
  Future<IntegrationResult<RequestSubmission>> createRequest(
    RequestDraft draft,
  ) async {
    createRequestCalls.add(draft);
    return const IntegrationSuccess<RequestSubmission>(
      RequestSubmission(reference: 'req-flow-001'),
    );
  }

  @override
  Future<IntegrationResult<CustomerRequest>> publishRequest(
    String requestId,
  ) async {
    return IntegrationSuccess<CustomerRequest>(
      CustomerRequest(
        id: requestId,
        serviceId: 'home-cleaning',
        serviceTitleAr: 'home-cleaning',
        serviceTitleEn: 'Home Cleaning',
        reference: requestId,
        descriptionAr: 'Flow test',
        descriptionEn: 'Flow test',
        locationAr: 'Riyadh',
        locationEn: 'Riyadh',
        dateLabelAr: 'Today',
        dateLabelEn: 'Today',
        status: CustomerRequestStatus.open,
      ),
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
