import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/app/otlob_app.dart';
import 'package:otlob_customer_app/config/app_config/app_config.dart';
import 'package:otlob_customer_app/config/environment/app_environment.dart';
import 'package:otlob_customer_app/config/environment/environment_config.dart';
import 'package:otlob_customer_app/core/router/app_route.dart';
import 'package:otlob_customer_app/core/router/app_router.dart';
import 'package:otlob_customer_app/core/router/bootstrap_placeholder_page.dart';

void main() {
  testWidgets('boots MaterialApp.router with the bootstrap route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(BootstrapPlaceholderPage), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme?.useMaterial3,
      isTrue,
    );
  });

  testWidgets('uses RTL for Arabic', (WidgetTester tester) async {
    await tester.pumpWidget(_buildApp(initialLocale: 'ar'));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(Scaffold))),
      TextDirection.rtl,
    );
    expect(find.text('تجهيز تطبيق أطلب'), findsOneWidget);
  });

  testWidgets('uses LTR for English', (WidgetTester tester) async {
    await tester.pumpWidget(_buildApp(initialLocale: 'en'));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(Scaffold))),
      TextDirection.ltr,
    );
    expect(find.text('Preparing the Otlob customer app'), findsOneWidget);
  });

  test('router starts on the temporary bootstrap route', () {
    final AppRouter router = AppRouter();

    expect(
      router.router.routeInformationProvider.value.uri.path,
      AppRoute.bootstrap.path,
    );
  });
}

OtlobApp _buildApp({String? initialLocale}) {
  return OtlobApp(
    config: AppConfig(
      environment: const EnvironmentConfig(
        environment: AppEnvironment.development,
      ),
      initialLocale: initialLocale,
    ),
    router: AppRouter(),
  );
}
