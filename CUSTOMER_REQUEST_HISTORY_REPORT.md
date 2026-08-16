# Otlob Customer App — Request History & Detail Report

## 1. Request History Architecture

The existing `RequestsPage` remains the customer history entry point and is
still driven by `MockRequests.all`. Sprint C7 converts it to local widget state
only so the customer can select a display filter without introducing a global
provider or changing any request.

Each request card now presents:

- Service title
- Request reference
- Existing display status
- Description summary
- Location summary
- Existing mock date label

Cards remain feature-owned and compose the Otlob Design System.

## 2. Request Detail Architecture

`RequestDetailPage` receives a request ID, resolves it through
`MockRequests.byId`, and renders only the matching immutable mock fixture.

The page is read-only and displays:

- Service
- Request reference
- Status badge
- Description
- Location
- Date label

An unknown ID renders `OtlobErrorState` with safe navigation back to Requests.
There are no cancel, edit, re-request, rating, chat, offer, or payment actions.

`RequestInformationCard` is a request-feature widget reused by both C6 review
and C7 detail. No request-specific component was moved into `core` or `shared`.

## 3. Routes Added

The existing centralized GoRouter configuration now includes:

```text
/requests
/requests/:requestId
```

The detail route is nested under the Requests branch of the existing
`StatefulShellRoute`. Navigation passes the fixture ID through
`AppRoute.requestDetail.pathForRequest(requestId)`.

## 4. Mock-Data Strategy

The existing fixture file remains the single history source:

```text
lib/features/requests/data/mock/mock_requests.dart
```

Each existing request was extended with bilingual description and location
summaries. No request definitions were duplicated. `MockRequests.byId`
provides a local nullable lookup and does not imitate a repository or backend
query.

C6 request-creation fixtures remain separate because mock submission is
flow-scoped and intentionally does not persist into history.

## 5. Status Presentation Strategy

Sprint C7 preserves the C5-approved customer display states:

- Pending
- In progress
- Completed
- Cancelled

`RequestStatusBadge` centralizes their localized labels and semantic badge
tones for list and detail presentation.

These values are display fixtures only. They do not define or transition the
backend request lifecycle (`draft`, `open`, `matched`, `booked`, `cancelled`,
`expired`) or booking lifecycle. A future backend adapter must use the
approved product projection; C7 does not invent that mapping.

## 6. Filtering Strategy

`RequestsPage` owns a private `_RequestFilter` value:

- All
- Pending
- In progress
- Completed
- Cancelled

Filtering uses an in-memory `where` operation over the injected immutable list.
It does not mutate requests, issue queries, create a query DTO, or persist the
selection. Empty filtered results use the existing empty-state component.

## 7. Design System Components Reused

- `OtlobAppBar`
- `OtlobBadge`
- `OtlobCard`
- `OtlobEmptyState`
- `OtlobErrorState`
- Otlob colors, typography, spacing, icon sizes, and responsive constraints

Material `ChoiceChip` is used as a standard theme-aware selection control. No
new core design-system abstraction was justified.

## 8. RTL and LTR Behavior

Arabic and English continue to use the centralized localization delegate.
Cards, filters, badges, detail summaries, and route navigation inherit ambient
directionality. Spacing uses directional or symmetric layout, flexible rows
prevent label collisions, and forward navigation icons use Material
direction-aware icon behavior.

Widget tests exercise request history and detail in Arabic RTL and English LTR.

## 9. Responsive Behavior

- Filter controls scroll horizontally instead of compressing at narrow widths.
- History and detail content is constrained by
  `OtlobLayoutConstraints.contentMaxWidth`.
- Cards use expanded text, line limits, and ellipsis where appropriate.
- Both history and detail are vertically scrollable.
- A 320 logical-pixel widget test checks list and detail for overflow.

## 10. Tests Executed

C7 coverage includes:

1. History rendering.
2. All approved display states.
3. Local filtering and reset to All.
4. Card selection and detail navigation.
5. Correct fixture resolution by ID.
6. Unknown-ID handling.
7. Existing empty-history behavior.
8. Arabic RTL.
9. English LTR.
10. 320 logical-pixel history and detail.
11. Existing C1–C6 suites.

Commands:

```text
flutter pub get
flutter analyze
flutter test
```

## 11. Flutter Analyze Result

Passed with no issues.

## 12. Flutter Test Result

Passed: 31 tests.

## 13. Assumptions

- Bilingual description and location summaries are safe display projections of
  fields already represented by Product Bible/API/domain concepts.
- Existing relative mock date labels remain display-only and are not parsed,
  sorted, or treated as backend timestamps.
- C5 status names remain the approved scope for this sprint despite differing
  from canonical backend request/booking enums.
- No status-to-backend mapping is assumed.

## 14. Known Limitations

- History is static and local.
- Filters reset when `RequestsPage` is recreated.
- C6 mock submission does not append to C7 history.
- Detail deep links resolve only IDs present in `MockRequests.all`.
- No pagination, sorting, search, refresh, real-time update, offline cache, or
  production timestamp formatting exists.

## 15. Deferred Backend Integration

A future integration sprint must:

1. Consume the approved request list/get use-case contracts.
2. Define the approved customer-facing projection from request and booking
   lifecycles.
3. Replace relative mock date labels with localized backend timestamps.
4. Add pagination/query behavior only after backend DTOs support it.
5. Preserve unknown-ID and empty states for real failures.
6. Keep all mutations outside this read-only history experience unless
   separately approved.
