# Otlob Customer App

Flutter customer application foundation for Otlob.

## Scope

Sprint C1 establishes configuration, dependencies, assets, and Feature First
Clean Architecture boundaries. It intentionally contains no entry point,
screens, providers, models, integrations, or business logic.

## Architecture

- `lib/core`: application-wide technical capabilities and primitives.
- `lib/config`: placeholders for environment, flavor, and app configuration.
- `lib/shared`: future cross-feature abstractions with proven reuse.
- `lib/features`: isolated customer feature boundaries.
- `assets`: static resource locations.
- `l10n`: localization tooling placeholder.
- `test`: future automated test suites.

Each feature is divided into `presentation`, `domain`, `data`, `widgets`, and
`models`. These directories are placeholders only in Sprint C1.

See `CUSTOMER_FOUNDATION_REPORT.md` for the full foundation report.
