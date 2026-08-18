import 'package:flutter/material.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/customer_request.dart';

class RequestStepScaffold extends StatelessWidget {
  const RequestStepScaffold({
    required this.title,
    required this.currentStep,
    required this.children,
    this.totalSteps = 4,
    super.key,
  });

  final String title;
  final int currentStep;
  final int totalSteps;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return Scaffold(
      appBar: OtlobAppBar(title: Text(title)),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: OtlobLayoutConstraints.contentMaxWidth,
            ),
            child: ListView(
              key: ValueKey<String>('request-step-$currentStep'),
              padding: const EdgeInsets.all(OtlobSpacing.lg),
              children: <Widget>[
                Text(
                  localizations.requestStep(currentStep, totalSteps),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.otlobColors.mutedText,
                  ),
                ),
                const SizedBox(height: OtlobSpacing.sm),
                LinearProgressIndicator(
                  value: currentStep / totalSteps,
                  borderRadius: BorderRadius.circular(OtlobRadius.pill),
                ),
                const SizedBox(height: OtlobSpacing.xl),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MockAddressCard extends StatelessWidget {
  const MockAddressCard({
    required this.address,
    required this.isArabic,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final RequestAddress address;
  final bool isArabic;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OtlobCard(
      onTap: onTap,
      semanticLabel: address.label(isArabic: isArabic),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : context.otlobColors.mutedText,
          ),
          const SizedBox(width: OtlobSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  address.label(isArabic: isArabic),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: OtlobSpacing.xs),
                Text(
                  address.line1(isArabic: isArabic),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${address.city(isArabic: isArabic)}, ${address.countryCode}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.otlobColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
