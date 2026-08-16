import 'package:flutter/material.dart';

import '../../../core/theme/otlob_design_system.dart';

class ProfileOptionTile extends StatelessWidget {
  const ProfileOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OtlobCard(
      onTap: onTap,
      semanticLabel: label,
      child: Row(
        children: <Widget>[
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: OtlobSpacing.md),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}
