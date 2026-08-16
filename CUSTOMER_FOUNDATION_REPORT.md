# Otlob Customer App — Foundation Report

## Scope

Sprint C1 creates only the Flutter project foundation. There is no Dart
application entry point, UI, screen, provider, model, DTO, repository, use
case, integration, API client, authentication flow, or business logic.

## Project Tree

```text
.
├── analysis_options.yaml
├── assets
│   ├── animations
│   ├── fonts
│   ├── icons
│   ├── images
│   └── translations
├── l10n
├── lib
│   ├── config
│   │   ├── app_config
│   │   ├── environment
│   │   └── flavors
│   ├── core
│   │   ├── constants
│   │   ├── errors
│   │   ├── extensions
│   │   ├── localization
│   │   ├── responsive
│   │   ├── router
│   │   ├── services
│   │   ├── theme
│   │   ├── utils
│   │   └── widgets
│   ├── features
│   │   ├── authentication
│   │   ├── chat
│   │   ├── home
│   │   ├── home_passport
│   │   ├── notifications
│   │   ├── offers
│   │   ├── profile
│   │   ├── requests
│   │   ├── reviews
│   │   ├── services
│   │   ├── settings
│   │   ├── support
│   │   └── wallet
│   └── shared
├── l10n.yaml
├── pubspec.lock
├── pubspec.yaml
├── README.md
└── test
```

Every feature contains the same empty foundation:

```text
feature/
├── data/
├── domain/
├── models/
├── presentation/
├── widgets/
└── README.md
```

Empty directories are retained in source control with `.gitkeep` files.

## Architecture

The foundation combines Feature First organization with Clean Architecture
boundaries:

- Feature First keeps ownership, navigation, tests, and future behavior within
  a named customer capability.
- `presentation` is reserved for state orchestration and UI-facing code.
- `domain` is reserved for framework-independent business rules.
- `data` is reserved for external and local data access implementations.
- `widgets` is reserved for feature-owned reusable UI.
- `models` is reserved for feature-owned data representations.
- `core` is reserved for application-wide technical infrastructure.
- `shared` is reserved for abstractions reused by multiple features after reuse
  is demonstrated.

No dependency flow is implemented in this sprint. Future code should keep
domain independent from presentation, data, Flutter, and infrastructure.

## Packages

Runtime:

- `flutter_riverpod ^3.3.2` — Riverpod integration for future state management.
- `flutter_hooks ^0.21.3+1` — future lifecycle and composition helpers.
- `go_router ^17.5.0` — future declarative routing.
- `freezed_annotation ^3.1.0` — annotations for future immutable types.
- `json_annotation ^4.9.0` — annotations for future JSON serialization.
- `intl ^0.20.3` — future internationalization support.
- `logger ^2.7.0` — future structured application logging.
- `equatable ^2.1.0` — future value equality.

Development:

- `freezed ^3.2.3`
- `json_serializable 6.11.2`
- `build_runner ^2.15.1`
- `flutter_lints ^6.0.0`
- Flutter SDK test tooling

`json_serializable` is pinned to the newest version resolvable with the
installed Flutter 3.38.5 / Dart 3.10.4 toolchain and the selected Riverpod
version.

## Folder Responsibilities

- `lib/core/theme`: future application theme primitives.
- `lib/core/router`: future global routing configuration.
- `lib/core/constants`: future stable application-wide constants.
- `lib/core/extensions`: future generic language and framework extensions.
- `lib/core/utils`: future stateless general utilities.
- `lib/core/widgets`: future truly application-wide UI primitives.
- `lib/core/responsive`: future layout breakpoints and adaptation primitives.
- `lib/core/errors`: future shared error taxonomy and mapping.
- `lib/core/services`: future infrastructure service contracts and adapters.
- `lib/core/localization`: future localization helpers.
- `lib/config/environment`: future environment definitions.
- `lib/config/flavors`: future flavor definitions.
- `lib/config/app_config`: future typed application configuration.
- `lib/shared`: future proven cross-feature abstractions.
- `assets/*`: reserved static resource categories.
- `l10n`: future localization tooling output or metadata.
- `test`: future cross-feature and application-level tests.

## Future Roadmap

1. Confirm application identifiers, supported platforms, flavors, and
   deployment environments.
2. Establish the application bootstrap and dependency boundaries.
3. Define design tokens, localization policy, routing policy, and error model.
4. Add testing conventions, CI quality checks, and code-generation validation.
5. Implement features independently only after their contracts and backend
   interfaces are approved.

## Risks

- The repository is not runnable until an application entry point and platform
  projects are explicitly approved.
- `models` beside Clean Architecture layers can become ambiguous; ownership and
  dependency rules must be documented before implementation.
- `core`, `shared`, and feature `widgets` can become dumping grounds without
  strict promotion criteria.
- Flutter and package upgrades can alter generator compatibility; dependency
  upgrades must be validated as a set.
- Flavor, secret, localization, observability, and CI policies remain
  intentionally undefined.

## Recommendations

- Keep domain code framework-independent and enforce inward dependencies.
- Default new code to its owning feature; promote it only after demonstrated
  reuse.
- Keep generated files out of manual review and regenerate them in CI.
- Pin the Flutter SDK in CI and use lockfile-based dependency resolution.
- Add architecture checks before feature development expands.
- Never commit secrets or environment-specific credentials.

## Quality Gate

- [x] Clean Architecture folder boundaries exist.
- [x] Feature First organization exists.
- [x] No Firebase dependency or configuration exists.
- [x] No screens exist.
- [x] No business logic exists.
- [x] No API or HTTP dependency exists.
- [x] No Dart implementations exist.
