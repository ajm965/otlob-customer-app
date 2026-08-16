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

class RequestStartPage extends ConsumerWidget {
  const RequestStartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final MockRequestDraft draft = ref.watch(requestFlowProvider);
    final MockService? service = _serviceById(draft.serviceId);

    if (service == null) {
      return Scaffold(
        appBar: OtlobAppBar(title: Text(localizations.requestStart)),
        body: OtlobErrorState(
          title: localizations.serviceUnavailable,
          actionLabel: localizations.backToServices,
          onAction: () => context.go(AppRoute.services.path),
        ),
      );
    }

    return RequestStepScaffold(
      title: localizations.requestStart,
      currentStep: 1,
      children: <Widget>[
        Text(
          localizations.selectedService,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OtlobSpacing.md),
        OtlobCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                service.title(isArabic: localizations.isArabic),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: OtlobSpacing.sm),
              Text(
                service.description(isArabic: localizations.isArabic),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.otlobColors.mutedText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: OtlobSpacing.xl),
        OtlobButton(
          label: localizations.continueLabel,
          onPressed: () =>
              context.push(AppRoute.requestDetails.pathForService(service.id)),
        ),
      ],
    );
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
