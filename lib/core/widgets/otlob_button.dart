import 'package:flutter/material.dart';

import '../constants/otlob_component_sizes.dart';
import '../theme/otlob_tokens.dart';

class OtlobButton extends StatelessWidget {
  const OtlobButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.semanticLabel,
    this.fullWidth = true,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? semanticLabel;
  final bool fullWidth;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Widget content = isLoading
        ? const SizedBox.square(
            dimension: OtlobIconSizes.medium,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : _ButtonContent(label: label, icon: icon);
    final Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: content,
    );

    return Semantics(
      button: true,
      label: semanticLabel,
      child: fullWidth
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }
}

class OtlobOutlinedButton extends StatelessWidget {
  const OtlobOutlinedButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.semanticLabel,
    this.fullWidth = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? semanticLabel;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final Widget button = OutlinedButton(
      onPressed: onPressed,
      child: _ButtonContent(label: label, icon: icon),
    );

    return Semantics(
      button: true,
      label: semanticLabel,
      child: fullWidth
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }
}

class OtlobTextButton extends StatelessWidget {
  const OtlobTextButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: TextButton(
        onPressed: onPressed,
        child: _ButtonContent(label: label, icon: icon),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(label);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: OtlobIconSizes.small),
        const SizedBox(width: OtlobSpacing.sm),
        Flexible(child: Text(label)),
      ],
    );
  }
}
