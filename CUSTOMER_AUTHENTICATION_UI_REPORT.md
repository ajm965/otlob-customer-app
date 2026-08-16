# Sprint C8 — Customer Authentication UI Foundation

## 1. Authentication journey implemented

Sprint C8 adds an Arabic-first customer phone-authentication demonstration:

1. Authentication entry presents Sign in and Create account.
2. Both paths collect a Saudi phone number.
3. Both paths open a verification screen.
4. Any non-empty mock code is accepted locally; no code is generated or sent.
5. Sign in proceeds to an explicit mock-success screen.
6. Registration proceeds to optional full name plus required Terms and Privacy
   acceptance, then to the same mock-success screen.
7. The success action leaves the route-scoped mock state and opens the existing
   Home route.

No authentication guard is enabled. Existing public Home, Services, Requests,
Profile, request-creation, and request-detail routes retain their behavior.

## 2. Sources of truth inspected

The sibling `/Users/shatii/otlob-platform` repository was inspected read-only.

Product and platform documents:

- `docs/product/USER_JOURNEYS.md`: guest soft gate; phone-first customer
  registration; OTP verification; optional name and locale bootstrap; required
  Terms and Privacy acceptance; Home landing; existing-account switch to Login;
  phone/OTP failure concepts.
- `docs/product/MVP_SCOPE.md`: customer phone registration/login is MVP and the
  customer UX is Arabic-first with English secondary.
- `docs/API.md`: identity-provider sign-in is outside the REST profile contract;
  `/auth/bootstrap` accepts `fullName`, `locale`, and `primaryRole`; `/auth/me`
  and device endpoints are future integration surfaces.
- `docs/SECURITY.md`: customer Phone OTP is the primary planned method; real
  token/session verification and revocation are backend responsibilities.
- `docs/TECH_STACK.md`: phone OTP is the preferred customer method.
- `docs/product/ERROR_SCENARIOS.md`: inline localized required-field errors,
  invalid phone/OTP presentation, and future wrong/rate-limited OTP states.
- `docs/product/ACCEPTANCE_CRITERIA.md`: no concrete authentication acceptance
  criteria, OTP length, resend contract, or retry/cooldown values are defined.
- `docs/FIRESTORE_STRUCTURE.md`: persisted phone representation is `phoneE164`.
- `docs/engineering/SECURITY_STANDARDS.md` and
  `docs/engineering/LOGGING_GUIDE.md`: OTP abuse is security-owned and OTP codes
  must not be logged.

Backend/core contracts:

- `backend/modules/users/domain/entities/user.ts`: user has roles, primary role,
  full name, nullable email/phone, `ar|en` locale, status, market, and country.
- `backend/modules/users/domain/enums/global_role.ts`: `customer` is an approved
  primary role.
- `backend/modules/users/application/dto/requests/user_request.ts`:
  create-user request currently exposes only market scope and optional ID.
- `backend/modules/users/application/dto/commands/user_command_dto.ts`:
  registration command contract exposes no phone/OTP rules.
- `backend/modules/users/application/dto/responses/user_response.ts` and
  `backend/modules/users/application/use_cases/commands/i_create_user_use_case.ts`:
  contracts are intentionally shape-only and define no authentication behavior.
- `packages/core/src/value_objects/phone.ts`: canonical phone validation is
  E.164 (`^\+[1-9]\d{7,14}$`).

No sibling-repository file was modified.

## 3. Screens created

- Authentication entry
- Customer sign-in phone entry
- Customer registration phone entry
- Shared mock phone-verification UI
- Registration profile/consent completion
- Explicit mock-authentication success
- Safe unavailable-step presentation for direct access without required local
  route state

## 4. Routes created

- `/auth`
- `/auth/sign-in`
- `/auth/sign-in/verification`
- `/auth/registration`
- `/auth/registration/verification`
- `/auth/registration/profile`
- `/auth/success`

They are registered in the existing centralized `AppRouter` under one
authentication `ShellRoute`. No redirect or production guard was added.

