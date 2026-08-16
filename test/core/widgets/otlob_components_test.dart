import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/core/theme/otlob_theme.dart';
import 'package:otlob_customer_app/core/widgets/otlob_button.dart';
import 'package:otlob_customer_app/core/widgets/otlob_text_field.dart';

void main() {
  testWidgets('OtlobButton renders and invokes its callback', (
    WidgetTester tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      _TestHost(
        child: OtlobButton(label: 'Continue', onPressed: () => presses++),
      ),
    );

    expect(find.text('Continue'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    expect(presses, 1);
  });

  testWidgets('OtlobTextField renders and accepts input', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const _TestHost(
        child: OtlobTextField(
          label: 'Name',
          hint: 'Enter a name',
          semanticLabel: 'Name field',
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Value');
    expect(find.text('Value'), findsOneWidget);
  });

  testWidgets('button icon layout follows RTL direction', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _TestHost(
        textDirection: TextDirection.rtl,
        child: OtlobButton(
          label: 'متابعة',
          icon: Icons.arrow_forward,
          onPressed: () {},
          fullWidth: false,
        ),
      ),
    );

    final Offset iconCenter = tester.getCenter(
      find.byIcon(Icons.arrow_forward),
    );
    final Offset textCenter = tester.getCenter(find.text('متابعة'));

    expect(iconCenter.dx, greaterThan(textCenter.dx));
    expect(
      tester
          .widget<Directionality>(find.byType(Directionality).last)
          .textDirection,
      TextDirection.rtl,
    );
  });
}

class _TestHost extends StatelessWidget {
  const _TestHost({
    required this.child,
    this.textDirection = TextDirection.ltr,
  });

  final Widget child;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: OtlobTheme.light(),
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(body: Center(child: child)),
      ),
    );
  }
}
