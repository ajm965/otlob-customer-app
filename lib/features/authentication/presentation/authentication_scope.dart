import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/authentication_repository.dart';
import 'state/mock_authentication_controller.dart';

class AuthenticationScope extends StatelessWidget {
  const AuthenticationScope({
    required this.repository,
    required this.child,
    super.key,
  });

  final AuthenticationRepository repository;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: const ValueKey<String>('mock-authentication-scope'),
      overrides: [
        authenticationRepositoryProvider.overrideWithValue(repository),
      ],
      child: child,
    );
  }
}
