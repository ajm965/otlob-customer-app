import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/authentication_state.dart';
import '../widgets/authentication_scaffold.dart';
import 'state/mock_authentication_controller.dart';

class RegistrationProfilePage extends ConsumerStatefulWidget {
  const RegistrationProfilePage({super.key});

  @override
  ConsumerState<RegistrationProfilePage> createState() =>
      _RegistrationProfilePageState();
}

class _RegistrationProfilePageState
    extends ConsumerState<RegistrationProfilePage> {
  late final TextEditingController _nameController;
  bool _hasAcceptedTerms = false;
  bool _showTermsError = false;

  @override
  void initState() {
    super.initState();
    final AuthenticationState state = ref.read(mockAuthenticationProvider);
    _nameController = TextEditingController(text: state.fullName);
    _hasAcceptedTerms = state.hasAcceptedTerms;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _complete() {
    if (!_hasAcceptedTerms) {
      setState(() => _showTermsError = true);
      return;
    }
    ref
        .read(mockAuthenticationProvider.notifier)
        .completeRegistration(
          fullName: _nameController.text,
          hasAcceptedTerms: _hasAcceptedTerms,
        )
        .then((bool completed) {
          if (!mounted) {
            return;
          }
          if (!completed) {
            context.go(AppRoute.authentication.path);
            return;
          }
          context.pushReplacement(AppRoute.authenticationSuccess.path);
        });
  }

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final AuthenticationState auth = ref.watch(mockAuthenticationProvider);
    final bool hasRequiredState =
        auth.flow == AuthenticationFlow.registration && auth.isOtpVerified;

    if (!hasRequiredState) {
      return Scaffold(
        appBar: OtlobAppBar(title: Text(localizations.registrationProfile)),
        body: OtlobErrorState(
          title: localizations.authenticationStepUnavailable,
          actionLabel: localizations.restartAuthentication,
          onAction: () => context.go(AppRoute.authentication.path),
        ),
      );
    }

    return AuthenticationScaffold(
      title: localizations.registrationProfile,
      children: <Widget>[
        Text(
          localizations.registrationProfileMessage,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OtlobSpacing.xl),
        OtlobTextField(
          key: const ValueKey<String>('registration-name-input'),
          controller: _nameController,
          label: localizations.fullNameOptional,
          hint: localizations.fullNameHint,
          prefixIcon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.name],
        ),
        const SizedBox(height: OtlobSpacing.lg),
        CheckboxListTile(
          key: const ValueKey<String>('terms-checkbox'),
          value: _hasAcceptedTerms,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(localizations.acceptTermsAndPrivacy),
          onChanged: (bool? value) {
            setState(() {
              _hasAcceptedTerms = value ?? false;
              _showTermsError = false;
            });
          },
        ),
        if (_showTermsError)
          Text(
            localizations.termsAcceptanceRequired,
            key: const ValueKey<String>('terms-validation-error'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        const SizedBox(height: OtlobSpacing.xl),
        OtlobButton(
          label: localizations.finishMockRegistration,
          onPressed: _complete,
        ),
        const SizedBox(height: OtlobSpacing.lg),
        AuthenticationNotice(message: localizations.localAuthenticationNotice),
      ],
    );
  }
}
