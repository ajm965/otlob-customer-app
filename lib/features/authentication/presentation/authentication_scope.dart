import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationScope extends StatelessWidget {
  const AuthenticationScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: const ValueKey<String>('mock-authentication-scope'),
      child: child,
    );
  }
}
