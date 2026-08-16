# Otlob Customer App — Request Creation Flow Report

## 1. Request Flow Map

```text
Services catalog
  → Request start / selected service
  → Optional request description
  → Mock service location
  → Review
  → Local mock submission
  → Mock success
  → Requests
```

The flow is entered from the existing C5 Services catalog. Back navigation
uses the GoRouter stack, while completion explicitly navigates to Requests.
The persistent primary navigation bar is intentionally hidden during the
focused request journey.

## 2. Screens Created

- `RequestStartPage` confirms the service selected from the existing catalog.
- `RequestDetailsPage` captures an optional local description.
- `RequestLocationPage` selects one of the isolated mock addresses and blocks
  continuation until a location is selected.
- `RequestReviewPage` presents service, description, and location without
  pricing, scheduling, provider selection, or payment.
- `RequestSuccessPage` shows an explicit local-only result and mock reference.

`RequestStepScaffold` provides a feature-owned, scroll-safe step indicator and
layout. `MockAddressCard` and `RequestReviewCard` remain request-specific
widgets under the feature.

## 3. Routes Created

Centralized in the existing `AppRoute` and `AppRouter`:

```text
/request/new/:serviceId
/request/new/:serviceId/details
/request/new/:serviceId/location
/request/new/:serviceId/review
/request/new/:serviceId/success
```

A GoRouter `ShellRoute` wraps these routes in one request-flow provider scope.
The `serviceId` route parameter is resolved against the existing
`MockServices.popular` catalog. No second service catalog was created.

## 4. State Management Approach

Riverpod is used only inside `RequestFlowScope`.

- `requestFlowServiceIdProvider` injects the selected route service.
- `requestFlowProvider` owns one immutable `MockRequestDraft`.
- `RequestFlowController` updates description and address selection and creates
  a local mock submission result.
- Leaving the flow disposes its `ProviderScope`; no request draft is global.

The controller has no repository, use case, API, persistence, network client,
or backend mapping.

## 5. Mock-Data Strategy

Request-creation fixtures live only in:

```text
lib/features/requests/data/mock/mock_request_creation.dart
```

They include:

- Two clearly labelled sample addresses.
- Postal display values and valid coordinate-shaped values.
- One deterministic local submission reference: `MOCK-REQ-0001`.
- The immutable local draft shape used by the mock controller.

This data is separate from C5 request-history display fixtures. Mock submission
does not add an item to request history or persist across the flow boundary.

## 6. Existing Backend Contracts Considered

The sibling backend repository was inspected read-only.

### Request aggregate

`/Users/shatii/otlob-platform/backend/modules/requests/domain/entities/service_request.ts`
defines `ServiceRequestProps` with:

- `customerId`
- `serviceId`
- `status`
- `description`
- nullable `location`
- nullable `preferredWindow`
- nullable accepted offer and booking IDs
- `marketId`
- `countryCode`

Sprint C6 represents only service, description, and location in local UI
state. It does not create this domain entity.

### Request application boundary

`CreateRequestRequest` and `ICreateRequestUseCase` are declared in:

```text
/Users/shatii/otlob-platform/backend/modules/requests/application/dto/requests/request_request.ts
/Users/shatii/otlob-platform/backend/modules/requests/application/use_cases/commands/i_create_request_use_case.ts
```

The approved request DTO currently exposes only optional `id` plus market
scope. It does not yet expose the detailed create payload. Sprint C6 therefore
does not invent a Flutter DTO or adapter.

Product API documentation (`/Users/shatii/otlob-platform/docs/API.md` §6.1)
describes a richer create body with `serviceId`, `addressId`, `title`,
`description`, preferred times, budgets, and `mediaUrls`. That shape is
product/API intent and is not yet encoded in the approved TypeScript DTO or
use-case contracts.

### Address and location concepts

The following backend contracts informed the mock address shape:

