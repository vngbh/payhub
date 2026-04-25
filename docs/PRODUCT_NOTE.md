# Product Note

## Direction

payhub should support many separate chapters, not just one ongoing shared split.

Each chapter contains:
- members
- bills
- balances
- calculate suggestions

Because of that, the current split screen should not be the first screen of the app.

## Structure

The app should have two levels:

1. Chapters list
2. Chapter details

A chapter contains:
- Members
- Bills
- Balances
- Calculate

## Naming

Use friendly and easy-to-understand product language.

Preferred terms:
- `Chapter` for the top-level container
- `Bills` instead of `Expenses`
- `Calculate` instead of `Settle Up`

Reasoning:
- `Chapter` gives each outing its own identity
- `Bills` feels more familiar in everyday use
- `Calculate` feels more direct and action-oriented

## First Screen

The first screen should be the chapters screen.

Main actions:
- show all chapters
- create a new chapter
- open an existing chapter

Suggested labels:
- `Your Chapters`
- `Create Chapter`
- `No chapters yet`

## Chapter Screen

When opening a chapter, show the chapter detail screen.

This screen contains:
- Members
- Bills
- Balances
- Calculate

## UX Notes

The product should feel personal, light, and easy to scan.

Desired tone:
- warm
- simple
- story-like
- not overly financial or technical

## Open Questions

Still to decide:
- what information should appear on each chapter card in the chapters list
- whether bill creation should stay in a dialog or move to a dedicated screen
- whether bill editing should remain inline or move to a dedicated bill details flow
