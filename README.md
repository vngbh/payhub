# payhub

payhub is an iOS app for splitting shared expenses after meals, hangouts, short trips, or any group activity. The product goal is to make it fast to record who paid, who participated, and who should transfer money to whom with the fewest settlement transactions possible.

## Current Status

- Platform: iOS / iPadOS
- UI framework: SwiftUI
- Project: Xcode project (`payhub.xcodeproj`)
- App target: `payhub`
- Unit test target: `payhubTests`
- UI test target: `payhubUITests`
- Bundle ID: `com.vngbh.payhub`
- Current version: `1.0` build `1`
- Current iOS deployment target: `26.2`

## Environment Requirements

- macOS with the full Xcode app installed, not only Command Line Tools.
- An Xcode version that supports the project's iOS deployment target.
- iOS Simulator installed through Xcode.
- An Apple Developer account if you want to build for a real device, TestFlight, or App Store release.

Check the active toolchain:

```sh
xcode-select -p
xcodebuild -version
```

If `xcodebuild` reports an error like `tool 'xcodebuild' requires Xcode, but active developer directory ... is a command line tools instance`, switch the active developer directory to Xcode:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

Then verify again:

```sh
xcodebuild -version
```

## Open The Project

Open the project in Xcode:

```sh
open payhub.xcodeproj
```

In Xcode:

1. Select the `payhub` scheme.
2. Select an available simulator, for example `iPhone 17`.
3. Press `Cmd + R` to build and run the app.
4. Press `Cmd + U` to run tests.

## Common Commands

List schemes, targets, and configurations:

```sh
xcodebuild -list -project payhub.xcodeproj
```

List available simulators:

```sh
xcrun simctl list devices available
```

Open Simulator:

```sh
open -a Simulator
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

Run unit tests and UI tests on a simulator:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

If `iPhone 17` is not available on your machine, replace it with a simulator name from:

```sh
xcrun simctl list devices available
```

Remove project-specific DerivedData when a build cache issue appears:

```sh
rm -rf ~/Library/Developer/Xcode/DerivedData/payhub-*
```

## Run On Simulator From Command Line

The simplest path is Xcode with `Cmd + R`. For automation, build the app and install it into a booted simulator.

Boot a simulator:

```sh
xcrun simctl boot 'iPhone 17'
open -a Simulator
```

Build the app into a dedicated derived data folder:

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

Or install it from the Mac App Store, then open InjectionIII from `/Applications`.

Use hot reload:

1. Open InjectionIII and select the repository folder when prompted.
2. Open the project in Xcode:

```sh
open payhub.xcodeproj
```

3. Select the `payhub` scheme and run the app on a simulator with `Cmd + R`.
4. Edit a SwiftUI view that is instrumented with `@ObserveInjection` and `.enableInjection()`.
5. Save the file. InjectionIII recompiles and injects the changed implementation into the running Debug app.

Hot reload is for fast UI iteration only. Run a normal build and relevant tests before opening a PR.

## Development Workflow

Each development loop should stay small:

1. Pick one focused task, such as `add expense form`, `calculate balances`, or `store members locally`.
2. Update the code.
3. Build on a simulator.
4. Run relevant tests.
5. Manually test the main flow on a simulator.
6. Commit when the app builds and the behavior is stable.

Run this before opening a PR when Xcode is configured:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

Suggested commit flow:

```sh
git status
git add .
git commit -m "feat/add-expense-form"
```

## Architecture Direction

As the app grows, keep code organized around these areas:

- `Models`: core data such as group, member, expense, and settlement result.
- `Views`: SwiftUI screens and components.
- `ViewModels`: screen state and action coordination.
- `Services`: split calculation, persistence, formatting, import, and export.
- `Tests`: coverage for domain logic and important user flows.

Bill-splitting logic should live in plain Swift models or services so it can be unit tested. Avoid spreading calculation rules across SwiftUI views.

## MVP Checklist

- Create a group.
- Add members.
- Add an expense with title, amount, payer, and participants.
- Calculate how much each person paid.
- Calculate how much each person should owe.
- Suggest the minimum settlement transactions.
- Edit or delete expenses.
- Save data locally.
- Share the settlement summary.

## Test Coverage

Prioritize unit tests for:

- All members splitting one expense evenly.
- One person paying multiple expenses for the group.
- One expense involving only some members.
- Decimal amounts and rounding behavior.
- Total money received matching total money owed.
- No settlement transactions when everyone is already balanced.

Prioritize UI tests for:

- App launches successfully.
- A new group can be created.
- A new expense can be added.
- The settlement result can be viewed.

## Build Release

Build Release for simulator to catch compile issues:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Release \
  -destination 'generic/platform=iOS Simulator' \
  build
```

Archive for TestFlight or App Store upload:

```sh
xcodebuild \
  -project payhub.xcodeproj \
  -scheme payhub \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath build/payhub.xcarchive \
  archive
```

Exporting an archive requires an `ExportOptions.plist` that matches the distribution method, such as `development`, `ad-hoc`, `app-store-connect`, or `enterprise`. This project does not have that file yet; create it when TestFlight or App Store distribution begins.

```sh
xcodebuild \
  -exportArchive \
  -archivePath build/payhub.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist
```

## Pre-TestFlight Checklist

- Update `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION`.
- Make sure the bundle ID matches the Apple Developer portal.
- Configure the signing team in Xcode.
- Add complete app icons.
- Check the launch screen.
- Run unit tests and UI tests.
- Test on at least one iPhone simulator and one iPad simulator if iPad remains supported.
- Test on a real device when available.
- Write build notes that include new features, known issues, and flows to test.

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

Check Git before committing:

```sh
git status --short
git diff
```
