import 'package:flutter/material.dart';

abstract final class OtlobFontSizes {
  static const double caption = 12;
  static const double bodySmall = 14;
  static const double body = 16;
  static const double titleSmall = 18;
  static const double title = 20;
  static const double headingSmall = 24;
  static const double heading = 30;
  static const double display = 38;
  static const double numeric = 32;
}

abstract final class OtlobFontWeights {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

abstract final class OtlobLineHeights {
  static const double tight = 1.2;
  static const double normal = 1.45;
  static const double relaxed = 1.6;
}

abstract final class OtlobTypography {
  static TextTheme textTheme(Color textColor) {
    return TextTheme(
      displayLarge: _style(
        OtlobFontSizes.display,
        OtlobFontWeights.bold,
        OtlobLineHeights.tight,
        textColor,
      ),
      headlineLarge: _style(
        OtlobFontSizes.heading,
        OtlobFontWeights.bold,
        OtlobLineHeights.tight,
        textColor,
      ),
      headlineSmall: _style(
        OtlobFontSizes.headingSmall,
        OtlobFontWeights.semiBold,
        OtlobLineHeights.tight,
        textColor,
      ),
      titleLarge: _style(
        OtlobFontSizes.title,
        OtlobFontWeights.semiBold,
        OtlobLineHeights.normal,
        textColor,
      ),
      titleMedium: _style(
        OtlobFontSizes.titleSmall,
        OtlobFontWeights.semiBold,
        OtlobLineHeights.normal,
        textColor,
      ),
      bodyLarge: _style(
        OtlobFontSizes.body,
        OtlobFontWeights.regular,
        OtlobLineHeights.relaxed,
        textColor,
      ),
      bodyMedium: _style(
        OtlobFontSizes.bodySmall,
        OtlobFontWeights.regular,
        OtlobLineHeights.relaxed,
        textColor,
      ),
      labelLarge: _style(
        OtlobFontSizes.body,
        OtlobFontWeights.semiBold,
        OtlobLineHeights.normal,
        textColor,
      ),
      labelMedium: _style(
        OtlobFontSizes.bodySmall,
        OtlobFontWeights.medium,
        OtlobLineHeights.normal,
        textColor,
      ),
      labelSmall: _style(
        OtlobFontSizes.caption,
        OtlobFontWeights.medium,
        OtlobLineHeights.normal,
        textColor,
      ),
    );
  }

  static TextStyle numeric(TextTheme textTheme) {
    return TextStyle(
      color: textTheme.bodyLarge?.color,
      fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      fontSize: OtlobFontSizes.numeric,
      fontWeight: OtlobFontWeights.bold,
      height: OtlobLineHeights.tight,
    );
  }

  static TextStyle _style(
    double size,
    FontWeight weight,
    double height,
    Color color,
  ) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
      height: height,
    );
  }
}
