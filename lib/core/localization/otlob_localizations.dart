import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class OtlobLocalizations {
  const OtlobLocalizations(this.locale);

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<OtlobLocalizations> delegate =
      _OtlobLocalizationsDelegate();

  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';

  String get bootstrapTitle => isArabic ? 'أطلب' : 'Otlob';

  String get bootstrapMessage =>
      isArabic ? 'تجهيز تطبيق أطلب' : 'Preparing the Otlob customer app';

  static OtlobLocalizations of(BuildContext context) {
    return Localizations.of<OtlobLocalizations>(context, OtlobLocalizations)!;
  }
}

class _OtlobLocalizationsDelegate
    extends LocalizationsDelegate<OtlobLocalizations> {
  const _OtlobLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return OtlobLocalizations.supportedLocales.any(
      (Locale supportedLocale) =>
          supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<OtlobLocalizations> load(Locale locale) {
    return SynchronousFuture<OtlobLocalizations>(OtlobLocalizations(locale));
  }

  @override
  bool shouldReload(_OtlobLocalizationsDelegate old) => false;
}
