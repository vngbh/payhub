---
name: divpay-docs-conventions
description: Use this skill when creating or updating instruction documents under docs, including component guides, translation guides, design notes, and AI working instructions.
---

# Divpay Docs Conventions

This folder stores project instructions that help humans and AI agents work consistently.

## Structure

```text
docs/
├── SKILL.md
├── components/
│   ├── COMPONENTS.md
│   └── SKILL.md
└── translate/
    ├── SKILL.md
    └── TRANSLATE.md
```

## Rules

- Keep docs practical and command-oriented.
- Prefer short examples over long explanations.
- Use project-root-relative paths.
- Update the relevant local `SKILL.md` when adding a new docs subfolder or changing how instructions should be used.
- Keep root `SKILL.md` updated when docs structure changes.
- Do not duplicate the same rule in many docs unless local context changes how it should be applied.

## Naming

- Use uppercase names for primary instruction files, for example `COMPONENTS.md`.
- Use `SKILL.md` for local AI working rules inside each folder.
- Use clear domain folders such as `components`, `translate`, `design`, `release`, or `qa` when new instruction areas appear.

