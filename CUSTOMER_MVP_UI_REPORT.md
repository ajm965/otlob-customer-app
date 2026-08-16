# Otlob Customer App — MVP UI Foundation Report

## 1. Screens Implemented

### Home

The Home experience includes:

- A welcome and customer-orientation header.
- Service discovery through a read-only search entry point.
- Service categories.
- Recommended services.
- A primary create-request entry point that leads to service browsing.
- A compact recent-requests preview.

### Services

The Services area presents category and service cards with localized titles,
short descriptions, and generic visual icons. Selecting a category or service
shows a localized deferred-flow message. No booking, pricing, or submission
behavior exists.

### Requests

The Requests area renders local display-only examples for:

- Empty
- Pending
- In progress
- Completed
- Cancelled

These values are presentation fixtures, not a workflow or state machine.

### Profile

The Profile area presents a mock customer summary and placeholder account
options for personal information, language, and future help. Actions show a
localized mock-experience notice; there is no editing, authentication, or
persistence.

## 2. Navigation Map

The C3 `AppRouter` now uses `StatefulShellRoute.indexedStack`:

```text
/home      → HomePage
/services  → ServicesPage
/requests  → RequestsPage
/profile   → ProfilePage
/          → redirects to /home
```

`CustomerNavigationShell` provides one persistent Material navigation bar for
the four approved product areas. Each branch preserves its navigation state.
There are no authentication guards, business redirects, or deferred feature
routes.

## 3. Mock-Data Strategy

Mock fixtures are immutable, feature-owned, and isolated under:

```text
lib/features/home/data/mock/
lib/features/services/data/mock/
lib/features/requests/data/mock/
lib/features/profile/data/mock/
```

They contain only the localized values and display enums required by their
feature. They do not implement repositories, DTOs, network contracts,
persistence, mutation, or production domain models. Removing each `data/mock`
folder and replacing its page input later will not require deleting mock
infrastructure from `core`.

No price or price range is shown because no product documentation defining
customer pricing was found in this repository.

## 4. Design System Components Reused

- `OtlobAppBar`
- `OtlobAvatar`
- `OtlobBadge`
- `OtlobButton`
- `OtlobCard`
- `OtlobEmptyState`
- `OtlobSearchField`
- `OtlobTextButton`
- `OtlobTheme`
- Semantic colors, typography, spacing, icon sizes, and responsive constraints

Feature widgets compose these primitives and do not redefine visual tokens.

## 5. New Reusable Design-System Additions

- `OtlobNavigationBar`: a generic wrapper over Material 3 `NavigationBar`.
- `OtlobTextField` / `OtlobSearchField`: generic `readOnly` and `onTap`
  support for discovery entry points.
- `OtlobLayoutConstraints`: centralized content, grid-card, and responsive
  card-height constraints.

No feature-specific component was added to `core`.

## 6. UX Decisions

- The first launch opens Home and exposes all four approved areas immediately.
- Creating a request begins by browsing services, but stops before any booking
  or submission flow.
- Service and profile actions clearly state that their future flow is not
  enabled rather than pretending to mutate data.
- Requests prioritize status scanning with semantic badges and stable mock
  references.
- No pricing, address, provider, scheduling, permission, or eligibility rule
  was invented.
- No Product Bible exists inside `otlob-customer-app`. Product contracts live
  in the sibling `otlob-platform` repository. Sprint C5 therefore followed the
  explicit C5 mission scope for tabs and display states, and kept undefined
  behavior read-only and minimal.

## 7. RTL and LTR Behavior

Arabic remains the default supported locale and is rendered RTL by Flutter's
localization delegates. English renders LTR. Layout uses ambient
`Directionality`, `EdgeInsetsDirectional`, flexible rows, and forward icons
that follow Material directionality. Route order remains conceptually the same
while the navigation bar renders according to the active text direction.

Arabic and English behavior is covered by widget tests against the real
application root.

## 8. Responsive Behavior

All pages:

- Avoid fixed screen widths.
- Center content inside the design-system maximum content width.
- Use slivers or scrollable lists.
- Use max-extent grids that adapt column count to available width.
- Use flexible text and ellipsis inside constrained cards.
- Preserve safe areas and Material minimum touch targets.

A 320 × 568 logical-pixel Home test verifies that the initial customer UI
renders without an overflow exception. The same layout scales through normal
and large phone widths by changing grid column count and available content
space.

## 9. Tests Executed

The C5 suite covers:

- Home rendering.
- Services rendering through primary navigation.
- Requests rendering and all approved display statuses.
- Requests empty state.
- Profile rendering.
- Navigation between all primary areas.
- Arabic RTL.
- English LTR.
- Small-phone overflow safety.
- Existing C1–C4 design-system, bootstrap, environment, and localization tests.

Commands:

```text
flutter pub get
flutter analyze
flutter test
```

## 10. Flutter Analyze Result

Passed with no issues.

## 11. Flutter Test Result

Passed: 20 tests.

## 12. Known Limitations

- Content is intentionally local and static.
- Search is a navigation entry point, not query behavior.
- Service selection and profile options stop at localized placeholder notices.
- Request status is display-only.
- The mock customer contains no real personally identifiable information.
- Final product copy, imagery, service taxonomy, and customer data contracts
  require approved product and backend specifications.

### Product Bible alignment note

Authoritative product docs were later confirmed outside this repository in:

- `/Users/shatii/otlob-platform/docs/product/PRODUCT_BIBLE_INDEX.md`
- `/Users/shatii/otlob-platform/docs/product/UX_RULES.md`
- `/Users/shatii/otlob-platform/docs/product/STATE_MACHINE.md`

Material deltas between the Sprint C5 mission and that Product Bible:

| Topic | Sprint C5 mission | Product Bible |
|-------|-------------------|---------------|
| Primary tabs | Home / Services / Requests / Profile | Home / Requests / Wallet / Profile |
| Request statuses | Pending / In progress / Completed / Cancelled | Request: `draft` / `open` / `booked` / `cancelled` / `expired`; Booking: `confirmed` / `in_progress` / `completed` / `cancelled` |
| Services | Dedicated Services experience | Catalog categories appear in create-request journey, not as a named primary tab |

Sprint C5 intentionally followed the mission's product scope and display-state
list for the first mock UI foundation. Aligning navigation and status labels
to the Product Bible requires an explicit follow-up approval and should not be
treated as already complete.

## 13. Deferred Functionality

- Authentication, registration, OTP, and account ownership.
- Booking, request creation, request mutation, and service details.
- Firebase, REST, HTTP, WebSocket, database, or cloud storage.
- Offers, chat, wallet, payments, notifications, reviews, support, maps,
  settings, and Home Passport.
- Real profile editing, language persistence, and backend synchronization.
- Production data, analytics, permissions, pricing rules, and feature
  workflows.
