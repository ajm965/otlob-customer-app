import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../data/mock/mock_authentication.dart';
import 'state/mock_authentication_controller.dart';

class AuthenticationSuccessPage extends ConsumerWidget {
  const AuthenticationSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final MockAuthenticationState auth = ref.watch(mockAuthenticationProvider);
    return Scaffold(
      appBar: OtlobAppBar(
        title: Text(localizations.authenticationComplete),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: OtlobLayoutConstraints.contentMaxWidth,
            ),
            child: auth.isComplete
                ? OtlobEmptyState(
                    title: localizations.authenticationComplete,
                    message: localizations.authenticationCompleteMessage,
                    icon: Icons.verified_user_outlined,
                    actionLabel: localizations.goToHome,
                    onAction: () => context.go(AppRoute.home.path),
                  )
                : OtlobErrorState(
                    title: localizations.authenticationStepUnavailable,
                    actionLabel: localizations.restartAuthentication,
                    onAction: () => context.go(AppRoute.authentication.path),
                  ),
          ),
        ),
      ),
    );
  }
}
