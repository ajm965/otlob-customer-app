import 'package:flutter/material.dart';

import '../theme/otlob_tokens.dart';

class OtlobCard extends StatelessWidget {
  const OtlobCard({
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.padding = const EdgeInsets.all(OtlobSpacing.lg),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(padding: padding, child: child);
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      container: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: onTap == null ? content : InkWell(onTap: onTap, child: content),
      ),
    );
  }
}
