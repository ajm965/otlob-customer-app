import 'package:flutter/material.dart';

/// Central color primitives and semantic roles for the Otlob design system.
abstract final class OtlobColors {
  static const Color brand = Color(0xFF176B5B);
  static const Color brandDark = Color(0xFF69D6C0);
  static const Color secondary = Color(0xFFB86A26);
  static const Color secondaryDark = Color(0xFFFFB77B);

  static const Color lightBackground = Color(0xFFF7F9F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF17211F);
  static const Color lightMutedText = Color(0xFF60706C);
  static const Color lightBorder = Color(0xFFD9E2DF);
  static const Color lightDisabled = Color(0xFFA8B3B0);

  static const Color darkBackground = Color(0xFF0E1513);
  static const Color darkSurface = Color(0xFF17211F);
  static const Color darkText = Color(0xFFE8EFED);
  static const Color darkMutedText = Color(0xFFAAB8B4);
  static const Color darkBorder = Color(0xFF394743);
  static const Color darkDisabled = Color(0xFF6D7976);

  static const Color success = Color(0xFF247A4D);
  static const Color successDark = Color(0xFF70D69D);
  static const Color warning = Color(0xFFA05A00);
  static const Color warningDark = Color(0xFFFFB95C);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color info = Color(0xFF2463A7);
  static const Color infoDark = Color(0xFF9DCAFF);

  static const Color scrim = Color(0x99000000);
}

@immutable
class OtlobSemanticColors extends ThemeExtension<OtlobSemanticColors> {
  const OtlobSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.mutedText,
    required this.border,
    required this.disabled,
  });

  const OtlobSemanticColors.light()
    : success = OtlobColors.success,
      warning = OtlobColors.warning,
      info = OtlobColors.info,
      mutedText = OtlobColors.lightMutedText,
      border = OtlobColors.lightBorder,
      disabled = OtlobColors.lightDisabled;

  const OtlobSemanticColors.dark()
    : success = OtlobColors.successDark,
      warning = OtlobColors.warningDark,
      info = OtlobColors.infoDark,
      mutedText = OtlobColors.darkMutedText,
      border = OtlobColors.darkBorder,
      disabled = OtlobColors.darkDisabled;

  final Color success;
  final Color warning;
  final Color info;
  final Color mutedText;
  final Color border;
  final Color disabled;

  @override
  OtlobSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? mutedText,
    Color? border,
    Color? disabled,
  }) {
    return OtlobSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      mutedText: mutedText ?? this.mutedText,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  OtlobSemanticColors lerp(covariant OtlobSemanticColors? other, double t) {
    if (other == null) {
      return this;
    }
    return OtlobSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      border: Color.lerp(border, other.border, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
    );
  }
}

extension OtlobSemanticColorsContext on BuildContext {
  OtlobSemanticColors get otlobColors =>
      Theme.of(this).extension<OtlobSemanticColors>()!;
}
