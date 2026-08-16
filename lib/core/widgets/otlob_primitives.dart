import 'package:flutter/material.dart';

import '../constants/otlob_component_sizes.dart';
import '../theme/otlob_tokens.dart';

class OtlobDivider extends StatelessWidget {
  const OtlobDivider({this.indent = OtlobSpacing.none, super.key});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(indent: indent, endIndent: indent);
  }
}

class OtlobAvatar extends StatelessWidget {
  const OtlobAvatar({
    this.image,
    this.child,
    this.semanticLabel,
    this.radius = OtlobIconSizes.large,
    super.key,
  });

  final ImageProvider<Object>? image;
  final Widget? child;
  final String? semanticLabel;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: image != null,
      label: semanticLabel,
      child: CircleAvatar(radius: radius, foregroundImage: image, child: child),
    );
  }
}

class OtlobIconButton extends StatelessWidget {
  const OtlobIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: semanticLabel,
      isSelected: isSelected,
      icon: Icon(icon),
    );
  }
}

class OtlobLoading extends StatelessWidget {
  const OtlobLoading({
    required this.semanticLabel,
    this.size = OtlobIconSizes.large,
    super.key,
  });

  final String semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      liveRegion: true,
      child: SizedBox.square(
        dimension: size,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
