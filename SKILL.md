---
name: divpay-project-conventions
description: Use this skill when working on the Divpay iOS project to follow project structure, Git, branch, commit, pull request, and documentation conventions.
---

# Divpay Project Conventions

Use this file as the working agreement for every task in this repository. Before changing code, read the current project structure and keep this file updated when the structure changes.

## Project Structure

Current structure:

```text
divpay/
├── SKILL.md
├── README.md
├── divpay.xcodeproj/
├── divpay/
│   ├── Assets.xcassets/
│   ├── ContentView.swift
│   ├── SKILL.md
│   └── divpayApp.swift
├── divpayTests/
│   ├── SKILL.md
│   └── divpayTests.swift
└── divpayUITests/
    ├── SKILL.md
    ├── divpayUITests.swift
    └── divpayUITestsLaunchTests.swift
```

Planned structure as the app grows:

```text
divpay/
├── SKILL.md
├── App/
├── Models/
├── Views/
├── ViewModels/
├── Services/
├── Utilities/
├── Resources/
└── Assets.xcassets/
```

## App Structure Standard

The main app target should stay organized around a small, predictable structure:

```text
divpay/
├── SKILL.md
├── App/
│   └── divpayApp.swift
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

Local skill files:

- Root `SKILL.md`: repository-wide structure, Git, PR, commit, clean code, and path conventions.
- `divpay/SKILL.md`: main app target conventions for SwiftUI, models, view models, services, resources, and app structure.
- `divpayTests/SKILL.md`: unit test conventions for domain logic and service behavior.
- `divpayUITests/SKILL.md`: UI test conventions for launch, user flows, accessibility identifiers, and screenshots.

Folder responsibilities:

- `App`: app entry point, app-level dependency setup, root scene wiring.
- `Models`: plain Swift data types and domain entities.
- `Views`: SwiftUI screens and reusable components, grouped by feature.
- `ViewModels`: screen state, user actions, validation, and coordination between views and services.
- `Services`: reusable business logic, persistence, formatting, import/export, and system integrations.
- `Utilities`: small generic helpers and extensions that are not specific to one feature.
- `Resources`: localization, static data, and non-asset resource files.
- `Assets.xcassets`: colors, icons, images, and app icon assets.

Structure change rule:

- If a task adds, removes, renames, or moves a folder in the main app structure, propose an update to this `SKILL.md`.
- If a task introduces a new architectural layer, shared service, resource convention, or feature grouping that affects where future files should live, propose an update to this `SKILL.md`.
- If a task only edits implementation inside the existing structure, no structure update is required unless the change reveals that the current convention is misleading.
- When proposing a structure update, include it in the same PR as the structural change unless the user asks to split documentation separately.

Guidelines:

- Update the `Project Structure` section whenever files or folders are added, removed, renamed, or meaningfully reorganized.
- Keep SwiftUI view code focused on presentation and user interaction.
- Put core bill-splitting logic in plain Swift models/services so it can be unit tested.
- Put reusable UI into small SwiftUI components under `Views` when the project grows.
- Add or update tests when changing calculation logic, persistence, or user-facing flows.
- Keep unrelated refactors out of a task branch.

## Code Quality

Follow clean code principles for every change:

- Prefer small, focused types and functions with clear names.
- Keep one responsibility per model, service, view model, or view component.
- Avoid duplicating business logic; extract shared calculation logic into services or utilities.
- Keep business rules out of SwiftUI views when they can live in testable Swift code.
- Prefer readable code over clever code.
- Delete dead code instead of leaving commented-out blocks.
- Add comments only when the intent is not obvious from the code itself.
- Keep public APIs minimal and meaningful.
- Preserve existing project style unless there is a strong reason to improve it.
- When a change becomes too large, split it into smaller tasks or PRs.

## Path And Import Hygiene

Keep paths simple and stable:

- Prefer clear absolute or project-root-relative paths in documentation, scripts, and generated instructions.
- Avoid long chains like `../../../..` when a cleaner option exists.
- If repeated path traversal appears, introduce a named base path, helper, build setting, or small utility instead.
- Do not hard-code machine-specific paths inside app code.
- In docs, use paths from the repository root, for example `divpay/ContentView.swift`.
- In Swift code, prefer platform APIs such as `Bundle`, `FileManager`, asset catalogs, and typed resources instead of hand-built fragile paths.
- Keep imports minimal; remove unused imports when touching a file.
- Do not add global path helpers unless they remove real repetition or confusion.

## Git Workflow

Every task must be done on its own branch and completed through a pull request.

Branch naming:

```text
feature/short-task-name
fix/short-bug-name
docs/short-doc-name
refactor/short-refactor-name
test/short-test-name
chore/short-maintenance-name
```

Examples:

```text
feature/add-expense-form
fix/rounding-split-total
docs/update-launch-process
refactor/extract-split-service
test/add-split-calculator-tests
chore/update-xcode-settings
```

Before starting a task:

```sh
git status --short --branch
git switch main
git pull --ff-only
git switch -c feature/short-task-name
```

If there is no remote yet, skip `git pull --ff-only` until `origin` is configured.

## Commit Convention

Commit messages must follow:

```text
type/short-description
```

Allowed types:

- `feat`: new feature or user-facing capability.
- `fix`: bug fix.
- `docs`: documentation-only change.
- `style`: formatting or visual polish without behavior changes.
- `refactor`: code restructuring without changing behavior.
- `test`: adding or updating tests.
- `chore`: maintenance, project settings, dependency or tooling changes.

Examples:

```text
feat/add-expense-form
fix/settlement-rounding
docs/add-development-process
style/polish-summary-screen
refactor/extract-split-calculator
test/add-even-split-tests
chore/configure-ci
```

Keep commits focused. If one task changes unrelated areas, split it into separate commits or separate branches.

## Pull Request Convention

Each task must open a pull request before merging to `main`.

PR title format:

```text
[Edited Place] Content Here
```

Use Title Case for the content part: capitalize the first letter of each important word.

Examples:

```text
[README] Add Build And Launch Process
[SplitService] Add Settlement Calculation
[ExpenseForm] Add Participant Selection
```

PR body format:

```markdown
## Summary
Short explanation of what changed and why.

## Details
+ Added ...
+ Updated ...
+ Fixed ...
+ Tested ...
```

Rules:

- Keep `Summary` concise and user-facing.
- Use `Details` for concrete implementation notes.
- Include testing notes in `Details`.
- Mention any known limitation or follow-up if the task is intentionally incomplete.
- Do not merge a PR if the app does not build or relevant tests fail, unless the PR explicitly documents why.

## Pre-PR Checklist

Run these before opening a PR when Xcode is configured:

```sh
xcodebuild \
  -project divpay.xcodeproj \
  -scheme divpay \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

If the exact simulator does not exist, list available devices and pick one:

```sh
xcrun simctl list devices available
```

Always check the diff before committing:

```sh
git status --short --branch
git diff
```
