import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/otlob_localizations.dart';
import '../../../core/router/app_route.dart';
import '../../../core/theme/otlob_design_system.dart';
import '../domain/models/authentication_state.dart';
import '../widgets/authentication_scaffold.dart';
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

  void _continue() {
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

    ref
        .read(mockAuthenticationProvider.notifier)
        .begin(widget.flow, phone)
        .then((bool started) {
          if (started && mounted) {
            context.push(
              _isRegistration
                  ? AppRoute.registrationVerification.path
                  : AppRoute.signInVerification.path,
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final OtlobLocalizations localizations = OtlobLocalizations.of(context);
    return AuthenticationScaffold(
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
        AuthenticationNotice(message: localizations.localAuthenticationNotice),
      ],
    );
  }
}
