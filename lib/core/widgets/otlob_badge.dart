import 'package:flutter/material.dart';

import '../theme/otlob_colors.dart';
import '../theme/otlob_tokens.dart';
import '../theme/otlob_typography.dart';

enum OtlobBadgeTone { neutral, success, warning, error, info }

class OtlobBadge extends StatelessWidget {
  const OtlobBadge({
    required this.label,
    this.tone = OtlobBadgeTone.neutral,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final OtlobBadgeTone tone;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Color foreground = _foreground(context);
    return Semantics(
      label: semanticLabel ?? label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: foreground.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(OtlobRadius.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: OtlobSpacing.md,
            vertical: OtlobSpacing.xs,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: OtlobFontWeights.semiBold,
            ),
          ),
        ),
      ),
    );
  }

  Color _foreground(BuildContext context) {
    final OtlobSemanticColors colors = context.otlobColors;
    return switch (tone) {
      OtlobBadgeTone.neutral => colors.mutedText,
      OtlobBadgeTone.success => colors.success,
      OtlobBadgeTone.warning => colors.warning,
      OtlobBadgeTone.error => Theme.of(context).colorScheme.error,
      OtlobBadgeTone.info => colors.info,
    };
  }
}
