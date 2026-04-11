# Translation Instructions

Use this document when writing or translating user-facing copy for payhub.

## Supported Languages

English is the default language for the product, documentation, source comments, commit messages, branch names, PR titles, and PR descriptions.

Additional languages can be added later through explicit localization resources. Do not mix languages inside source files or general project documentation.

## Voice

- Clear.
- Friendly.
- Direct.
- Short enough for mobile UI.
- No overly formal banking language unless the screen truly needs it.

## Copy Rules

- Prefer action verbs on buttons.
- Avoid long sentences in alerts.
- Avoid technical words when a normal user word is clearer.
- Keep labels consistent across screens.
- Do not describe implementation details to users.

## Money And Numbers

- Use locale-aware currency formatting.
- Keep rounding rules consistent with the split calculation service.
- Avoid manually concatenating currency symbols and numbers.

## String Placement

- User-facing strings should move toward string catalogs or a localization resource as the app grows.
- Test identifiers must not depend on translated text.
- Do not use user-facing copy as the only UI test selector when an accessibility identifier is more stable.