## 5. Mock-state approach

`MockAuthenticationController` is a feature-owned Riverpod `Notifier` inside an
`AuthenticationScope`. The scope exists only around authentication routes and
holds the selected flow, phone, local verification flag, optional name, consent,
and local completion flag in memory.

The state is not persisted, does not produce a token or credential, and is
discarded when navigation leaves the authentication shell. No repository,
service, data source, API client, secure storage, database, or global production
session abstraction was introduced.

## 6. Validation rules used

- Phone is required.
- Phone must pass the backend E.164 value-object expression and begin with
  `+966`, reflecting the documented KSA customer journey.
- Mock verification input is required but has no invented length or complexity
  rule. Any non-empty value demonstrates local transition only.
- Full name is optional, matching the product journey.
- Terms and Privacy acceptance is required for registration.

The UI does not claim that these checks authenticate a customer.

## 7. Assumptions and deliberate exclusions

- The current app locale represents the optional registration locale bootstrap;
  a duplicate locale field was not added.
- The backend aggregate currently requires `fullName`, while the customer journey
  describes name as optional and permits incomplete profiles. Sprint C8 follows
  the customer journey and defers reconciliation to real bootstrap integration.
- Exact Saudi local-number length/operator rules are not defined. The UI uses
  the documented Saudi prefix plus the canonical E.164 contract only.
- OTP length, character set, resend behavior, retry limit, lockout, and cooldown
  duration are undefined. None were invented.
- Error-scenario documents mention retry/cooldown behavior but provide no
  approved values or resend journey, so Sprint C8 adds no resend or countdown UI.
- Email/password, session restore, suspended-account blocking, deep-link resume,
  profile loading, address bootstrap, and Home Passport bootstrap are deferred.

## 8. Design System reuse

The implementation reuses `OtlobAppBar`, `OtlobButton`,
`OtlobOutlinedButton`, `OtlobTextButton`, `OtlobTextField`, `OtlobCard`,
`OtlobEmptyState`, `OtlobErrorState`, semantic colors, typography, spacing,
icon sizes, and responsive content constraints. No new core primitive was added.

## 9. RTL/LTR behavior

Arabic remains the first supported locale and renders RTL; English renders LTR.
Layouts use directional Flutter behavior, wrapping controls, centered content,
and no manually positioned directional arrow. Labels, helpers, validation
messages, notices, consent, and actions are localized in both languages.

## 10. Responsive behavior

Authentication pages use scrollable content, safe areas, design-system spacing,
and the shared maximum content width. Controls avoid fixed screen dimensions.
The phone-entry experience is widget-tested at 320×568 logical pixels with no
overflow; the same structure scales to normal and large phones.

## 11. Tests executed

`test/features/authentication/authentication_ui_test.dart` covers:

- Entry rendering
- Sign-in and registration rendering
- Back navigation
- Required and invalid phone validation
- Verification required validation
- Local sign-in success and Home navigation
- Registration verification and required consent
- Arabic RTL and English LTR
- 320 logical-pixel layout

Targeted C8 result: 5 tests passed.

## 12. `flutter analyze` result

Passed with no issues after implementation.

## 13. `flutter test` result

Passed: all 36 C1–C8 tests. The targeted authentication suite contributed 5
passing tests.

## 14. Known limitations

- Routes are intentionally unguarded.
- Authentication is not reachable through a production guest gate because
  access policy and real guards are deferred.
- Mock completion does not change Profile, Requests, or any customer data.
- Direct access to state-dependent routes displays a safe restart state.
- Terms and Privacy content/link destinations are not defined in the inspected
  contracts, so consent text is shown without invented destinations.

## 15. Deferred real authentication integration

Future work must provide the approved identity-provider adapter, OTP delivery and
verification, security-owned abuse controls, production session/token lifecycle,
profile bootstrap, account-status handling, deep-link resumption, safe form-draft
policy, legal content destinations, analytics with redaction, and backend error
mapping. That work must replace—not reinterpret—the explicitly mock controller.
