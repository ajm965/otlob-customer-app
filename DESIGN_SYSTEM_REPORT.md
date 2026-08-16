# Otlob Customer Design System — Sprint C2

## 1. Design Philosophy

The Otlob customer design system is calm, clear, and dependable. It uses a
restrained visual language suitable for high-frequency home-service journeys:
strong hierarchy, generous touch targets, familiar Material behavior, and
minimal decoration.

The visual direction is Arabic-first without being Arabic-only. Components rely
on Flutter directionality instead of fixed left/right assumptions, while the
palette and type scale remain appropriate for future GCC markets. The system is
an original Otlob foundation and does not reproduce competitor branding.

## 2. Color System

The palette is intentionally small and semantic:

- Primary uses a deep teal in light mode and a lighter teal in dark mode. Teal
  communicates trust and service quality without relying on common competitor
  identities.
- Secondary uses a restrained warm amber to add friendliness and emphasis.
- Background and surface colors are neutral with a subtle green undertone,
  keeping long sessions comfortable.
- Text, muted text, border, and disabled roles define hierarchy without ad hoc
  opacity decisions.
- Success, warning, error, and info colors communicate state consistently.

Raw values live in `OtlobColors`. Theme-sensitive non-Material roles are exposed
through `OtlobSemanticColors`, a `ThemeExtension`. Material roles are delivered
through each theme's `ColorScheme`. Widgets must consume semantic roles rather
than select raw colors.

## 3. Typography System

`OtlobTypography` provides one type hierarchy for Arabic and English:

- Display and heading styles for major hierarchy.
- Title styles for sections and component headings.
- Body styles for primary and supporting copy.
- Label styles for controls, captions, and metadata.
- A numeric style with tabular figures for prices, totals, ratings, and other
  aligned values.

Font sizes, weights, and line-height ratios are separate centralized tokens.
No custom font is bundled. Flutter's platform text fallback is used so Arabic
and Latin scripts render with licensed system fonts. A custom font may only be
introduced after licensing, Arabic glyph coverage, weight coverage, and
performance are approved.

## 4. Spacing System

`OtlobSpacing` defines a compact scale from `xxs` through `xxxl`, anchored
around practical 4, 8, 12, 16, 24, 32, and 48 logical-pixel increments.
Components use this scale for padding and gaps. New values should not be added
for a single component; first choose the nearest existing role.

## 5. Radius System

`OtlobRadius` provides:

- Small radius for compact controls.
- Medium radius for standard controls.
- Large and extra-large radii for cards and sheets.
- Pill radius for badges and fully rounded elements.

Radius communicates component family and grouping, not business state.

## 6. Elevation System

`OtlobElevation` limits Material elevation to none, low, medium, and high.
`OtlobShadows` provides low and medium neutral shadows for cases where explicit
decoration is required. Borders should be preferred for routine surface
separation; shadows are reserved for overlays or meaningful depth.

## 7. Component Inventory

- `OtlobButton`: primary action with optional icon and loading state.
- `OtlobOutlinedButton`: secondary outlined action.
- `OtlobTextButton`: low-emphasis action.
- `OtlobTextField`: generic themed text input.
- `OtlobSearchField`: generic search input with optional accessible clear
  action.
- `OtlobCard`: static or interactive generic surface.
- `OtlobBadge`: neutral, success, warning, error, and info labels.
- `OtlobDivider`: token-aligned content separator.
- `OtlobAvatar`: generic image or child avatar.
- `OtlobIconButton`: icon action requiring an accessible label.
- `OtlobLoading`: labeled live-region progress indicator.
- `OtlobEmptyState`: composable generic empty-state structure.
- `OtlobErrorState`: composable generic error-state structure.
- `OtlobBottomSheet`: safe-area-aware modal sheet presentation.
- `OtlobAppBar`: consistent Material app bar wrapper.

The inventory is intentionally limited. Future components should be added only
after at least two real use cases demonstrate a stable reusable API.

## 8. RTL Strategy

- Layout uses Flutter `Directionality` and direction-aware Material widgets.
- Insets that can differ by reading direction use `EdgeInsetsDirectional`.
- Components do not force a text direction.
- Icons and text in action rows inherit ambient directionality.
- Navigation and directional icons remain the caller's responsibility because
  meaning and mirroring vary by use case.
- Widget tests verify representative RTL action layout.

## 9. Accessibility Strategy

- Material's padded tap-target policy and a 48 logical-pixel minimum are
  centralized.
- Buttons retain native keyboard, focus, hover, pressed, and disabled behavior.
- Icon-only actions require semantic labels.
- Search clear actions require a localized semantic label.
- Loading indicators announce a live-region label.
- Text uses scalable Material text styles and does not disable text scaling.
- Semantic status colors are chosen for strong contrast; final contrast must be
  validated again when brand colors or fonts change.
- Components expose labels and compose native controls rather than rebuilding
  interaction behavior.

## 10. Dark-Mode Strategy

`OtlobTheme.light()` and `OtlobTheme.dark()` are independently configured
Material 3 themes. Dark mode uses elevated lightness for semantic accents and
dark neutral surfaces rather than simply inverting light colors.

Components read `ThemeData`, `ColorScheme`, and `OtlobSemanticColors`, so they
switch modes without conditional component code. System theme selection and
user preference persistence are intentionally outside this sprint.

## 11. Rules for Future Developers

1. Import `otlob_design_system.dart` or the narrowest required design-system
   library.
2. Use tokens for all visual constants; do not scatter color, spacing, size,
   radius, elevation, or typography values.
3. Use semantic color roles, never a raw palette value inside feature widgets.
4. Keep shared components generic and free from customer-feature terminology.
5. Prefer composition over configuration-heavy base classes.
6. Preserve native Material semantics, focus behavior, and text scaling.
7. Use directional layout APIs and test reusable layouts under RTL.
8. Require localized semantic labels for icon-only or ambiguous controls.
9. Add component tests for behavior, disabled states, semantics, and both
   directions when extending the system.
10. Do not promote a feature widget into `core/widgets` until reuse and API
    stability are demonstrated.

## 12. Intentionally Not Implemented

- Application entry point or application screens.
- Login, onboarding, home, authentication, or feature flows.
- Navigation graph or routes.
- Providers and state management.
- Firebase, HTTP, REST, API, analytics, or backend integrations.
- Repositories, use cases, models, DTOs, or business rules.
- Feature-specific widgets or content.
- Custom or downloaded fonts.
- Full localization resources and translation generation.
- User theme preference persistence.
- Brand illustrations, icons, animations, or final production assets.
- Component gallery or showcase application.
