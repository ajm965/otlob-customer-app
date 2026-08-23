import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/customer_request.dart';
import 'state/request_flow_controller.dart';

abstract final class RequestFlowDebug {
  static void logScopeLifecycle(
    String event, {
    required String serviceId,
    required int containerHash,
    int? scopeHash,
  }) {
    if (!kDebugMode) {
      return;
    }
    debugPrint(
      '[RequestFlowScope] $event '
      'serviceId=$serviceId '
      'container=$containerHash '
      'scope=${scopeHash ?? 'n/a'}',
    );
  }

  static void logDraft(
    String event,
    WidgetRef ref, {
    String? selectedAddressId,
  }) {
    if (!kDebugMode) {
      return;
    }
    final ProviderContainer container = ProviderScope.containerOf(
      ref.context,
      listen: false,
    );
    final RequestFlowController notifier =
        container.read(requestFlowProvider.notifier);
    final RequestDraft draft = container.read(requestFlowProvider);
    debugPrint(
      '[RequestFlow] $event '
      'container=${identityHashCode(container)} '
      'controller=${identityHashCode(notifier)} '
      'serviceId=${draft.serviceId} '
      'addressId=${draft.address?.id ?? 'null'} '
      'selectedAddressId=${selectedAddressId ?? 'n/a'} '
      'canSubmit=${draft.canSubmit}',
    );
  }
}
