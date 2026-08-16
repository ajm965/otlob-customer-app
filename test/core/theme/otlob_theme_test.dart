import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob_customer_app/core/theme/otlob_colors.dart';
import 'package:otlob_customer_app/core/theme/otlob_theme.dart';
import 'package:otlob_customer_app/core/theme/otlob_tokens.dart';

void main() {
  group('OtlobTheme', () {
    test('creates a Material 3 light theme with semantic colors', () {
      final ThemeData theme = OtlobTheme.light();

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, OtlobColors.lightBackground);
      expect(
        theme.extension<OtlobSemanticColors>()?.success,
        OtlobColors.success,
      );
    });

    test('creates a Material 3 dark theme with semantic colors', () {
      final ThemeData theme = OtlobTheme.dark();

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, OtlobColors.darkBackground);
      expect(
        theme.extension<OtlobSemanticColors>()?.mutedText,
        OtlobColors.darkMutedText,
      );
    });
  });

  test('spacing tokens preserve the documented scale', () {
    expect(OtlobSpacing.sm, lessThan(OtlobSpacing.md));
    expect(OtlobSpacing.md, lessThan(OtlobSpacing.lg));
    expect(OtlobSpacing.lg, lessThan(OtlobSpacing.xl));
  });
}
