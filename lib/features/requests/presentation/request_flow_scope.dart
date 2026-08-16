import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/request_flow_controller.dart';

class RequestFlowScope extends StatelessWidget {
  const RequestFlowScope({
    required this.serviceId,
    required this.child,
    super.key,
  });

  final String serviceId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: ValueKey<String>(serviceId),
      overrides: [requestFlowServiceIdProvider.overrideWithValue(serviceId)],
      child: child,
    );
  }
}
