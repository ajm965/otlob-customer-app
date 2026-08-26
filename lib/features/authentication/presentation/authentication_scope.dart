import 'package:flutter/widgets.dart';

/// Auth routes shell. Riverpod overrides live in the app-level [ProviderContainer].
class AuthenticationScope extends StatelessWidget {
  const AuthenticationScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
