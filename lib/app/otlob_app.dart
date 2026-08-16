import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../config/app_config/app_config.dart';
import '../core/localization/otlob_localizations.dart';
import '../core/router/app_router.dart';
import '../core/theme/otlob_theme.dart';

class OtlobApp extends StatefulWidget {
  const OtlobApp({required this.config, required this.router, super.key});

  final AppConfig config;
  final AppRouter router;

  @override
  State<OtlobApp> createState() => _OtlobAppState();
}

class _OtlobAppState extends State<OtlobApp> {
  late final Locale? _locale = _resolveInitialLocale();

  Locale? _resolveInitialLocale() {
    final String? configuredLocale = widget.config.initialLocale;
    if (configuredLocale == null) {
      return null;
    }
    return Locale(configuredLocale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Otlob',
      debugShowCheckedModeBanner: false,
      theme: OtlobTheme.light(),
      darkTheme: OtlobTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: widget.router.router,
      locale: _locale,
      supportedLocales: OtlobLocalizations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        OtlobLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: _resolveLocale,
    );
  }

  Locale _resolveLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) {
      return OtlobLocalizations.supportedLocales.first;
    }
    for (final Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return OtlobLocalizations.supportedLocales.first;
  }
}
