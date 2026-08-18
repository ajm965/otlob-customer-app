import 'package:flutter/material.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../../requests/domain/models/customer_request.dart';
import '../../services/domain/models/customer_service.dart';

class HomeCategoryCard extends StatelessWidget {
  const HomeCategoryCard({
    required this.category,
    required this.isArabic,
    required this.onTap,
    super.key,
  });

  final ServiceCategory category;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OtlobCard(
      onTap: onTap,
      semanticLabel: category.title(isArabic: isArabic),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            _iconFor(category.visual) ?? Icons.category_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: OtlobIconSizes.large,
          ),
          const SizedBox(height: OtlobSpacing.sm),
          Text(
            category.title(isArabic: isArabic),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class HomeRecommendedCard extends StatelessWidget {
  const HomeRecommendedCard({
    required this.service,
    required this.isArabic,
    required this.onTap,
    super.key,
  });

  final CustomerService service;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String? description = service.description(isArabic: isArabic);
    return OtlobCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            _iconFor(service.visual) ?? Icons.design_services_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: OtlobIconSizes.large,
          ),
          const Spacer(),
          Text(
            service.title(isArabic: isArabic),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: OtlobSpacing.xs),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.otlobColors.mutedText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class HomeRecentRequestCard extends StatelessWidget {
  const HomeRecentRequestCard({
    required this.request,
    required this.isArabic,
    super.key,
  });

  final CustomerRequest request;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return OtlobCard(
      child: Row(
        children: <Widget>[
          const OtlobAvatar(
            radius: OtlobIconSizes.medium,
            child: Icon(Icons.receipt_long_outlined),
          ),
          const SizedBox(width: OtlobSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  request.serviceTitle(isArabic: isArabic),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: OtlobSpacing.xs),
                Text(
                  request.reference,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          OtlobBadge(
            label: switch (request.status) {
              CustomerRequestStatus.pending => localizations.pending,
              CustomerRequestStatus.inProgress => localizations.inProgress,
              CustomerRequestStatus.completed => localizations.completed,
              CustomerRequestStatus.cancelled => localizations.cancelled,
            },
            tone: switch (request.status) {
              CustomerRequestStatus.pending => OtlobBadgeTone.warning,
              CustomerRequestStatus.inProgress => OtlobBadgeTone.info,
              CustomerRequestStatus.completed => OtlobBadgeTone.success,
              CustomerRequestStatus.cancelled => OtlobBadgeTone.error,
            },
          ),
        ],
      ),
    );
  }
}

IconData? _iconFor(ServiceVisual? visual) {
  return switch (visual) {
    ServiceVisual.cleaning => Icons.cleaning_services_outlined,
    ServiceVisual.airConditioning => Icons.ac_unit,
    ServiceVisual.plumbing => Icons.plumbing,
    ServiceVisual.electrical => Icons.electrical_services_outlined,
    ServiceVisual.maintenance => Icons.handyman_outlined,
    ServiceVisual.moving => Icons.local_shipping_outlined,
    null => null,
  };
}
