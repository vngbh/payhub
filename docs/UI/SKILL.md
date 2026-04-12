---
name: payhub-ui-conventions
description: Use this skill when creating or updating UI conventions, design tokens, colors, spacing, typography, or SwiftUI presentation guidance for payhub.
---

# payhub UI Conventions

Use this file for UI rules that should stay consistent across the app. Follow the root `SKILL.md`, `docs/SKILL.md`, and `payhub/SKILL.md` before editing app UI.

## Color Tokens

- Define reusable app colors in `payhub/Views/Shared/PayhubColor.swift`.
- Use named color tokens in SwiftUI views instead of direct color values such as `.red`, `.green`, `.secondary`, `.black`, `.white`, or `Color(...)`.
- Name tokens by semantic purpose, not by raw color. Prefer names like `balancePositive`, `balanceNegative`, or `textSecondary`.
- Add a new token before introducing a new recurring visual meaning.
- Keep one-off system roles such as `Button(role: .destructive)` only when the role expresses behavior and accessibility, not custom styling.
- Do not hard-code hex values in views. If a custom color is needed, add it to `Assets.xcassets` and expose it through `PayhubColor`.

## SwiftUI Usage

Use tokens directly in view modifiers:

```swift
Text("Paid")
    .foregroundStyle(PayhubColor.textSecondary)
```

Use state-specific tokens instead of raw colors:

```swift
Text(amount)
    .foregroundStyle(isPositive ? PayhubColor.balancePositive : PayhubColor.balanceNegative)
```

## Maintenance

- Search for direct color usage with `rg -n "\\.secondary|\\.primary|\\.green|\\.red|\\.blue|\\.orange|\\.yellow|\\.pink|\\.purple|\\.gray|\\.black|\\.white|Color\\(" payhub --glob '*.swift'`.
- When adding a new UI convention folder or design-token file, update this skill and the relevant structure lists.
