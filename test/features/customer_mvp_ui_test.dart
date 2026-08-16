import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/app/otlob_app.dart';
import 'package:otlob_customer_app/config/app_config/app_config.dart';
import 'package:otlob_customer_app/config/environment/app_environment.dart';
import 'package:otlob_customer_app/config/environment/environment_config.dart';
import 'package:otlob_customer_app/core/localization/otlob_localizations.dart';
import 'package:otlob_customer_app/core/router/app_router.dart';
import 'package:otlob_customer_app/core/theme/otlob_theme.dart';
import 'package:otlob_customer_app/features/home/presentation/home_page.dart';
import 'package:otlob_customer_app/features/profile/presentation/profile_page.dart';
import 'package:otlob_customer_app/features/requests/data/mock/mock_requests.dart';
import 'package:otlob_customer_app/features/requests/presentation/requests_page.dart';
import 'package:otlob_customer_app/features/services/presentation/services_page.dart';

void main() {
  testWidgets('Home renders the customer discovery experience', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('What service do you need?'), findsOneWidget);
    expect(find.text('Service categories'), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('home-scroll-view')),
      const Offset(0, -1200),
    );
    await tester.pumpAndSettle();
    expect(find.text('Recent requests'), findsOneWidget);
  });

  testWidgets('primary navigation opens Services, Requests, and Profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();
    expect(find.byType(ServicesPage), findsOneWidget);
    expect(find.text('Recommended services'), findsOneWidget);

    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestsPage), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Account overview'), findsOneWidget);
  });

  testWidgets('Requests renders every supported mock display state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();

    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Cancelled'),
      300,
      scrollable: find.descendant(
        of: find.byKey(const Key('requests-list')),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Cancelled'), findsOneWidget);
  });

  testWidgets('Requests renders its empty state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const _LocalizedFeatureHost(child: RequestsPage(items: <MockRequest>[])),
    );
    await tester.pumpAndSettle();

    expect(find.text('No requests yet'), findsOneWidget);
    expect(
      find.text('Your requests will appear here after you create one'),
      findsOneWidget,
    );
  });

  testWidgets('customer UI remains RTL under Arabic', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp(initialLocale: 'ar'));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(HomePage))),
      TextDirection.rtl,
    );
    expect(find.text('ما الخدمة التي تحتاجها؟'), findsOneWidget);
  });

  testWidgets('customer UI remains LTR under English', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(HomePage))),
      TextDirection.ltr,
    );
  });

  testWidgets('Home fits a small phone without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

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

class _LocalizedFeatureHost extends StatelessWidget {
  const _LocalizedFeatureHost({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      theme: OtlobTheme.light(),
      supportedLocales: OtlobLocalizations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        OtlobLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    );
  }
}
