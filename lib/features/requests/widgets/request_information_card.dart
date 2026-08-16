import 'package:flutter/material.dart';

import '../../../core/theme/otlob_design_system.dart';

class RequestInformationCard extends StatelessWidget {
  const RequestInformationCard({
    required this.title,
    required this.value,
    required this.icon,
    this.trailing,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return OtlobCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: OtlobSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    ?trailing,
                  ],
                ),
                const SizedBox(height: OtlobSpacing.xs),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
