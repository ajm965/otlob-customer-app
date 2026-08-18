import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/authentication_state.dart';
import '../widgets/authentication_scaffold.dart';
import 'state/mock_authentication_controller.dart';

class AuthenticationVerificationPage extends ConsumerStatefulWidget {
  const AuthenticationVerificationPage({required this.flow, super.key});

  final AuthenticationFlow flow;

  @override
  ConsumerState<AuthenticationVerificationPage> createState() =>
      _AuthenticationVerificationPageState();
}

class _AuthenticationVerificationPageState
    extends ConsumerState<AuthenticationVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    if (_codeController.text.trim().isEmpty) {
      setState(() => _errorText = localizations.verificationCodeRequired);
      return;
    }
    ref
        .read(mockAuthenticationProvider.notifier)
        .verifyOtpLocally(_codeController.text)
        .then((bool verified) {
          if (!mounted) {
            return;
          }
          if (!verified) {
            context.go(AppRoute.authentication.path);
            return;
          }
          context.pushReplacement(
            widget.flow == AuthenticationFlow.registration
                ? AppRoute.registrationProfile.path
                : AppRoute.authenticationSuccess.path,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final AuthenticationState auth = ref.watch(mockAuthenticationProvider);
    final bool hasRequiredState =
        auth.phone.isNotEmpty && auth.flow == widget.flow;

    if (!hasRequiredState) {
      return Scaffold(
        appBar: OtlobAppBar(title: Text(localizations.verificationTitle)),
        body: OtlobErrorState(
          title: localizations.authenticationStepUnavailable,
          actionLabel: localizations.restartAuthentication,
          onAction: () => context.go(AppRoute.authentication.path),
        ),
      );
    }

    return AuthenticationScaffold(
      title: localizations.verificationTitle,
      children: <Widget>[
        Text(
          localizations.verificationMessage(auth.phone),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OtlobSpacing.xl),
        OtlobTextField(
          key: const ValueKey<String>('authentication-code-input'),
          controller: _codeController,
          label: localizations.verificationCode,
          helperText: localizations.verificationCodeHelp,
          errorText: _errorText,
          prefixIcon: Icons.dialpad_outlined,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            if (_errorText != null) {
              setState(() => _errorText = null);
            }
          },
          onSubmitted: (_) => _verify(),
        ),
        const SizedBox(height: OtlobSpacing.xl),
        OtlobButton(label: localizations.verifyMockCode, onPressed: _verify),
        const SizedBox(height: OtlobSpacing.lg),
        AuthenticationNotice(message: localizations.localAuthenticationNotice),
      ],
    );
  }
}
