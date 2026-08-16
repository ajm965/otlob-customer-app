import 'package:flutter/material.dart';

import '../../../core/theme/otlob_design_system.dart';

class AuthenticationScaffold extends StatelessWidget {
  const AuthenticationScaffold({
    required this.title,
    required this.children,
    this.automaticallyImplyLeading = true,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtlobAppBar(
        title: Text(title),
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: OtlobLayoutConstraints.contentMaxWidth,
            ),
            child: ListView(
              key: const ValueKey<String>('authentication-content'),
              padding: const EdgeInsets.all(OtlobSpacing.lg),
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class AuthenticationNotice extends StatelessWidget {
  const AuthenticationNotice({
    required this.message,
    this.icon = Icons.info_outline,
    super.key,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OtlobCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: OtlobSpacing.md),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
