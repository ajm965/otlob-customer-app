import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/authentication_state.dart';
import '../widgets/authentication_scaffold.dart';
import 'auth_flow_navigation.dart';
import 'state/mock_authentication_controller.dart';

class AuthenticationPhonePage extends ConsumerStatefulWidget {
  const AuthenticationPhonePage({required this.flow, super.key});

  final AuthenticationFlow flow;

  @override
  ConsumerState<AuthenticationPhonePage> createState() =>
      _AuthenticationPhonePageState();
}

class _AuthenticationPhonePageState
    extends ConsumerState<AuthenticationPhonePage> {
  late final TextEditingController _phoneController;
  String? _errorText;
  bool _isVerifying = false;

  bool get _isRegistration => widget.flow == AuthenticationFlow.registration;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: ref.read(mockAuthenticationProvider).phone,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    final String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _errorText = localizations.phoneRequired);
      return;
    }
    if (!ref.read(mockAuthenticationProvider.notifier).isValidKsaPhone(phone)) {
      setState(() => _errorText = localizations.phoneInvalid);
      return;
    }

    setState(() {
      _errorText = null;
      _isVerifying = true;
    });

    final bool started = await ref
        .read(mockAuthenticationProvider.notifier)
        .begin(widget.flow, phone);

    if (!mounted) {
      return;
    }

    setState(() => _isVerifying = false);

    if (!started) {
      final String? beginError =
          ref.read(mockAuthenticationProvider.notifier).lastBeginError;
      setState(
        () => _errorText = beginError ?? localizations.phoneInvalid,
      );
      return;
    }

    final AuthenticationState auth = ref.read(mockAuthenticationProvider);
    if (auth.isOtpVerified) {
      if (_isRegistration || auth.needsProfileBootstrap) {
        context.pushReplacement(AppRoute.registrationProfile.path);
      } else {
        context.pushReplacement(AppRoute.authenticationSuccess.path);
      }
      return;
    }

    context.pushReplacement(
      AuthFlowNavigation.verificationPath(
        flow: widget.flow,
        phone: auth.phone.isNotEmpty ? auth.phone : phone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return PopScope(
      canPop: !_isVerifying,
      child: AuthenticationScaffold(
        title: _isRegistration
            ? localizations.registrationTitle
            : localizations.signInTitle,
        children: <Widget>[
        Text(
          _isRegistration
              ? localizations.registrationMessage
              : localizations.signInMessage,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OtlobSpacing.xl),
        OtlobTextField(
          key: const ValueKey<String>('authentication-phone-input'),
          controller: _phoneController,
          label: localizations.phoneNumber,
          hint: localizations.phoneHint,
          helperText: localizations.phoneFormatHelp,
          errorText: _errorText,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[+0-9]')),
          ],
          autofillHints: const <String>[AutofillHints.telephoneNumber],
          onChanged: (_) {
            if (_errorText != null) {
              setState(() => _errorText = null);
            }
          },
          onSubmitted: (_) => _continue(),
        ),
        const SizedBox(height: OtlobSpacing.xl),
        if (_isVerifying) ...<Widget>[
          const LinearProgressIndicator(),
          const SizedBox(height: OtlobSpacing.md),
          Text(
            localizations.verifyingPhoneNumber,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ] else
          OtlobButton(label: localizations.sendMockCode, onPressed: _continue),
        const SizedBox(height: OtlobSpacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(
              _isRegistration
                  ? localizations.alreadyHaveAccount
                  : localizations.needCustomerAccount,
            ),
            OtlobTextButton(
              label: _isRegistration
                  ? localizations.signIn
                  : localizations.createAccount,
              onPressed: () => context.pushReplacement(
                _isRegistration
                    ? AppRoute.signIn.path
                    : AppRoute.registration.path,
              ),
            ),
          ],
        ),
        const SizedBox(height: OtlobSpacing.lg),
        if (!_isVerifying)
          AuthenticationNotice(message: localizations.localAuthenticationNotice),
        ],
      ),
    );
  }
}
