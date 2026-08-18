import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/integration_failure.dart';
import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../../services/domain/models/customer_service.dart';
import '../domain/models/customer_request.dart';
import '../widgets/request_flow_widgets.dart';
import '../widgets/request_information_card.dart';
import 'state/request_flow_controller.dart';

class RequestReviewPage extends ConsumerWidget {
  const RequestReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final RequestDraft draft = ref.watch(requestFlowProvider);
    final RequestAddress? address = draft.address;

    return FutureBuilder<IntegrationResult<CustomerService?>>(
      future: ref
          .read(serviceCatalogRepositoryProvider)
          .getService(draft.serviceId),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<IntegrationResult<CustomerService?>> snapshot,
          ) {
            final CustomerService? service = switch (snapshot.data) {
              IntegrationSuccess<CustomerService?>(:final value) => value,
              _ => null,
            };
            return RequestStepScaffold(
              title: localizations.reviewRequest,
              currentStep: 4,
              children: <Widget>[
                Text(
                  localizations.reviewRequestMessage,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.otlobColors.mutedText,
                  ),
                ),
                const SizedBox(height: OtlobSpacing.lg),
                RequestInformationCard(
                  title: localizations.selectedService,
                  value:
                      service?.title(isArabic: localizations.isArabic) ??
                      localizations.serviceUnavailable,
                  icon: Icons.design_services_outlined,
                ),
                const SizedBox(height: OtlobSpacing.md),
                RequestInformationCard(
                  title: localizations.requestDetails,
                  value: draft.description.trim().isEmpty
                      ? localizations.noDescription
                      : draft.description.trim(),
                  icon: Icons.notes_outlined,
                ),
                const SizedBox(height: OtlobSpacing.md),
                RequestInformationCard(
                  title: localizations.serviceLocation,
                  value: address == null
                      ? localizations.locationRequired
                      : '${address.label(isArabic: localizations.isArabic)}\n'
                            '${address.line1(isArabic: localizations.isArabic)}, '
                            '${address.city(isArabic: localizations.isArabic)}',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: OtlobSpacing.lg),
                OtlobCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.info_outline, color: context.otlobColors.info),
                      const SizedBox(width: OtlobSpacing.md),
                      Expanded(
                        child: Text(
                          localizations.mockSubmissionNotice,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: OtlobSpacing.xl),
                OtlobButton(
                  key: const Key('submit-mock-request'),
                  label: localizations.submitMockRequest,
                  onPressed: () => _submit(context, ref, draft.serviceId),
                ),
              ],
            );
          },
    );
  }

  Future<void> _submit(
    BuildContext context,
    WidgetRef ref,
    String serviceId,
  ) async {
    final bool submitted = await ref
        .read(requestFlowProvider.notifier)
        .submitMock();
    if (!context.mounted) {
      return;
    }
    if (submitted) {
      context.pushReplacement(
        AppRoute.requestSuccess.pathForService(serviceId),
      );
      return;
    }
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(localizations.locationRequired)));
  }
}
