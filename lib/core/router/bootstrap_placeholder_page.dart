import 'package:flutter/material.dart';

import '../localization/otlob_localizations.dart';
import '../theme/otlob_design_system.dart';

/// Temporary route proving the bootstrap and navigation foundation.
///
/// Replace this page only when an approved application flow is implemented.
class BootstrapPlaceholderPage extends StatelessWidget {
  const BootstrapPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return Scaffold(
      appBar: OtlobAppBar(
        title: Text(localizations.bootstrapTitle),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: OtlobCard(
            child: OtlobEmptyState(
              title: localizations.bootstrapTitle,
              message: localizations.bootstrapMessage,
              icon: Icons.rocket_launch_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
