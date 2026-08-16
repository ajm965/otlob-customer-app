import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/app/otlob_app.dart';
import 'package:otlob_customer_app/config/app_config/app_config.dart';
import 'package:otlob_customer_app/config/environment/app_environment.dart';
import 'package:otlob_customer_app/config/environment/environment_config.dart';
import 'package:otlob_customer_app/core/router/app_router.dart';
import 'package:otlob_customer_app/features/requests/presentation/request_details_page.dart';
import 'package:otlob_customer_app/features/requests/presentation/request_location_page.dart';
import 'package:otlob_customer_app/features/requests/presentation/request_review_page.dart';
import 'package:otlob_customer_app/features/requests/presentation/request_start_page.dart';
import 'package:otlob_customer_app/features/requests/presentation/request_success_page.dart';
import 'package:otlob_customer_app/features/requests/presentation/requests_page.dart';

void main() {
  testWidgets('customer completes the local mock request journey', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home cleaning'));
    await tester.pumpAndSettle();

    expect(find.byType(RequestStartPage), findsOneWidget);
    expect(find.text('Selected service'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestDetailsPage), findsOneWidget);

    await tester.enterText(
      find.byType(TextField),
      'The living room needs cleaning.',
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestLocationPage), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.byKey(const Key('location-validation-error')), findsOneWidget);

    await tester.tap(find.text('Mock home'));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(RequestReviewPage), findsOneWidget);
    expect(find.text('The living room needs cleaning.'), findsOneWidget);
    expect(find.textContaining('Sample address'), findsOneWidget);
    expect(
      find.text('This request will not be sent to any backend'),
      findsOneWidget,
    );

    await tester.drag(
      find.byKey(const ValueKey<String>('request-step-4')),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit mock request'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestSuccessPage), findsOneWidget);
    expect(find.text('MOCK-REQ-0001'), findsOneWidget);
    expect(find.text('Mock submission complete'), findsWidgets);

    await tester.ensureVisible(find.text('Go to Requests'));
    await tester.tap(find.text('Go to Requests'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestsPage), findsOneWidget);
  });

  testWidgets('request flow is RTL in Arabic', (WidgetTester tester) async {
    await tester.pumpWidget(_buildApp(initialLocale: 'ar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('الخدمات'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تنظيف المنزل'));
    await tester.pumpAndSettle();

    expect(find.byType(RequestStartPage), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(RequestStartPage))),
      TextDirection.rtl,
    );
    expect(find.text('الخدمة المختارة'), findsOneWidget);
  });

  testWidgets('request flow is LTR in English', (WidgetTester tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home cleaning'));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(RequestStartPage))),
      TextDirection.ltr,
    );
  });

  testWidgets('request flow has no overflow at 320 logical pixels', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('services-scroll-view')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home cleaning'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Mock home'));
    await tester.pump();
    await tester.drag(
      find.byKey(const ValueKey<String>('request-step-3')),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.drag(
      find.byKey(const ValueKey<String>('request-step-4')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    expect(find.text('Submit mock request'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

OtlobApp _buildApp({String initialLocale = 'en'}) {
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
