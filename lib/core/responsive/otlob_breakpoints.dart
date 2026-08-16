import 'package:flutter/widgets.dart';

abstract final class OtlobBreakpoints {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;
}

enum OtlobWindowClass { compact, medium, expanded, large }

extension OtlobResponsiveContext on BuildContext {
  OtlobWindowClass get windowClass {
    final double width = MediaQuery.sizeOf(this).width;
    if (width < OtlobBreakpoints.compact) {
      return OtlobWindowClass.compact;
    }
    if (width < OtlobBreakpoints.medium) {
      return OtlobWindowClass.medium;
    }
    if (width < OtlobBreakpoints.expanded) {
      return OtlobWindowClass.expanded;
    }
    return OtlobWindowClass.large;
  }
}
