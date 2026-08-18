# Sprint C9 — Customer Integration Boundary Foundation

## 1. Scope and dependency flow

Sprint C9 establishes offline, feature-owned repository boundaries without
adding a network dependency or modifying the backend.

```text
Presentation → feature domain repository → mock data implementation
                                      ↘ future transport/data source
```

`AppRouter` is the current injectable composition root. It accepts repository
interfaces and defaults to offline mock implementations. It injects them into
the existing screens and route scopes. Widgets now use feature domain
projections and repository contracts, not fixture classes.

## 2. Backend repositories and contracts inspected

The sibling `/Users/shatii/otlob-platform` repository was inspected read-only.

- `backend/modules/auth/`: placeholder only; no approved TypeScript OTP,
  sign-in, session, bootstrap, or device contracts.
- `backend/modules/users/domain/entities/user.ts`,
  `domain/enums/global_role.ts`, `domain/enums/user_status.ts`, and
  `domain/repositories/i_users_repository.ts`: structural user/profile
  contract. User contains role, name, nullable email/phone, locale, status,
  market/country, and authorization version.
- `packages/core/src/value_objects/phone.ts`: E.164 phone validation.
- `backend/modules/services/domain/entities/service.ts` and
  `domain/repositories/i_services_repository.ts`: service has ID, category ID,
  localized name, status, market, and country.
- `backend/modules/categories/domain/entities/category.ts`: category has ID,
  localized name, status, sort order, market, and country.
- `backend/modules/requests/domain/entities/service_request.ts`,
  `domain/enums/request_status.ts`, and
  `domain/repositories/i_requests_repository.ts`: request has ID, customer,
  service, status, description, optional geographic location and preferred
  window, optional offer/booking IDs, market, and country.
- `backend/modules/{services,requests,users}/application/dto/**` and
  `application/use_cases/**`: current DTOs intentionally contain only IDs and
  market scope; their CRUD use-case contracts are shape-only.
- `docs/API.md`: `/auth/bootstrap`, `/auth/me`, catalog endpoints, and request
  create/list/get endpoint design.
- `docs/SECURITY.md`, `docs/TECH_STACK.md`,
  `docs/product/USER_JOURNEYS.md`, and `docs/product/ERROR_SCENARIOS.md`:
  customer phone OTP intent and error concepts.

No backend file was changed.

## 3. Authentication integration boundary

`AuthenticationRepository` owns only the operations needed by the C8 journey:
phone validation, starting the selected phone flow, local verification, and
registration completion. `AuthenticationState` is an app journey projection,
not a token or backend session. The route scope receives this abstraction from
the router composition root.

## 4. Services integration boundary

`ServiceCatalogRepository` exposes category/service lists and service lookup by
stable ID. Existing catalog fixtures implement the same contract, and service
widgets consume `CustomerService`/`ServiceCategory` projections rather than
fixture types. Home consumes this same catalog instead of maintaining a second
service fixture.

## 5. Requests integration boundary

`CustomerRequestRepository` covers create, list, detail, and selectable mock
addresses. Request flow state remains route-scoped, while submission delegates
to the repository. History/detail widgets consume `CustomerRequest`, preserving
the existing display projection without duplicating the backend state machine.
Home recent requests are projections from this same repository.

## 6. Profile integration boundary

`CustomerProfileRepository` retrieves the current display projection only.
Editing and authentication-backed identity remain outside C9.

## 7. Repository interfaces created

- `AuthenticationRepository`
  - validates the documented Saudi/E.164 UI projection
  - begins phone authentication, verifies an OTP, and completes registration
  - returns in-memory `AuthenticationState`; it has no token/session API
- `ServiceCatalogRepository`
  - lists categories and services, and retrieves a service by ID
- `CustomerRequestRepository`
  - lists customer request projections, retrieves a projection, submits a
    request draft, and lists selectable addresses for the current mock flow
- `CustomerProfileRepository`
  - retrieves the current customer profile projection

All repository methods return `Future<IntegrationResult<T>>`, so a later
transport implementation can be asynchronous without forcing a UI rewrite.

