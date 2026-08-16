import 'package:flutter/material.dart';

import '../../../core/theme/otlob_design_system.dart';
import '../data/mock/mock_home_data.dart';

class HomeCategoryCard extends StatelessWidget {
  const HomeCategoryCard({
    required this.category,
    required this.isArabic,
    required this.onTap,
    super.key,
  });

  final MockHomeCategory category;
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
            _iconFor(category.visual),
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

  final MockHomeService service;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OtlobCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            _iconFor(service.visual),
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
          const SizedBox(height: OtlobSpacing.xs),
          Text(
            service.description(isArabic: isArabic),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.otlobColors.mutedText,
            ),
          ),
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

  final MockRecentRequest request;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
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
                  request.title(isArabic: isArabic),
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
            label: request.status(isArabic: isArabic),
            tone: switch (request.tone) {
              MockHomeRequestTone.pending => OtlobBadgeTone.warning,
              MockHomeRequestTone.inProgress => OtlobBadgeTone.info,
            },
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(MockHomeVisual visual) {
  return switch (visual) {
    MockHomeVisual.cleaning => Icons.cleaning_services_outlined,
    MockHomeVisual.airConditioning => Icons.ac_unit,
    MockHomeVisual.plumbing => Icons.plumbing,
    MockHomeVisual.electrical => Icons.electrical_services_outlined,
  };
}
