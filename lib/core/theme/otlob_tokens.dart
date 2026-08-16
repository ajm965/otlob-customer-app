import 'package:flutter/material.dart';

abstract final class OtlobSpacing {
  static const double none = 0;
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

abstract final class OtlobRadius {
  static const double none = 0;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;
}

abstract final class OtlobElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 4;
  static const double high = 8;
}

abstract final class OtlobShadows {
  static const List<BoxShadow> low = <BoxShadow>[
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> medium = <BoxShadow>[
    BoxShadow(color: Color(0x1F000000), blurRadius: 16, offset: Offset(0, 6)),
  ];
}
