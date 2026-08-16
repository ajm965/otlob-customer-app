import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/app/otlob_app.dart';
import 'package:otlob_customer_app/config/app_config/app_config.dart';
import 'package:otlob_customer_app/config/environment/app_environment.dart';
import 'package:otlob_customer_app/config/environment/environment_config.dart';
import 'package:otlob_customer_app/core/router/app_route.dart';
import 'package:otlob_customer_app/core/router/app_router.dart';
import 'package:otlob_customer_app/features/authentication/presentation/authentication_entry_page.dart';
import 'package:otlob_customer_app/features/authentication/presentation/authentication_phone_page.dart';
import 'package:otlob_customer_app/features/authentication/presentation/authentication_success_page.dart';
import 'package:otlob_customer_app/features/authentication/presentation/authentication_verification_page.dart';
import 'package:otlob_customer_app/features/authentication/presentation/registration_profile_page.dart';
import 'package:otlob_customer_app/features/home/presentation/home_page.dart';

void main() {
  testWidgets(
    'authentication entry opens sign in and supports back navigation',
    (WidgetTester tester) async {
      await _pumpAt(tester, AppRoute.authentication.path);

      expect(find.byType(AuthenticationEntryPage), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.byType(AuthenticationPhonePage), findsOneWidget);
      expect(find.text('Customer sign in'), findsWidgets);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(AuthenticationEntryPage), findsOneWidget);
    },
  );

  testWidgets('sign in validates phone and completes the local mock flow', (
    WidgetTester tester,
  ) async {
    await _pumpAt(tester, AppRoute.signIn.path);

    await tester.tap(find.text('Continue to mock code'));
    await tester.pump();
    expect(find.text('Enter your mobile number'), findsOneWidget);

    await _enterText(
      tester,
      const ValueKey<String>('authentication-phone-input'),
      '0501234567',
    );
    await tester.tap(find.text('Continue to mock code'));
    await tester.pump();
    expect(
      find.text('Enter a valid Saudi number in international format'),
      findsOneWidget,
    );

    await _enterText(
      tester,
      const ValueKey<String>('authentication-phone-input'),
      '+966501234567',
    );
    await tester.tap(find.text('Continue to mock code'));
    await tester.pumpAndSettle();
    expect(find.byType(AuthenticationVerificationPage), findsOneWidget);

    await tester.tap(find.text('Verify locally'));
    await tester.pump();
    expect(find.text('Enter the mock verification code'), findsOneWidget);

    await _enterText(
      tester,
      const ValueKey<String>('authentication-code-input'),
      'local-demo',
    );
    await tester.tap(find.text('Verify locally'));
    await tester.pumpAndSettle();
    expect(find.byType(AuthenticationSuccessPage), findsOneWidget);
    expect(find.textContaining('no real session was created'), findsOneWidget);

    await tester.tap(find.text('Go to Home'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('registration verifies locally and requires terms acceptance', (
    WidgetTester tester,
  ) async {
    await _pumpAt(tester, AppRoute.registration.path);

    expect(find.text('Create customer account'), findsWidgets);
    await _enterText(
      tester,
      const ValueKey<String>('authentication-phone-input'),
      '+966501234567',
    );
    await tester.tap(find.text('Continue to mock code'));
    await tester.pumpAndSettle();
    expect(find.byType(AuthenticationVerificationPage), findsOneWidget);

    await _enterText(
      tester,
      const ValueKey<String>('authentication-code-input'),
      'mock',
    );
    await tester.tap(find.text('Verify locally'));
    await tester.pumpAndSettle();
    expect(find.byType(RegistrationProfilePage), findsOneWidget);

    await tester.tap(find.text('Complete mock registration'));
    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('terms-validation-error')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey<String>('terms-checkbox')));
    await tester.pump();
    await tester.tap(find.text('Complete mock registration'));
    await tester.pumpAndSettle();
    expect(find.byType(AuthenticationSuccessPage), findsOneWidget);
  });

  testWidgets('authentication is RTL in Arabic and LTR in English', (
    WidgetTester tester,
  ) async {
    await _pumpAt(tester, AppRoute.authentication.path, initialLocale: 'ar');
    expect(
      Directionality.of(tester.element(find.byType(AuthenticationEntryPage))),
      TextDirection.rtl,
    );
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(BackButton))),
      TextDirection.rtl,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await _pumpAt(tester, AppRoute.authentication.path);
    expect(
      Directionality.of(tester.element(find.byType(AuthenticationEntryPage))),
      TextDirection.ltr,
    );
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(BackButton))),
      TextDirection.ltr,
    );
  });

  testWidgets('authentication layout has no overflow at 320 logical pixels', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpAt(tester, AppRoute.registration.path);
    expect(find.byType(AuthenticationPhonePage), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.drag(
      find.byKey(const ValueKey<String>('authentication-content')),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpAt(
  WidgetTester tester,
  String path, {
  String initialLocale = 'en',
}) async {
  final AppRouter router = AppRouter();
  await tester.pumpWidget(
    OtlobApp(
      config: AppConfig(
        environment: const EnvironmentConfig(
          environment: AppEnvironment.development,
        ),
        initialLocale: initialLocale,
      ),
      router: router,
    ),
  );
  router.router.go(path);
  await tester.pumpAndSettle();
}

Future<void> _enterText(WidgetTester tester, Key fieldKey, String value) {
  return tester.enterText(
    find.descendant(of: find.byKey(fieldKey), matching: find.byType(TextField)),
    value,
  );
}
