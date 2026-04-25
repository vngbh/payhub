# payhub

payhub is an iOS app for splitting shared bills after meals, hangouts, trips, and other group activities. It helps record who paid, who participated, and which settlement transfers are needed.

## Project Status

- Platform: iOS and iPadOS
- UI framework: SwiftUI
- Project file: `payhub.xcodeproj`
- App target: `payhub`
- Unit test target: `payhubTests`
- UI test target: `payhubUITests`
- Bundle ID: `com.vngbh.payhub`
- Version: `1.0` build `1`
- iOS deployment target: `18.0`

## Requirements

- macOS with the full Xcode app installed.
- An Xcode version that supports the configured iOS deployment target.
- iOS Simulator installed through Xcode.
- Apple Developer account for real-device, TestFlight, or App Store builds.

Check the active developer tools:

```sh
xcode-select -p
xcodebuild -version
```

If `xcodebuild` points to Command Line Tools instead of Xcode, switch to Xcode:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

## Open The Project

Open the Xcode project:

```sh
open payhub.xcodeproj
```

In Xcode:

1. Select the `payhub` scheme.
2. Select an available iOS simulator.
3. Press `Cmd + R` to build and run.
4. Press `Cmd + U` to run tests.

## Common Commands

List project schemes, targets, and configurations:

```sh
xcodebuild -list -project payhub.xcodeproj
```

List available simulators:

```sh
xcrun simctl list devices available
```

Build Debug for iOS Simulator:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  build
```

Run tests on a simulator:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

If `iPhone 17` is unavailable, choose a simulator from:

```sh
xcrun simctl list devices available
```

Remove project-specific DerivedData when build cache issues appear:

```sh
rm -rf ~/Library/Developer/Xcode/DerivedData/payhub-*
```

## Run From Command Line

Boot a simulator:

```sh
xcrun simctl boot 'iPhone 17'
open -a Simulator
```

Build into a dedicated derived data folder:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -derivedDataPath build/DerivedData \
  build
```

Install and launch the app:

```sh
xcrun simctl install booted build/DerivedData/Build/Products/Debug-iphonesimulator/payhub.app
xcrun simctl launch booted com.vngbh.payhub
```

## Hot Reload

payhub supports SwiftUI hot reload in Debug builds through the `Inject` Swift package and the InjectionIII macOS app.

Install InjectionIII:

```sh
brew install --cask injectioniii
```

Use hot reload:

1. Open InjectionIII and select the repository folder.
2. Open `payhub.xcodeproj` in Xcode.
3. Run the `payhub` scheme on a simulator.
4. Edit a SwiftUI view that uses `@ObserveInjection` and `.enableInjection()`.
5. Save the file to inject the updated implementation into the running Debug app.

Hot reload is only for local UI iteration. Run a normal build and relevant tests before opening a PR.

## Development Workflow

Before starting any task, read the root `SKILL.md` and any local `SKILL.md` files for the folders you will touch. Follow those rules for documentation, code style, branch naming, commits, and pull requests.

Every task must be completed on its own branch. Do not commit task work directly on `main`.

Start from the latest `main`:

```sh
git status --short --branch
git switch main
git pull --ff-only
git switch -c docs/short-doc-name
```

Use the branch prefix that matches the task:

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

Keep each change focused:

1. Pick one task.
2. Read the relevant skill files.
3. Implement the change.
4. Build or test the affected area.
5. Check the diff.
6. Commit with the project commit convention.
7. Open a PR before merging to `main`.

Suggested commit format:

```text
type(scope): message
```

Example:

```sh
git add README.md SKILL.md
git commit -m "docs(readme): update project guide"
```

## Pull Requests

Before opening a PR:

1. Confirm the branch name follows `SKILL.md`.
2. Re-read the root `SKILL.md` and any local skill files for touched folders.
3. Confirm documentation is clear, concise, professional, and emoji-free.
4. Run relevant build or test commands.
5. Review the final diff.

Recommended test command when Xcode is configured:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

Review changes before committing:

```sh
git status --short --branch
git diff
```

PR title format:

```text
[Edited Place] Content Here
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

Use a normal merge commit when merging PRs into `main`, unless the user explicitly asks for another merge method.

## Architecture

Keep app code organized by responsibility:

- `App`: app entry point and root scene wiring.
- `Models`: plain Swift domain data.
- `Views`: SwiftUI screens and reusable components.
- `ViewModels`: screen state, user actions, and coordination.
- `Services`: calculation, persistence, formatting, import, export, and integrations.
- `Utilities`: small generic helpers and extensions.
- `Resources`: localization and static non-asset resources.
- `Assets.xcassets`: runtime colors, icons, images, and app icons.

Bill-splitting logic should live in models or services so it can be unit tested. Avoid placing business rules inside SwiftUI views.

## MVP Scope

- Create a group.
- Add members.
- Add a bill with title, amount, payer, and participants.
- Calculate how much each person paid.
- Calculate how much each person owes.
- Suggest the minimum settlement transactions.
- Edit or delete bills.
- Save data locally.
- Share the settlement summary.

## Testing Focus

Prioritize unit tests for:

- Even splits across all members.
- One person paying multiple bills.
- Bills involving only some members.
- Decimal amounts and rounding behavior.
- Total received matching total owed.
- No settlements when everyone is balanced.

Prioritize UI tests for:

- App launch.
- Group creation.
- Bill creation.
- Calculation result review.

## Release Build

Build Release for iOS Simulator:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Release \
  -destination 'generic/platform=iOS Simulator' \
  build
```

Archive for distribution:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath build/payhub.xcarchive \
  archive
```

Exporting an archive requires an `ExportOptions.plist` that matches the distribution method. Add it when TestFlight or App Store distribution begins.

```sh
xcodebuild \
  -exportArchive \
  -archivePath build/payhub.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist
```

## Pre-TestFlight Checklist

- Update `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION`.
- Confirm the bundle ID matches the Apple Developer portal.
- Configure the signing team in Xcode.
- Add complete app icons.
- Check the launch screen.
- Run unit tests and UI tests.
- Test on at least one iPhone simulator.
- Test on at least one iPad simulator if iPad remains supported.
- Test on a real device when available.
- Write build notes with new features, known issues, and flows to test.

## Troubleshooting

Check the selected Xcode developer directory:

```sh
xcode-select -p
```

Check available simulators:

```sh
xcrun simctl list devices available
```

Reset the booted simulator:

```sh
xcrun simctl shutdown booted
xcrun simctl erase booted
```

If `xcrun simctl erase booted` fails because no simulator is booted, boot a simulator first or erase a specific device ID from the simulator list.
