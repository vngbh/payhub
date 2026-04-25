---
name: payhub-ui-test-conventions
description: Use this skill when changing files inside payhubUITests, especially UI tests for launch, main user flows, accessibility identifiers, screenshots, and simulator behavior.
---

# payhub UI Test Conventions

This file applies to `payhubUITests/`. Follow the root `SKILL.md` first, then these UI-test-specific rules.

## Standard Structure

UI tests should grow toward this structure:

```text
payhubUITests/
├── SKILL.md
├── Flows/
├── Screens/
├── Fixtures/
├── payhubUITests.swift
└── payhubUITestsLaunchTests.swift
```

Use folders only when repeated flows or screen objects become useful.

## Test Focus

Prioritize UI tests for:

- App launches successfully.
- Creating a group.
- Adding members.
- Adding a bill.
- Viewing the calculation summary.
- Sharing or exporting the result when that feature exists.

## UI Test Style

- Keep UI tests focused on user-visible flows.
- Prefer stable accessibility identifiers over text matching for controls that may be localized or edited.
- Keep launch state explicit.
- Do not make UI tests depend on previous tests.
- Keep screenshot attachments meaningful and named.
- Use screen helpers only when they reduce repeated UI code.

## Structure Change Rule

- Propose an update to this file when UI test folders, screen helpers, flow helpers, or launch conventions change.
- Propose an update to `payhub/SKILL.md` when UI tests require new accessibility identifiers or app-side testability hooks.
- Propose an update to the root `SKILL.md` if UI testing changes affect repository-wide workflow.

## Path Rules

- Reference app and test files from the repository root in docs.
- Avoid deep relative path traversal for fixtures.
- Prefer simulator state setup through supported XCUITest or `simctl` workflows instead of fragile file paths.

