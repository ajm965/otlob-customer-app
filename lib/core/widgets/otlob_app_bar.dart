import 'package:flutter/material.dart';

import '../constants/otlob_component_sizes.dart';

class OtlobAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OtlobAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    super.key,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => const Size.fromHeight(OtlobComponentHeights.appBar);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
