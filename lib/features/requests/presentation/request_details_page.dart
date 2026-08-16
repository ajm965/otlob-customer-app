import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../widgets/request_flow_widgets.dart';
import 'state/request_flow_controller.dart';

class RequestDetailsPage extends ConsumerStatefulWidget {
  const RequestDetailsPage({super.key});

  @override
  ConsumerState<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends ConsumerState<RequestDetailsPage> {
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: ref.read(requestFlowProvider).description,
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final String serviceId = ref.watch(requestFlowProvider).serviceId;
    return RequestStepScaffold(
      title: localizations.requestDetails,
      currentStep: 2,
      children: <Widget>[
        Text(
          localizations.requestDetailsPrompt,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: context.otlobColors.mutedText),
        ),
        const SizedBox(height: OtlobSpacing.lg),
        OtlobTextField(
          key: const Key('request-description-field'),
          controller: _descriptionController,
          label: localizations.descriptionOptional,
          hint: localizations.descriptionHint,
          semanticLabel: localizations.descriptionOptional,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
          onChanged: ref.read(requestFlowProvider.notifier).updateDescription,
        ),
        const SizedBox(height: OtlobSpacing.xl),
        OtlobButton(
          label: localizations.continueLabel,
          onPressed: () =>
              context.push(AppRoute.requestLocation.pathForService(serviceId)),
        ),
      ],
    );
  }
}
