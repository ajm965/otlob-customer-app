import 'package:flutter/material.dart';

import '../../../core/theme/otlob_design_system.dart';
import '../data/mock/mock_services.dart';

class ServiceCategoryCard extends StatelessWidget {
  const ServiceCategoryCard({
    required this.category,
    required this.isArabic,
    required this.onTap,
    super.key,
  });

  final MockServiceCategory category;
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
            size: OtlobIconSizes.large,
            color: Theme.of(context).colorScheme.primary,
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

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    required this.service,
    required this.isArabic,
    required this.onTap,
    super.key,
  });

  final MockService service;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OtlobCard(
      onTap: onTap,
      semanticLabel: service.title(isArabic: isArabic),
      child: Row(
        children: <Widget>[
          OtlobAvatar(
            radius: OtlobIconSizes.medium,
            child: Icon(_iconFor(service.visual)),
          ),
          const SizedBox(width: OtlobSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  service.title(isArabic: isArabic),
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
          ),
          const SizedBox(width: OtlobSpacing.sm),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}

IconData _iconFor(MockServiceVisual visual) {
  return switch (visual) {
    MockServiceVisual.cleaning => Icons.cleaning_services_outlined,
    MockServiceVisual.airConditioning => Icons.ac_unit,
    MockServiceVisual.plumbing => Icons.plumbing,
    MockServiceVisual.electrical => Icons.electrical_services_outlined,
    MockServiceVisual.maintenance => Icons.handyman_outlined,
    MockServiceVisual.moving => Icons.local_shipping_outlined,
  };
}
