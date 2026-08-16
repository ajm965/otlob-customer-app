import 'package:flutter/material.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../data/mock/mock_requests.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({required this.request, super.key});

  final MockRequest request;

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return OtlobCard(
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
              OtlobBadge(label: _statusLabel(localizations), tone: _badgeTone),
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
          const SizedBox(height: OtlobSpacing.xs),
          Text(
            request.dateLabel(isArabic: localizations.isArabic),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.otlobColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }

  OtlobBadgeTone get _badgeTone {
    return switch (request.status) {
      MockRequestStatus.pending => OtlobBadgeTone.warning,
      MockRequestStatus.inProgress => OtlobBadgeTone.info,
      MockRequestStatus.completed => OtlobBadgeTone.success,
      MockRequestStatus.cancelled => OtlobBadgeTone.error,
    };
  }

  String _statusLabel(OtlobLocalizations localizations) {
    return switch (request.status) {
      MockRequestStatus.pending => localizations.pending,
      MockRequestStatus.inProgress => localizations.inProgress,
      MockRequestStatus.completed => localizations.completed,
      MockRequestStatus.cancelled => localizations.cancelled,
    };
  }
}
