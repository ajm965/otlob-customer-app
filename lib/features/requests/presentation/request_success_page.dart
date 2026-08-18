import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/customer_request.dart';
import 'state/request_flow_controller.dart';

class RequestSuccessPage extends ConsumerWidget {
  const RequestSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final RequestSubmission? submission = ref.watch(
      requestFlowProvider.select((RequestDraft draft) => draft.submission),
    );

    return Scaffold(
      appBar: OtlobAppBar(
        title: Text(localizations.requestSubmitted),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: OtlobLayoutConstraints.contentMaxWidth,
            ),
            child: ListView(
              key: const Key('request-success-view'),
              padding: const EdgeInsets.all(OtlobSpacing.lg),
              children: <Widget>[
                if (submission == null)
                  OtlobErrorState(
                    title: localizations.submissionUnavailable,
                    actionLabel: localizations.backToServices,
                    onAction: () => context.go(AppRoute.services.path),
                  )
                else ...<Widget>[
                  Icon(
                    Icons.check_circle_outline,
                    size: OtlobIconSizes.hero,
                    color: context.otlobColors.success,
                  ),
                  const SizedBox(height: OtlobSpacing.lg),
                  Text(
                    localizations.requestSubmitted,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: OtlobSpacing.sm),
                  Text(
                    localizations.requestSubmittedMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: context.otlobColors.mutedText,
                    ),
                  ),
                  const SizedBox(height: OtlobSpacing.xl),
                  OtlobCard(
                    child: Column(
                      children: <Widget>[
                        Text(
                          localizations.mockReference,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: OtlobSpacing.xs),
                        Text(
                          submission.reference,
                          textDirection: TextDirection.ltr,
                          style: OtlobTypography.numeric(
                            Theme.of(context).textTheme,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: OtlobSpacing.xl),
                  OtlobButton(
                    label: localizations.goToRequests,
                    onPressed: () => context.go(AppRoute.requests.path),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
