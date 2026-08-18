import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/integration_failure.dart';
import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/customer_request.dart';
import '../domain/repositories/customer_request_repository.dart';
import '../widgets/request_card.dart';
import '../widgets/request_information_card.dart';

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({
    required this.requestId,
    required this.repository,
    super.key,
  });

  final String requestId;
  final CustomerRequestRepository repository;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  late final Future<IntegrationResult<CustomerRequest?>> _request = widget
      .repository
      .getRequest(widget.requestId);

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return FutureBuilder<IntegrationResult<CustomerRequest?>>(
      future: _request,
      builder:
          (
            BuildContext context,
            AsyncSnapshot<IntegrationResult<CustomerRequest?>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: OtlobLoading(semanticLabel: localizations.appName),
                ),
              );
            }
            final CustomerRequest? request = switch (snapshot.data) {
              IntegrationSuccess<CustomerRequest?>(:final value) => value,
              _ => null,
            };

            if (request == null) {
              return Scaffold(
                appBar: OtlobAppBar(title: Text(localizations.requestDetails)),
                body: OtlobErrorState(
                  title: localizations.requestNotFound,
                  message: localizations.requestNotFoundMessage,
                  actionLabel: localizations.backToRequests,
                  onAction: () => context.go(AppRoute.requests.path),
                ),
              );
            }

            return Scaffold(
              appBar: OtlobAppBar(title: Text(localizations.requestDetails)),
              body: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: OtlobLayoutConstraints.contentMaxWidth,
                    ),
                    child: ListView(
                      key: const Key('request-detail-list'),
                      padding: const EdgeInsets.all(OtlobSpacing.lg),
                      children: <Widget>[
                        OtlobCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      request.serviceTitle(
                                        isArabic: localizations.isArabic,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                  ),
                                  const SizedBox(width: OtlobSpacing.sm),
                                  RequestStatusBadge(status: request.status),
                                ],
                              ),
                              const SizedBox(height: OtlobSpacing.md),
                              Text(
                                localizations.requestReference,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: context.otlobColors.mutedText,
                                    ),
                              ),
                              const SizedBox(height: OtlobSpacing.xs),
                              Text(
                                request.reference,
                                textDirection: TextDirection.ltr,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: OtlobSpacing.md),
                        RequestInformationCard(
                          title: localizations.requestDescription,
                          value: request.description(
                            isArabic: localizations.isArabic,
                          ),
                          icon: Icons.notes_outlined,
                        ),
                        const SizedBox(height: OtlobSpacing.md),
                        RequestInformationCard(
                          title: localizations.requestLocation,
                          value: request.location(
                            isArabic: localizations.isArabic,
                          ),
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: OtlobSpacing.md),
                        RequestInformationCard(
                          title: localizations.requestDate,
                          value: request.dateLabel(
                            isArabic: localizations.isArabic,
                          ),
                          icon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
    );
  }
}
