import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_flow_coordinator.dart';
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
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    ref.read(mockAuthenticationProvider.notifier).syncFromCoordinator();
    final AuthenticationState state = ref.read(mockAuthenticationProvider);
    _nameController = TextEditingController(text: state.fullName);
    _hasAcceptedTerms = state.hasAcceptedTerms;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  AuthenticationState _authState() {
    ref.read(mockAuthenticationProvider.notifier).syncFromCoordinator();
    return ref.read(mockAuthenticationProvider);
  }

  Future<void> _complete() async {
    if (_isSubmitting) {
      return;
    }
    if (!_hasAcceptedTerms) {
      setState(() => _showTermsError = true);
      return;
    }

    setState(() {
      _showTermsError = false;
      _errorText = null;
      _isSubmitting = true;
    });

    final bool completed = await ref
        .read(mockAuthenticationProvider.notifier)
        .completeRegistration(
          fullName: _nameController.text,
          hasAcceptedTerms: _hasAcceptedTerms,
        );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    if (!completed) {
      final String? completeError =
          ref.read(mockAuthenticationProvider.notifier).lastCompleteError;
      setState(
        () => _errorText = completeError ??
            OtlobLocalizations.of(context).registrationSubmitFailed,
      );
      return;
    }

    context.pushReplacement(AppRoute.authenticationSuccess.path);
  }

  Widget _buildPage(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final AuthenticationState auth = _authState();
    final bool hasRequiredState = auth.isOtpVerified &&
        (auth.flow == AuthenticationFlow.registration ||
            auth.needsProfileBootstrap);

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
          enabled: !_isSubmitting,
        ),
        const SizedBox(height: OtlobSpacing.lg),
        CheckboxListTile(
          key: const ValueKey<String>('terms-checkbox'),
          value: _hasAcceptedTerms,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(localizations.acceptTermsAndPrivacy),
          onChanged: _isSubmitting
              ? null
              : (bool? value) {
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
        if (_errorText != null) ...<Widget>[
          const SizedBox(height: OtlobSpacing.md),
          Text(
            _errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: OtlobSpacing.xl),
        if (_isSubmitting)
          const LinearProgressIndicator()
        else
          OtlobButton(
            label: localizations.finishMockRegistration,
            onPressed: _complete,
          ),
        const SizedBox(height: OtlobSpacing.lg),
        AuthenticationNotice(message: localizations.localAuthenticationNotice),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(mockAuthenticationProvider);
    final AuthFlowCoordinator? coordinator = ref.watch(authFlowCoordinatorProvider);
    if (coordinator == null) {
      return _buildPage(context);
    }
    return ListenableBuilder(
      listenable: coordinator,
      builder: (BuildContext context, Widget? child) => _buildPage(context),
    );
  }
}
