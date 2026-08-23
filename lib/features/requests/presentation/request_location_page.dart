import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/integration_failure.dart';
import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../../addresses/domain/models/customer_address.dart';
import '../domain/models/customer_request.dart';
import '../widgets/request_flow_widgets.dart';
import 'request_flow_debug.dart';
import 'state/request_flow_controller.dart';

class RequestLocationPage extends ConsumerStatefulWidget {
  const RequestLocationPage({super.key});

  @override
  ConsumerState<RequestLocationPage> createState() =>
      _RequestLocationPageState();
}

class _RequestLocationPageState extends ConsumerState<RequestLocationPage> {
  bool _showValidationError = false;
  late final Future<IntegrationResult<List<CustomerAddress>>> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = ref.read(customerAddressRepositoryProvider).listAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final RequestDraft draft = ref.watch(requestFlowProvider);
    return RequestStepScaffold(
      title: localizations.serviceLocation,
      currentStep: 3,
      children: <Widget>[
        Text(
          localizations.selectSavedAddress,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OtlobSpacing.sm),
        Text(
          localizations.savedAddressNotice,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.otlobColors.mutedText,
          ),
        ),
        const SizedBox(height: OtlobSpacing.lg),
        FutureBuilder<IntegrationResult<List<CustomerAddress>>>(
          future: _addresses,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<IntegrationResult<List<CustomerAddress>>> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return Center(
                    child: OtlobLoading(semanticLabel: localizations.appName),
                  );
                }
                final List<CustomerAddress> addresses = switch (snapshot.data) {
                  IntegrationSuccess<List<CustomerAddress>>(:final value) =>
                    value,
                  _ => const <CustomerAddress>[],
                };
                return Column(
                  children: <Widget>[
                    for (final CustomerAddress address in addresses) ...<Widget>[
                      MockAddressCard(
                        address: address,
                        isArabic: localizations.isArabic,
                        isSelected: draft.address?.id == address.id,
                        onTap: () {
                          ref
                              .read(requestFlowProvider.notifier)
                              .selectAddress(address);
                          RequestFlowDebug.logDraft(
                            'selectAddress',
                            ref,
                            selectedAddressId: address.id,
                          );
                          setState(() => _showValidationError = false);
                        },
                      ),
                      const SizedBox(height: OtlobSpacing.md),
                    ],
                  ],
                );
              },
        ),
        if (_showValidationError)
          Text(
            localizations.locationRequired,
            key: const Key('location-validation-error'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        if (_showValidationError) const SizedBox(height: OtlobSpacing.md),
        OtlobButton(
          label: localizations.continueLabel,
          onPressed: () => _continue(draft),
        ),
      ],
    );
  }

  void _continue(RequestDraft draft) {
    if (draft.address == null) {
      setState(() => _showValidationError = true);
      return;
    }
    RequestFlowDebug.logDraft('continueToReview', ref);
    context.push(AppRoute.requestReview.pathForService(draft.serviceId));
  }
}
