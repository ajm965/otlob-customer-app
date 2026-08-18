import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/domain/repositories/service_catalog_repository.dart';
import '../domain/repositories/customer_request_repository.dart';
import 'state/request_flow_controller.dart';

class RequestFlowScope extends StatelessWidget {
  const RequestFlowScope({
    required this.serviceId,
    required this.repository,
    required this.serviceRepository,
    required this.child,
    super.key,
  });

  final String serviceId;
  final CustomerRequestRepository repository;
  final ServiceCatalogRepository serviceRepository;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: ValueKey<String>(serviceId),
      overrides: [
        requestFlowServiceIdProvider.overrideWithValue(serviceId),
        customerRequestRepositoryProvider.overrideWithValue(repository),
        serviceCatalogRepositoryProvider.overrideWithValue(serviceRepository),
      ],
      child: child,
    );
  }
}