## 8. Mock implementations

- `MockAuthenticationRepository`
- `MockServiceCatalogRepository`
- `MockCustomerRequestRepository`
- `MockCustomerProfileRepository`

They reuse the approved C5–C8 fixture values and are fully offline. They do
not call a service, persist data, generate/send OTPs, create sessions, or
produce credentials.

## 9. Mapping decisions

### Authentication and profile

The UI state is an authentication journey projection, not a backend `User`
DTO. It can currently align phone input with the core E.164 value object,
registration locale with app locale, name with the documented bootstrap
concept, and customer role conceptually with `GlobalRole.Customer`.

The mock profile is intentionally a minimal display projection. It does not
pretend to be `User`, `UserResponse`, or `/auth/me`.

### Services

`CustomerService` and `ServiceCategory` map stable IDs and Arabic/English
localized names from backend domain entities. C5 descriptions and visual
metadata are app-display projections: backend contracts do not define them.

### Requests

`RequestDraft` maps the current flow's service ID, optional description, and
selected address/location. `CustomerRequest` is an app display projection used
by history/detail. It does not duplicate backend transport DTOs.

The request status projection remains the existing C7 display-only set:
`pending`, `inProgress`, `completed`, `cancelled`. It is not presented as a
mapping to backend `draft`, `open`, `matched`, `booked`, `cancelled`,
`expired`.

## 10. Contract gaps

- No approved backend auth-module contracts exist for OTP/sign-in, session,
  bootstrap, refresh/revocation, or device registration.
- Product docs name phone OTP, but do not define OTP length, expiry, resend,
  retry limits, cooldown values, or a complete KSA-number normalization rule.
- User, service, and request application DTOs omit fields required by their
  own domain entities and API examples. They cannot yet support a safe
  Flutter transport mapper.
- `/requests` API examples include title, preferred time, budgets, and media;
  the backend request DTO currently does not. These fields are deferred.
- Backend request statuses and C7 UI statuses do not have an approved mapping.
- Services and categories have no backend description or UI-visual fields.
- `/auth/bootstrap` documents name, locale, and primary role while the product
  journey calls name/locale optional; no final requiredness contract exists.

No gap was guessed into a transport DTO or a backend state machine.

## 11. Deferred fields and behavior

Profile editing, real addresses, session restore, suspension handling,
deep-link resume, request pagination, API envelopes, service visuals and
descriptions, request title/time/budget/media fields, and actual backend error
mapping are intentionally deferred until approved transport contracts exist.

## 12. Error abstraction

`core/errors/integration_failure.dart` provides only transport-neutral failure
kinds: network, unauthorized, forbidden, not found, validation, server, and
unknown. It has no backend-specific codes and does not implement error
reporting.

## 13. Architecture dependency flow

The router is an injectable composition root with offline defaults:

```text
Widget → domain repository interface → offline mock implementation
                                  ↘ future real data implementation
```

Domain files import neither Flutter nor infrastructure packages. Presentation
does not import feature mock fixtures.

## 14. Tests executed

`test/features/integration_boundary_test.dart` verifies that repository
contracts compile and the mock authentication, services, request
creation/history/detail, and profile implementations satisfy them.

Targeted boundary tests and the complete C1–C9 suite were executed.

## 15. `flutter analyze` result

Passed with no issues.

## 16. `flutter test` result

Passed: all 40 C1–C9 tests.

## 17. Known limitations

- Offline repositories return fixed fixtures and do not share mutable state.
- C6 submission intentionally does not append to C7 history.
- Authentication completion intentionally does not change Profile.
- UI projections include presentation-only fields that cannot yet be mapped to
  approved backend DTOs.
- Repository error states have a neutral model but not full product UI for each
  future failure.

## 18. Future real integration requirements

Before a real adapter is added, backend owners must approve complete auth and
request/catalog/profile response contracts, request-status mapping, auth error
and OTP behavior, pagination, identity/session lifecycle, and transport error
mapping. A future data source may then implement these repositories without
placing HTTP, Firebase, tokens, or backend DTOs in presentation widgets.
