---
name: payhub-unit-test-conventions
description: Use this skill when changing files inside payhubTests, especially unit tests for bill splitting, models, services, rounding, persistence, and formatting logic.
---

# payhub Unit Test Conventions

This file applies to `payhubTests/`. Follow the root `SKILL.md` first, then these unit-test-specific rules.

## Standard Structure

Unit tests should grow toward this structure:

```text
payhubTests/
├── SKILL.md
├── Models/
├── Services/
├── ViewModels/
├── Fixtures/
└── payhubTests.swift
```

Use folders only when there are enough tests to justify them. Keep the early project simple.

Current structure:

```text
payhubTests/
├── Services/
│   └── SplitCalculatorTests.swift
└── SKILL.md
```

## Test Focus

Prioritize tests for:

- Even split across all members.
- Split where only some members participate.
- Multiple expenses paid by different people.
- Rounding and decimal edge cases.
- Settlement minimization: who pays whom and how much.
- Persistence behavior when storage is introduced.
- View model validation and state transitions.

## Test Style

- Use clear test names that describe behavior.
- Prefer Arrange, Act, Assert structure.
- Keep tests deterministic and independent.
- Avoid relying on test execution order.
- Use small fixtures when repeated setup becomes noisy.
- Do not test SwiftUI rendering here; keep that in UI tests or view previews.

## Structure Change Rule

- Propose an update to this file when unit test folders, fixtures, or test conventions change.
- Propose an update to the root `SKILL.md` if the test structure affects repository-wide conventions.
- When app logic moves into new service or model folders, mirror that organization here when it improves readability.

## Path Rules

- Reference app files from the repository root in docs, for example `payhub/Services/SplitCalculator.swift`.
- Avoid long relative paths in fixtures or helpers.
- Prefer in-memory fixtures over external files unless file-based behavior is being tested.
