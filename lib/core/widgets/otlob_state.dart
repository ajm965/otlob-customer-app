import 'package:flutter/material.dart';

import '../constants/otlob_component_sizes.dart';
import '../theme/otlob_tokens.dart';
import 'otlob_button.dart';

class OtlobEmptyState extends StatelessWidget {
  const OtlobEmptyState({
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel and onAction must be provided together.',
       );

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _OtlobState(
      title: title,
      message: message,
      icon: icon,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

class OtlobErrorState extends StatelessWidget {
  const OtlobErrorState({
    required this.title,
    this.message,
    this.icon = Icons.error_outline,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel and onAction must be provided together.',
       );

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _OtlobState(
      title: title,
      message: message,
      icon: icon,
      actionLabel: actionLabel,
      onAction: onAction,
      iconColor: Theme.of(context).colorScheme.error,
    );
  }
}

class _OtlobState extends StatelessWidget {
  const _OtlobState({
    required this.title,
    required this.icon,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.all(OtlobSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: iconColor, size: OtlobIconSizes.hero),
            const SizedBox(height: OtlobSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (message != null) ...<Widget>[
              const SizedBox(height: OtlobSpacing.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (actionLabel != null) ...<Widget>[
              const SizedBox(height: OtlobSpacing.xl),
              OtlobButton(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
