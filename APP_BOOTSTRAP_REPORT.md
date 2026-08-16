# Otlob Customer App — Bootstrap & Navigation Foundation

## 1. Bootstrap Architecture

The bootstrap layer separates framework initialization from the entry point:

```text
main.dart
  → AppBootstrap.run()
    → BootstrapErrorHandler boundaries
    → injected/resolved EnvironmentConfig
    → AppConfig
    → AppRouter
    → OtlobApp
```

`main.dart` is intentionally a one-line asynchronous delegate. `AppBootstrap`
owns startup composition and accepts environment and error-handler injection to
make bootstrap behavior testable without external services.

## 2. Entry-Point Flow

1. `main()` invokes `AppBootstrap.run()`.
2. The bootstrap error handler installs the Flutter framework boundary.
3. The bootstrap runs in a guarded asynchronous zone.
4. An `EnvironmentConfig` is resolved from `--dart-define=APP_ENV=...` or
   defaults safely to development.
5. A minimal `AppConfig` and central `AppRouter` are composed.
6. `OtlobApp` starts through `runApp`.

## 3. Router Architecture

`AppRouter` owns a single `GoRouter` instance. `AppRoute` holds named route
paths, preventing route-path literals from spreading into future code.

The only route is `/`, which renders `BootstrapPlaceholderPage`. This is a
temporary bootstrap-only route proving that `MaterialApp.router` and
`go_router` initialize and render correctly. It is not a home screen or
feature route. There are no redirects, guards, authentication checks, or
business-dependent decisions.

## 4. Environment Strategy

`AppEnvironment` defines development, staging, and production. `EnvironmentConfig`
contains only the selected environment and state predicates; it deliberately
does not expose endpoints, credentials, API keys, or secrets.

Production values are not embedded. At build time, select a non-default
environment with a Dart define:

```text
flutter run --dart-define=APP_ENV=staging
```

Unsupported values fail early with `ArgumentError`, avoiding accidental
misconfigured builds. Environment configuration can be constructed directly
in tests or injected into `AppBootstrap`.

## 5. App Configuration

`AppConfig` is typed and only contains bootstrap requirements:

- `EnvironmentConfig`
- optional initial locale code

It intentionally avoids speculative flags, remote configuration, endpoint
definitions, secrets, and product behavior.

## 6. Localization and RTL Strategy

`OtlobLocalizations` centralizes supported locales (`ar`, `en`) and the two
temporary bootstrap strings. It is backed by the Flutter Material, Widgets,
and Cupertino localization delegates.

Arabic is the fallback/default locale and resolves to RTL through
`GlobalWidgetsLocalizations`; English resolves to LTR. The application root
does not force a direction, allowing Flutter to apply the appropriate
directionality from the active locale. Feature translations and a full ARB
catalog are intentionally deferred.

## 7. Error Handling Boundary

`BootstrapErrorHandler` defines two visible boundaries:

- Flutter framework errors use `FlutterError.onError`, present the framework
  error, then log it.
- Uncaught asynchronous errors pass through `runZonedGuarded` and are logged.

The existing `logger` package is used only for these bootstrap events. Errors
are not silently ignored; persistence, reporting, and product recovery UI are
not implemented in this sprint.

## 8. Design System Integration

`OtlobApp` uses `OtlobTheme.light()` and `OtlobTheme.dark()` directly in
`MaterialApp.router`; it does not duplicate theme configuration. The temporary
route composes `OtlobAppBar`, `OtlobCard`, `OtlobEmptyState`, and Otlob tokens
through the C2 design-system barrel. All visual behavior remains governed by
the existing Material 3 design system.

## 9. Tests Executed

- Application root renders `MaterialApp.router` and the temporary route.
- Router starts at the defined bootstrap path.
- Arabic locale renders bootstrap copy with RTL directionality.
- English locale renders bootstrap copy with LTR directionality.
- Environment predicates, invalid values, app config injection, and flavor
  mapping are covered.
- Existing design-system tests continue to run.

## 10. Analyze Result

Run before sprint completion:

```text
flutter pub get
flutter analyze
flutter test
```

Results are recorded in the Sprint C3 completion response after the commands
complete successfully.

## 11. Known Limitations

- There is no platform runner directory because C1 intentionally established
  only the Flutter package foundation. The Dart application tree and widget
  tests are bootable; platform runners require explicit approval if needed.
- Locale selection is fixed at bootstrap; in-app locale switching and user
  preference persistence are deferred.
- Bootstrap error logging is local runtime output only.
- The sole page is temporary and not a product screen.

## 12. Future Work Intentionally Deferred

- Platform-specific flavor builds.
- Authentication and route guards.
- Feature routes and feature screens.
- Firebase, APIs, HTTP clients, backend contracts, repositories, and use cases.
- Localization catalogs and feature copy.
- User settings and theme/locale persistence.
- Error reporting service, analytics, and crash monitoring.
