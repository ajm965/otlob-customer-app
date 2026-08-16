import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/app/otlob_app.dart';
import 'package:otlob_customer_app/config/app_config/app_config.dart';
import 'package:otlob_customer_app/config/environment/app_environment.dart';
import 'package:otlob_customer_app/config/environment/environment_config.dart';
import 'package:otlob_customer_app/core/router/app_route.dart';
import 'package:otlob_customer_app/core/router/app_router.dart';
import 'package:otlob_customer_app/features/requests/presentation/request_detail_page.dart';
import 'package:otlob_customer_app/features/requests/presentation/requests_page.dart';

void main() {
  testWidgets('request history renders all approved display states', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await _openRequests(tester);

    expect(find.byType(RequestsPage), findsOneWidget);
    expect(find.text('Pending'), findsWidgets);
    expect(find.text('In progress'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.byKey(const Key('request-filters')), findsOneWidget);
  });

  testWidgets('request filtering is presentation-only', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await _openRequests(tester);

    await tester.tap(
      find.byKey(const ValueKey<String>('request-filter-pending')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home cleaning'), findsOneWidget);
    expect(find.text('AC maintenance'), findsNothing);

    await tester.tap(find.byKey(const ValueKey<String>('request-filter-all')));
    await tester.pumpAndSettle();
    expect(find.text('AC maintenance'), findsOneWidget);
  });

  testWidgets('selecting a request opens the matching read-only detail', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await _openRequests(tester);

    await tester.tap(find.text('Home cleaning'));
    await tester.pumpAndSettle();

    expect(find.byType(RequestDetailPage), findsOneWidget);
    expect(find.text('REQ-1042'), findsOneWidget);
    expect(
      find.text('Clean the living room and shared spaces'),
      findsOneWidget,
    );
    expect(find.text('Mock home, Riyadh'), findsOneWidget);
  });

  testWidgets('request detail resolves the correct request ID in LTR', (
    WidgetTester tester,
  ) async {
    final AppRouter router = AppRouter();
    await tester.pumpWidget(_buildApp(router: router));
    await tester.pumpAndSettle();

    router.router.go(AppRoute.requestDetail.pathForRequest('request-progress'));
    await tester.pumpAndSettle();

    expect(find.byType(RequestDetailPage), findsOneWidget);
    expect(find.text('AC maintenance'), findsOneWidget);
    expect(find.text('REQ-1038'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(RequestDetailPage))),
      TextDirection.ltr,
    );
  });

  testWidgets('unknown request ID is handled safely', (
    WidgetTester tester,
  ) async {
    final AppRouter router = AppRouter();
    await tester.pumpWidget(_buildApp(router: router));
    await tester.pumpAndSettle();

    router.router.go(AppRoute.requestDetail.pathForRequest('unknown-request'));
    await tester.pumpAndSettle();

    expect(find.byType(RequestDetailPage), findsOneWidget);
    expect(find.text('Request not found'), findsOneWidget);
    expect(find.text('Back to requests'), findsOneWidget);
  });

  testWidgets('request history and detail remain RTL in Arabic', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp(initialLocale: 'ar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الطلبات'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('تنظيف المنزل'));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(RequestDetailPage))),
      TextDirection.rtl,
    );
    expect(find.text('تنظيف غرفة المعيشة والمساحات المشتركة'), findsOneWidget);
  });

  testWidgets('request history and detail fit 320 logical pixels', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await _openRequests(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Home cleaning'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestDetailPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _openRequests(WidgetTester tester) async {
  await tester.tap(find.text('Requests'));
  await tester.pumpAndSettle();
}

OtlobApp _buildApp({String initialLocale = 'en', AppRouter? router}) {
  return OtlobApp(
    config: AppConfig(
      environment: const EnvironmentConfig(
        environment: AppEnvironment.development,
      ),
      initialLocale: initialLocale,
    ),
    router: router ?? AppRouter(),
  );
}
