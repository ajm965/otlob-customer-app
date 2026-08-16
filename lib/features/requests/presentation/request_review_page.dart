import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../../services/data/mock/mock_services.dart';
import '../data/mock/mock_request_creation.dart';
import '../widgets/request_flow_widgets.dart';
import 'state/request_flow_controller.dart';

class RequestReviewPage extends ConsumerWidget {
  const RequestReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final MockRequestDraft draft = ref.watch(requestFlowProvider);
    final MockService? service = _serviceById(draft.serviceId);
    final MockRequestAddress? address = draft.address;

    return RequestStepScaffold(
      title: localizations.reviewRequest,
      currentStep: 4,
      children: <Widget>[
        Text(
          localizations.reviewRequestMessage,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: context.otlobColors.mutedText),
        ),
        const SizedBox(height: OtlobSpacing.lg),
        RequestReviewCard(
          title: localizations.selectedService,
          value:
              service?.title(isArabic: localizations.isArabic) ??
              localizations.serviceUnavailable,
          icon: Icons.design_services_outlined,
        ),
        const SizedBox(height: OtlobSpacing.md),
        RequestReviewCard(
          title: localizations.requestDetails,
          value: draft.description.trim().isEmpty
              ? localizations.noDescription
              : draft.description.trim(),
          icon: Icons.notes_outlined,
        ),
        const SizedBox(height: OtlobSpacing.md),
        RequestReviewCard(
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
  }

  void _submit(BuildContext context, WidgetRef ref, String serviceId) {
    final bool submitted = ref.read(requestFlowProvider.notifier).submitMock();
    if (!submitted) {
      final OtlobLocalizations localizations = OtlobLocalizations.of(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(localizations.locationRequired)));
      return;
    }
    context.pushReplacement(AppRoute.requestSuccess.pathForService(serviceId));
  }

  MockService? _serviceById(String serviceId) {
    for (final MockService service in MockServices.popular) {
      if (service.id == serviceId) {
        return service;
      }
    }
    return null;
  }
}
