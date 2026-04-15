---
name: payhub-project-conventions
description: Use this skill when working on the payhub iOS project to follow project structure, Git, branch, commit, pull request, and documentation conventions.
---

# payhub Project Conventions

Use this file as the working agreement for every task in this repository. Before changing code, read the current project structure and keep this file updated when the structure changes.

## Language Convention

Use English across the entire project:

- Write documentation, `SKILL.md` files, comments, commit messages, branch names, PR titles, and PR descriptions in English.
- Spell the product name as `payhub` in lowercase everywhere, including headings, user-facing copy, documentation, branch names, and PR titles.
- Write code identifiers, file names, folders, test names, fixtures, and accessibility identifiers in English.
- Use English as the default user-facing product copy unless a task is explicitly about localization.
- Put translations in localization resources or files under `docs/translate`; do not mix languages inside source files or general project documentation.
- If a task finds Vietnamese or any other non-English project text outside an explicit localization context, propose converting it to English in the same PR.

## Documentation Style Rule

- All documentation, including `README.md`, must be written in a clear, professional, and concise style.
- Do **not** use emojis or decorative icons in documentation, commit messages, PR titles, or descriptions.
- Always follow the conventions and structure defined in `SKILL.md` when updating or creating documentation.
- Before opening a PR, ensure that all documentation changes comply with the latest `SKILL.md` rules.

## Project Structure

Current structure:

```text
payhub/
├── .gitignore
├── brand/
│   └── payhub-logo-source.svg
├── DESIGN.md
├── SKILL.md
├── README.md
├── docs/
│   ├── SKILL.md
│   ├── components/
│   │   ├── COMPONENTS.md
│   │   └── SKILL.md
│   ├── UI/
│   │   └── SKILL.md
│   └── translate/
│       ├── SKILL.md
│       └── TRANSLATE.md
├── payhub.xcodeproj/
│   └── project.xcworkspace/
│       └── xcshareddata/
│           └── swiftpm/
│               └── Package.resolved
├── payhub/
│   ├── App/
│   │   └── payhubApp.swift
│   ├── Assets.xcassets/
│   │   ├── AppIcon.appiconset/
│   │   └── PayhubLogo.imageset/
│   ├── Models/
│   │   ├── Expense.swift
│   │   ├── Member.swift
│   │   └── Settlement.swift
│   ├── Services/
│   │   ├── CurrencyFormatterService.swift
│   │   └── SplitCalculator.swift
│   ├── SKILL.md
│   ├── ViewModels/
│   │   └── GroupSplitViewModel.swift
│   └── Views/
│       ├── Groups/
│       │   ├── ContentView.swift
│       │   ├── GroupSplitView.swift
│       │   ├── PayhubLaunchView.swift
│       │   └── Sections/
│       │       ├── BalancesSection.swift
│       │       ├── ExpenseFormSection.swift
│       │       ├── ExpensesSection.swift
│       │       ├── MembersSection.swift
│       │       ├── OverviewSection.swift
│       │       └── SettlementsSection.swift
│       └── Shared/
│           ├── EmptyStateRow.swift
│           └── PayhubColor.swift
├── payhubTests/
│   ├── Services/
│   │   ├── CurrencyFormatterServiceTests.swift
│   │   └── SplitCalculatorTests.swift
│   ├── ViewModels/
│   │   └── GroupSplitViewModelTests.swift
│   └── SKILL.md
└── payhubUITests/
    ├── SKILL.md
    ├── payhubUITests.swift
    └── payhubUITestsLaunchTests.swift
```

Planned structure as the app grows:

