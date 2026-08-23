import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../addresses/domain/repositories/customer_address_repository.dart';
import '../../services/domain/repositories/service_catalog_repository.dart';
import '../domain/repositories/customer_request_repository.dart';
import 'request_flow_debug.dart';
import 'state/request_flow_controller.dart';

class RequestFlowScope extends StatefulWidget {
  const RequestFlowScope({
    required this.serviceId,
    required this.repository,
    required this.addressRepository,
    required this.serviceRepository,
    required this.child,
    super.key,
  });

  final String serviceId;
  final CustomerRequestRepository repository;
  final CustomerAddressRepository addressRepository;
  final ServiceCatalogRepository serviceRepository;
  final Widget child;

  @override
  State<RequestFlowScope> createState() => _RequestFlowScopeState();
}

class _RequestFlowScopeState extends State<RequestFlowScope> {
  late ProviderContainer _container;

  @override
  void initState() {
    super.initState();
    _container = _createContainer();
    RequestFlowDebug.logScopeLifecycle(
      'initState',
      serviceId: widget.serviceId,
      containerHash: identityHashCode(_container),
      scopeHash: identityHashCode(this),
    );
  }

  @override
  void didUpdateWidget(RequestFlowScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.serviceId != widget.serviceId) {
      RequestFlowDebug.logScopeLifecycle(
        'serviceIdChanged',
        serviceId: widget.serviceId,
        containerHash: identityHashCode(_container),
        scopeHash: identityHashCode(this),
      );
      _container.dispose();
      _container = _createContainer();
      RequestFlowDebug.logScopeLifecycle(
        'containerRecreated',
        serviceId: widget.serviceId,
        containerHash: identityHashCode(_container),
        scopeHash: identityHashCode(this),
      );
    }
  }

  @override
  void dispose() {
    RequestFlowDebug.logScopeLifecycle(
      'dispose',
      serviceId: widget.serviceId,
      containerHash: identityHashCode(_container),
      scopeHash: identityHashCode(this),
    );
    _container.dispose();
    super.dispose();
  }

  ProviderContainer _createContainer() {
    return ProviderContainer(
      overrides: [
        requestFlowServiceIdProvider.overrideWithValue(widget.serviceId),
        customerRequestRepositoryProvider.overrideWithValue(widget.repository),
        customerAddressRepositoryProvider.overrideWithValue(
          widget.addressRepository,
        ),
        serviceCatalogRepositoryProvider.overrideWithValue(
          widget.serviceRepository,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: _container,
      child: widget.child,
    );
  }
}
