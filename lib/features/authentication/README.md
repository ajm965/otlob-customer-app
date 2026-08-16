# Authentication feature

Sprint C8 provides a customer phone authentication UI journey with feature-scoped,
in-memory mock state only.

- `data/mock/`: immutable local demonstration state.
- `presentation/`: entry, phone, verification, optional profile, and success UI.
- `presentation/state/`: explicitly mock Riverpod controller scoped to auth routes.
- `widgets/`: authentication-only layout composition.

There is no identity-provider SDK, API client, repository implementation, token,
session persistence, OTP delivery, or real OTP verification. Future production
integration must replace the mock controller while preserving the approved route
and presentation boundaries.
