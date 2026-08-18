import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/integration_failure.dart';
import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/customer_request.dart';
import '../widgets/request_flow_widgets.dart';
import 'state/request_flow_controller.dart';

class RequestLocationPage extends ConsumerStatefulWidget {
  const RequestLocationPage({super.key});

  @override
  ConsumerState<RequestLocationPage> createState() =>
      _RequestLocationPageState();
}

class _RequestLocationPageState extends ConsumerState<RequestLocationPage> {
  bool _showValidationError = false;
  late final Future<IntegrationResult<List<RequestAddress>>> _addresses = ref
      .read(customerRequestRepositoryProvider)
      .listSelectableAddresses();

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final RequestDraft draft = ref.watch(requestFlowProvider);
    return RequestStepScaffold(
      title: localizations.serviceLocation,
      currentStep: 3,
      children: <Widget>[
        Text(
          localizations.selectMockLocation,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OtlobSpacing.sm),
        Text(
          localizations.mockLocationNotice,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.otlobColors.mutedText,
          ),
        ),
        const SizedBox(height: OtlobSpacing.lg),
        FutureBuilder<IntegrationResult<List<RequestAddress>>>(
          future: _addresses,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<IntegrationResult<List<RequestAddress>>> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return Center(
                    child: OtlobLoading(semanticLabel: localizations.appName),
                  );
                }
                final List<RequestAddress> addresses = switch (snapshot.data) {
                  IntegrationSuccess<List<RequestAddress>>(:final value) =>
                    value,
                  _ => const <RequestAddress>[],
                };
                return Column(
                  children: <Widget>[
                    for (final RequestAddress address in addresses) ...<Widget>[
                      MockAddressCard(
                        address: address,
                        isArabic: localizations.isArabic,
                        isSelected: draft.address?.id == address.id,
                        onTap: () {
                          ref
                              .read(requestFlowProvider.notifier)
                              .selectAddress(address);
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
    context.push(AppRoute.requestReview.pathForService(draft.serviceId));
  }
}
