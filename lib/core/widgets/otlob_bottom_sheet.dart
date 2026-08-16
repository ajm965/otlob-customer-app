import 'package:flutter/material.dart';

import '../theme/otlob_tokens.dart';

abstract final class OtlobBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsetsDirectional.only(
            start: OtlobSpacing.lg,
            top: OtlobSpacing.sm,
            end: OtlobSpacing.lg,
            bottom: MediaQuery.viewInsetsOf(context).bottom + OtlobSpacing.lg,
          ),
          child: builder(context),
        );
      },
    );
  }
}
