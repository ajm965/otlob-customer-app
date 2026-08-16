import 'package:flutter/material.dart';

import '../constants/otlob_component_sizes.dart';
import 'otlob_colors.dart';
import 'otlob_tokens.dart';
import 'otlob_typography.dart';

abstract final class OtlobTheme {
  static ThemeData light() {
    return _build(
      brightness: Brightness.light,
      primary: OtlobColors.brand,
      secondary: OtlobColors.secondary,
      background: OtlobColors.lightBackground,
      surface: OtlobColors.lightSurface,
      text: OtlobColors.lightText,
      border: OtlobColors.lightBorder,
      error: OtlobColors.error,
      semanticColors: const OtlobSemanticColors.light(),
    );
  }

  static ThemeData dark() {
    return _build(
      brightness: Brightness.dark,
      primary: OtlobColors.brandDark,
      secondary: OtlobColors.secondaryDark,
      background: OtlobColors.darkBackground,
      surface: OtlobColors.darkSurface,
      text: OtlobColors.darkText,
      border: OtlobColors.darkBorder,
      error: OtlobColors.errorDark,
      semanticColors: const OtlobSemanticColors.dark(),
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color text,
    required Color border,
    required Color error,
    required OtlobSemanticColors semanticColors,
  }) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: error,
    );
    final TextTheme textTheme = OtlobTypography.textTheme(text);
    final OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(OtlobRadius.md),
      borderSide: BorderSide(color: border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: <ThemeExtension<dynamic>>[semanticColors],
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        centerTitle: false,
        elevation: OtlobElevation.none,
        scrolledUnderElevation: OtlobElevation.low,
        toolbarHeight: OtlobComponentHeights.appBar,
        titleTextStyle: textTheme.titleLarge,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
        modalBarrierColor: OtlobColors.scrim,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(OtlobRadius.xl),
          ),
        ),
        showDragHandle: true,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: OtlobElevation.low,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OtlobRadius.lg),
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: border,
        space: OtlobSpacing.lg,
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(
          background: primary,
          foreground: colorScheme.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle(foreground: primary, border: border),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buttonStyle(foreground: primary),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(OtlobTouchTargets.minimum),
          iconSize: OtlobIconSizes.medium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: OtlobSpacing.lg,
          vertical: OtlobSpacing.md,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: semanticColors.disabled),
        ),
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: inputBorder.copyWith(borderSide: BorderSide(color: error)),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: error, width: 2),
        ),
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: semanticColors.mutedText,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
      focusColor: primary.withValues(alpha: 0.16),
      hoverColor: primary.withValues(alpha: 0.08),
      splashColor: primary.withValues(alpha: 0.12),
    );
  }

  static ButtonStyle _buttonStyle({
    Color? background,
    required Color foreground,
    Color? border,
  }) {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll<Size>(
        Size(0, OtlobComponentHeights.standard),
      ),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(
          horizontal: OtlobSpacing.xl,
          vertical: OtlobSpacing.md,
        ),
      ),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OtlobRadius.md),
        ),
      ),
      textStyle: const WidgetStatePropertyAll<TextStyle>(
        TextStyle(fontWeight: OtlobFontWeights.semiBold),
      ),
      backgroundColor: background == null
          ? null
          : WidgetStatePropertyAll<Color>(background),
      foregroundColor: WidgetStatePropertyAll<Color>(foreground),
      side: border == null
          ? null
          : WidgetStatePropertyAll<BorderSide>(BorderSide(color: border)),
    );
  }
}
