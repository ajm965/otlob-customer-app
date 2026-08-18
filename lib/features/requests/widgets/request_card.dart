import 'package:flutter/material.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/customer_request.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({required this.request, required this.onTap, super.key});

  final CustomerRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return OtlobCard(
      onTap: onTap,
      semanticLabel: request.serviceTitle(isArabic: localizations.isArabic),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  request.serviceTitle(isArabic: localizations.isArabic),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: OtlobSpacing.sm),
              RequestStatusBadge(status: request.status),
            ],
          ),
          const SizedBox(height: OtlobSpacing.md),
          Text(
            request.reference,
            textDirection: TextDirection.ltr,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.otlobColors.mutedText,
            ),
          ),
          const SizedBox(height: OtlobSpacing.sm),
          Text(
            request.description(isArabic: localizations.isArabic),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: OtlobSpacing.md),
          Row(
            children: <Widget>[
              Icon(
                Icons.location_on_outlined,
                size: OtlobIconSizes.small,
                color: context.otlobColors.mutedText,
              ),
              const SizedBox(width: OtlobSpacing.xs),
              Expanded(
                child: Text(
                  request.location(isArabic: localizations.isArabic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.otlobColors.mutedText,
                  ),
                ),
              ),
              const SizedBox(width: OtlobSpacing.sm),
              Text(
                request.dateLabel(isArabic: localizations.isArabic),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.otlobColors.mutedText,
                ),
              ),
              const SizedBox(width: OtlobSpacing.sm),
              const Icon(Icons.arrow_forward, size: OtlobIconSizes.small),
            ],
          ),
        ],
      ),
    );
  }
}

class RequestStatusBadge extends StatelessWidget {
  const RequestStatusBadge({required this.status, super.key});

  final CustomerRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return OtlobBadge(
      label: switch (status) {
        CustomerRequestStatus.pending => localizations.pending,
        CustomerRequestStatus.inProgress => localizations.inProgress,
        CustomerRequestStatus.completed => localizations.completed,
        CustomerRequestStatus.cancelled => localizations.cancelled,
      },
      tone: switch (status) {
        CustomerRequestStatus.pending => OtlobBadgeTone.warning,
        CustomerRequestStatus.inProgress => OtlobBadgeTone.info,
        CustomerRequestStatus.completed => OtlobBadgeTone.success,
        CustomerRequestStatus.cancelled => OtlobBadgeTone.error,
      },
    );
  }
}