```text
/Users/shatii/otlob-platform/backend/modules/location/domain/entities/saved_address.ts
/Users/shatii/otlob-platform/packages/core/src/value_objects/address.ts
/Users/shatii/otlob-platform/packages/core/src/value_objects/geo_point.ts
```

The mock UI mirrors only the concepts of address ID, label, line 1, city,
country code, and coordinates. It does not duplicate backend classes.

## 7. Product Rules Used

From:

```text
/Users/shatii/otlob-platform/docs/product/USER_JOURNEYS.md
/Users/shatii/otlob-platform/docs/product/ACCEPTANCE_CRITERIA.md
/Users/shatii/otlob-platform/docs/product/STATE_MACHINE.md
/Users/shatii/otlob-platform/docs/API.md
```

Applied rules:

- Service and location are required before mock submission.
- The customer reviews service, place, and entered details.
- The journey begins from category/service discovery.
- Real publication would move a backend request from draft to open, but this
  sprint does neither and shows no real lifecycle status.
- No pricing is calculated.
- Media, preferred time, urgency, and budget remain optional product
  capabilities and are not part of the C6 mock UI.

## 8. Assumptions

- Description is optional in this UI because the acceptance criteria explicitly
  reject missing service or location but define no minimum description rule.
- A short API `title` field exists in product documentation, but it is absent
  from the approved create-request DTO and was not required by the Sprint C6
  journey steps, so no title field was invented.
- Product urgency (`normal` / `same_day` / `emergency`) appears in journeys and
  engines, but is absent from the approved create DTO and Firestore request
  field table; it remains deferred.
- Two generic Riyadh sample locations stand in for a future saved-address or
  manual-location provider. They contain no customer data.
- Media is supported by the Product Bible but deferred because this sprint
  prohibits backend/cloud integration and no approved local media-selection
  contract exists in the customer app.
- Preferred time and budget are optional in the Product Bible and are omitted
  to avoid introducing scheduling or pricing behavior.
- Authentication is required by the future product journey but explicitly
  outside Sprint C6.
- Mock submission intentionally does not prepend to the C5 request-history
  list, so the success screen cannot be mistaken for a backend-created request.

## 9. Design System Components Reused

- `OtlobAppBar`
- `OtlobBadge` indirectly through existing request history
- `OtlobButton`
- `OtlobCard`
- `OtlobErrorState`
- `OtlobTextField`
- Otlob color, typography, spacing, radius, icon-size, and responsive tokens

No new core design-system component was required.

## 10. Tests Executed

The C6 widget tests cover:

1. Existing service selection.
2. Navigation through every request step.
3. Description input and review.
4. Mock location selection.
5. Required-location validation.
6. Review content.
7. Local mock submission.
8. Success result and deterministic reference.
9. Navigation to Requests.
10. Arabic RTL.
11. English LTR.
12. 320 logical-pixel flow layouts.

The full C1–C6 suite is run with:

```text
flutter pub get
flutter analyze
flutter test
```

## 11. Flutter Analyze Result

Passed with no issues.

## 12. Flutter Test Result

Passed: 24 tests.

## 13. Known Limitations

- No draft survives leaving the request flow.
- Mock submission does not update C5 request history.
- No photos, map, GPS, manual pin, geocoding, or location permission exists.
- No auth gate, market selection, scheduling, urgency, budget, pricing,
  provider selection, matching, offer, payment, or notification exists.
- Direct deep links to later steps do not reconstruct missing draft input.
- The backend create-request DTO is still intentionally minimal, so future
  integration requires an approved payload contract.

## 14. Deferred Backend Integration

A future integration sprint must:

1. Consume the approved service and address application contracts.
2. Add authentication and market scope supplied by the application session.
3. Map the UI draft to the finalized create-request DTO.
4. Persist a backend draft and explicitly publish it to `open`.
5. Add media upload through approved contracts.
6. Handle offline draft recovery, validation errors, matching, and real request
   history without changing the customer-facing step architecture unnecessarily.
