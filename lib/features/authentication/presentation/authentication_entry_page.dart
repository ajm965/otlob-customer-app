import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../widgets/authentication_scaffold.dart';

class AuthenticationEntryPage extends StatelessWidget {
  const AuthenticationEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return AuthenticationScaffold(
      title: localizations.authentication,
      children: <Widget>[
        Icon(
          Icons.account_circle_outlined,
          size: OtlobIconSizes.hero,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: OtlobSpacing.lg),
        Text(
          localizations.authenticationEntryMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OtlobSpacing.xl),
        OtlobButton(
          label: localizations.signIn,
          onPressed: () => context.push(AppRoute.signIn.path),
        ),
        const SizedBox(height: OtlobSpacing.md),
        OtlobOutlinedButton(
          label: localizations.createAccount,
          onPressed: () => context.push(AppRoute.registration.path),
        ),
        const SizedBox(height: OtlobSpacing.xl),
        AuthenticationNotice(message: localizations.localAuthenticationNotice),
      ],
    );
  }
}