```text
payhub/
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

Local skill files:

- Root `SKILL.md`: repository-wide structure, Git, PR, commit, clean code, and path conventions.
- `docs/SKILL.md`: documentation and instruction-file conventions.
- `docs/components/SKILL.md`: component documentation and UI component instruction conventions.
- `docs/UI/SKILL.md`: UI convention, design token, and color usage instructions.
- `docs/translate/SKILL.md`: translation and localization instruction conventions.
- `payhub/SKILL.md`: main app target conventions for SwiftUI, models, view models, services, resources, and app structure.
- `payhubTests/SKILL.md`: unit test conventions for domain logic and service behavior.
- `payhubUITests/SKILL.md`: UI test conventions for launch, user flows, accessibility identifiers, and screenshots.

## Skill Routing

Use the smallest relevant skill context for each task:

- Always start with the root `SKILL.md` for repository-wide rules.
- Then read only the local `SKILL.md` files for folders touched by the task.
- Treat local skill files as the source of truth for their area; do not rely on the root skill for area-specific details.
- If a change affects multiple areas, read each affected local skill before editing that area.
- If a task changes an area's structure, workflow, or recurring convention, update that area's local `SKILL.md` in the same PR.
- If a local change also affects repository-wide workflow, structure, language, validation, or Git behavior, update the root `SKILL.md` too.
- Keep the root `SKILL.md` focused on routing and cross-repository rules so future tasks spend less context on irrelevant details.
- Do not duplicate detailed local rules in the root skill unless they apply across the whole repository.

Routing map:

```text
docs/**                  -> docs/SKILL.md
docs/components/**       -> docs/components/SKILL.md
docs/UI/**               -> docs/UI/SKILL.md
docs/translate/**        -> docs/translate/SKILL.md
payhub/**                -> payhub/SKILL.md
payhubTests/**           -> payhubTests/SKILL.md
payhubUITests/**         -> payhubUITests/SKILL.md
README.md                -> root SKILL.md, then docs/SKILL.md when development documentation changes
payhub.xcodeproj/**      -> root SKILL.md, then payhub/SKILL.md when app target behavior changes
```

Folder responsibilities:

- `App`: app entry point, app-level dependency setup, root scene wiring.
- `Models`: plain Swift data types and domain entities.
- `Views`: SwiftUI screens and reusable components, grouped by feature.
- `ViewModels`: screen state, user actions, validation, and coordination between views and services.
- `Services`: reusable business logic, persistence, formatting, import/export, and system integrations.
- `Utilities`: small generic helpers and extensions that are not specific to one feature.
- `brand`: source brand files used to generate app icons and image assets; keep runtime app assets in `payhub/Assets.xcassets`.
- `Resources`: localization, static data, and non-asset resource files.
- `Assets.xcassets`: compiled colors, icons, images, and app icon assets used by the app at runtime.

Structure change rule:

- If a task adds, removes, renames, or moves a folder in the main app structure, propose an update to this `SKILL.md`.
- If a task introduces a new architectural layer, shared service, resource convention, or feature grouping that affects where future files should live, propose an update to this `SKILL.md`.
- If a task only edits implementation inside the existing structure, no structure update is required unless the change reveals that the current convention is misleading.
- When proposing a structure update, include it in the same PR as the structural change unless the user asks to split documentation separately.

## Continuous Learning Rule

Capture useful lessons directly in the appropriate skill file:

- If a task reveals a better workflow, convention, project rule, recurring mistake, or useful reminder, propose updating the relevant `SKILL.md`.
- Use the root `SKILL.md` for repository-wide lessons that affect Git workflow, PRs, language, structure, validation, or cross-folder behavior.
- Use a local `SKILL.md` for lessons that only affect one area, such as the app target, unit tests, UI tests, component docs, or translation docs.
- If a lesson affects both a local area and the wider repository, update both the local `SKILL.md` and the root `SKILL.md`.
- Include skill updates in the same PR as the work that taught the lesson unless the user asks to split documentation separately.
- Keep skill updates concise, actionable, and written as rules future agents can follow.

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

## Development Tooling

- Hot reload is a Debug-only developer workflow for SwiftUI iteration.
- Use the `Inject` Swift package together with the InjectionIII macOS app.
- Keep hot reload instrumentation out of business logic, services, models, and tests.
- Add `@ObserveInjection` and `.enableInjection()` only to SwiftUI views that benefit from live UI refresh.
- Keep `-Xlinker -interposable` limited to Debug builds.
- Do not depend on hot reload for correctness; still run normal builds and tests before PRs.

## Path And Import Hygiene

Keep paths simple and stable:

- Prefer clear absolute or project-root-relative paths in documentation, scripts, and generated instructions.
- Avoid long chains like `../../../..` when a cleaner option exists.
- If repeated path traversal appears, introduce a named base path, helper, build setting, or small utility instead.
- Do not hard-code machine-specific paths inside app code.
- In docs, use paths from the repository root, for example `payhub/ContentView.swift`.
- In Swift code, prefer platform APIs such as `Bundle`, `FileManager`, asset catalogs, and typed resources instead of hand-built fragile paths.
- Keep imports minimal; remove unused imports when touching a file.
- Do not add global path helpers unless they remove real repetition or confusion.

## Git Workflow

Every task must be done on its own branch and completed through a pull request. Never push task changes directly to `main`.

Rules:

- `main` is protected and must only receive changes through merged pull requests.
- Do not commit task work directly on `main`.
- Do not push directly to `main` unless the user explicitly asks for an emergency repository repair.
- Start each task from the latest `main`.
- Open a PR for every task, even documentation-only work.
- Merge PRs before starting dependent work when possible.
- Delete local and remote task branches after their PRs are merged.

Generated file hygiene:

- Keep generated build outputs, user-specific IDE state, simulator artifacts, and local environment files out of Git.
- Prefer updating the repository `.gitignore` when repeated generated files appear in `git status`.
- Do not manually delete generated files over and over if they should be ignored.
- Do not ignore source files, shared project configuration, assets, fixtures, or documentation needed by other developers.
- If a generated file is already tracked, remove it from Git tracking in the same PR that adds the ignore rule.

Xcode project file hygiene:

- Treat `payhub.xcodeproj/project.pbxproj` as tracked source configuration, not a generated file to ignore or move.
- Commit `project.pbxproj` only when the task intentionally changes Xcode configuration, such as targets, build settings, packages, resources, signing, or asset catalog wiring.
- If `project.pbxproj` only changes because Xcode reordered sections, normalized whitespace, or rewrote equivalent content during open/build, restore that no-op diff before committing.
- Always inspect `git diff -- payhub.xcodeproj/project.pbxproj` before staging it.
- Do not add `payhub.xcodeproj/project.pbxproj` to `.gitignore`; `.gitignore` does not suppress changes to tracked files and ignoring this file would break shared project configuration.

Branch naming:

```text
feature/short-task-name
fix/short-bug-name
docs/short-doc-name
refactor/short-refactor-name
test/short-test-name
chore/short-maintenance-name
ci/short-ci-name
build/short-build-name
```

Examples:

```text
feature/add-expense-form
fix/rounding-split-total
docs/update-launch-process
refactor/extract-split-service
test/add-split-calculator-tests
chore/update-xcode-settings
ci/add-pr-checks
build/add-inject-package
```

Before starting a task:

```sh
git status --short --branch
git switch main
git pull --ff-only
git switch -c feature/short-task-name
```

If there is no remote yet, skip `git pull --ff-only` until `origin` is configured.

Before opening a PR, verify that the task branch name still matches the naming patterns above. If the branch name is wrong, rename it before pushing or opening the PR.

## Multi-PR Workflow

When several branches or PRs are created in one work session, keep the flow simple and predictable.

Prefer independent PRs into `main`:

- Split work into independent branches only when each branch can be reviewed and merged on its own.
- Base each independent branch on the latest `main`.
- Open each independent PR against `main`.
- Merge independent PRs one at a time after review.

Use stacked PRs only when a later task truly depends on an earlier unmerged task:

- Make the dependency explicit in the PR body.
- Base the dependent PR on the branch it depends on.
- Merge from the bottom of the stack upward: base PR first, dependent PR after.
- After a base PR merges into `main`, immediately rebase or retarget dependent PRs onto the latest `main`.
- Do not merge a dependent PR into an already-merged feature branch. Retarget it to `main` instead.
- Do not delete a base branch until dependent PRs are retargeted or merged.
- If branch history becomes confusing, pause and clean it before continuing.

Recommended order for one session:

1. Create branch from latest `main`.
2. Implement one task.
3. Commit using the commit convention.
4. Push the branch.
5. Open a PR.
6. Merge the PR before starting dependent work when practical.
7. Pull latest `main`.
8. Delete merged local and remote branches.
9. Start the next task from updated `main`.

If many PRs are needed in one session, prefer this safer rhythm:

```text
task branch -> PR -> merge -> pull main -> next task branch
```

Use this only when work must be parallelized:

```text
base branch -> base PR
dependent branch from base branch -> dependent PR
merge base PR -> retarget dependent PR to main -> merge dependent PR
```

## Commit Convention

Commit messages must follow:

```text
type(scope): message
```

The `scope` is optional but preferred when it makes the affected area clear.

Use this shorter form when no clear scope is needed:

```text
type: message
```

Allowed types:

- `feat`: new feature or user-facing capability.
- `fix`: bug fix.
- `docs`: documentation-only change.
- `style`: formatting or visual polish without behavior changes.
- `refactor`: code restructuring without changing behavior.
- `test`: adding or updating tests.
- `chore`: maintenance, project settings, dependency or tooling changes.
- `ci`: continuous integration workflows and checks.
- `build`: build system, Xcode project settings, dependency, packaging, or release build changes.
- `perf`: performance improvement without changing behavior.
- `revert`: revert a previous commit.

Examples:

```text
feat(expenses): add participant picker
fix(split): handle rounding remainder
docs(skill): add routing convention
style(summary): polish balance color
refactor(groups): extract split screen sections
test(split): add even split coverage
chore(git): update ignore rules
ci(actions): add pr checks
build(xcode): add inject package
perf(split): reduce settlement passes
revert: revert hot reload package
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

- Added ...
- Updated ...
- Fixed ...
- Tested ...
```

Rules:

- Keep `Summary` concise and user-facing.
- Use `Details` for concrete implementation notes.
- Include testing notes in `Details`.
- Mention any known limitation or follow-up if the task is intentionally incomplete.
- Do not merge a PR if the app does not build or relevant tests fail, unless the PR explicitly documents why.

Merge method:

- Use a normal merge commit when merging PRs into `main`.
- Do not use squash merge or rebase merge by default.
- Keep the PR branch visible in the Git graph so each task branch and merge point remains traceable.
- Only use squash merge or rebase merge if the user explicitly asks for that specific merge method.

## Pre-PR Checklist

Before opening a PR:

- Re-read the root `SKILL.md` and every local `SKILL.md` for touched folders.
- Confirm the current branch follows the branch naming convention.
- Confirm documentation is clear, concise, professional, and emoji-free.
- Confirm commits, PR title, and PR body follow this file.

Run these before opening a PR when Xcode is configured:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
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
