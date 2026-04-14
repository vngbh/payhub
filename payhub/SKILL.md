---
name: payhub-app-target-conventions
description: Use this skill when changing files inside the payhub main iOS app target, including SwiftUI views, models, view models, services, resources, and assets.
---

# payhub App Target Conventions

This file applies to the main app target under `payhub/`. Follow the root `SKILL.md` first, then these app-specific rules.

Use `payhub` in lowercase for product naming everywhere, including app titles, file headers, comments, and user-facing copy.

## Standard Structure

The main app target should grow toward this structure:

```text
payhub/
├── SKILL.md
├── App/
│   └── payhubApp.swift
├── Models/
│   ├── Member.swift
│   ├── Expense.swift
│   ├── Group.swift
│   └── Settlement.swift
├── Views/
│   ├── Groups/
│   ├── Expenses/
│   ├── Settlement/
│   └── Shared/
├── ViewModels/
│   ├── GroupsViewModel.swift
│   ├── ExpenseFormViewModel.swift
│   └── SettlementViewModel.swift
├── Services/
│   ├── SplitCalculator.swift
│   ├── StorageService.swift
│   └── CurrencyFormatterService.swift
├── Utilities/
│   └── Extensions/
├── Resources/
│   └── Localizable.xcstrings
└── Assets.xcassets/
```

Current app files may still be flatter while the product is early. Move toward the standard structure when a task naturally touches the relevant area.

Current structure:

```text
payhub/
├── App/
│   └── payhubApp.swift
├── Assets.xcassets/
│   ├── AppIcon.appiconset/
│   └── PayhubLogo.imageset/
├── Models/
│   ├── Expense.swift
│   ├── Member.swift
│   └── Settlement.swift
├── Services/
│   ├── CurrencyFormatterService.swift
│   └── SplitCalculator.swift
├── SKILL.md
├── ViewModels/
│   └── GroupSplitViewModel.swift
└── Views/
    ├── Groups/
    │   ├── ContentView.swift
    │   ├── GroupSplitView.swift
    │   ├── PayhubLaunchView.swift
    │   └── Sections/
    │       ├── BalancesSection.swift
    │       ├── ExpenseFormSection.swift
    │       ├── ExpensesSection.swift
    │       ├── MembersSection.swift
    │       ├── OverviewSection.swift
    │       └── SettlementsSection.swift
    └── Shared/
        ├── EmptyStateRow.swift
        └── PayhubColor.swift
```

## Responsibilities

- `App`: app entry point, root scene wiring, app-level dependency setup.
- `Models`: plain Swift domain data, such as members, expenses, groups, balances, and settlements.
- `Views`: SwiftUI screens and reusable UI components.
- `ViewModels`: screen state, validation, actions, and coordination between views and services.
- `Services`: reusable business logic such as split calculation, persistence, formatting, export, and import.
- `Utilities`: small generic helpers and extensions.
- `Resources`: localization, sample data, and non-asset resources.
- `Assets.xcassets`: compiled app icons, colors, images, and symbol assets used by the app at runtime.

## Structure Change Rule

- Propose an update to this file when a task changes the standard app structure.
- Propose an update to the root `SKILL.md` when the change affects repository-wide structure or future file placement.
- Keep local structure notes in this file; keep Git, PR, and cross-project rules in the root `SKILL.md`.
- If a new feature area is created under `Views`, add a clear feature folder instead of scattering screens at the app root.

## SwiftUI Rules

- Keep views focused on rendering and user interaction.
- Move calculation and persistence logic out of views.
- Prefer small reusable components in `Views/Shared` only after reuse is real.
- Give important UI elements stable accessibility identifiers when they are needed by UI tests.
- Keep previews lightweight and deterministic.
- Use `Inject` hot reload only in SwiftUI views where live UI iteration is useful.
- Add `@ObserveInjection` and `.enableInjection()` together when instrumenting a view for hot reload.
- Do not put hot reload hooks in models, services, or view models.
- Use named color tokens from `Views/Shared/PayhubColor.swift` instead of direct SwiftUI colors in views.
- Add new color tokens by semantic purpose and document recurring UI color conventions in `docs/UI/SKILL.md`.

## Business Logic Rules

- Put bill-splitting logic in plain Swift services or models.
- Avoid using floating point types for money calculations when exact decimal behavior is needed.
- Keep money calculations in `Decimal`; do not use rounded UI values as stored or calculated data.
- Do not show grouping separators in money UI.
- Show money with one fractional digit in UI while keeping underlying data more precise.
- Keep rounding rules explicit and covered by unit tests.
- Keep settlement output deterministic so tests and UI remain stable.

## Path Rules

- Use project-root-relative paths in documentation.
- Avoid `../../../` style path traversal when a clearer base path, API, or resource lookup exists.
- Use `Bundle`, `FileManager`, asset catalogs, and typed resources instead of fragile hard-coded paths.
