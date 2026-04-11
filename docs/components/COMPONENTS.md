# Component Instructions

Use this document when building or reviewing reusable UI components for payhub.

## Component Standard

Reusable components should be:

- Small and focused.
- Easy to preview.
- Accessible by default.
- Independent from business logic.
- Named by what they represent, not by how they look.

## SwiftUI Component Pattern

Prefer this shape:

```swift
struct ComponentName: View {
    let title: String

    var body: some View {
        Text(title)
    }
}
```

Use `@Binding` only when the component truly edits parent state. Use callbacks for simple user actions.

## Placement

- Feature-specific components live near their feature folder, for example `payhub/Views/Expenses/`.
- Shared components live in `payhub/Views/Shared/`.
- Do not move a component into `Shared` until at least two features need it or reuse is clearly imminent.

## Accessibility

- Add accessibility labels for non-text controls.
- Add stable accessibility identifiers for controls used by UI tests.
- Keep identifiers semantic, for example `expenseForm.amountField`.

## Review Checklist

- The component has one clear responsibility.
- It does not contain bill-splitting business logic.
- Dynamic text fits on small screens.
- State changes do not cause layout jumps.
- Preview data is simple and deterministic.

