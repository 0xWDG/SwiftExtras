# SwiftExtras

SwiftExtras is a Swift Package containing Extensions and Helpers for Swift which I use on a regular basis, or find useful.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FSwiftExtras%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xWDG/SwiftExtras)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FSwiftExtras%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xWDG/SwiftExtras)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
![License](https://img.shields.io/github/license/0xWDG/SwiftExtras)

## Requirements

- Swift 5.9+ (Xcode 15+)
- iOS 16+, macOS 13+, tvOS 16+, watchOS 9+

## Installation (Pakage.swift)

```swift
dependencies: [
    .package(url: "https://github.com/0xWDG/SwiftExtras.git", branch: "main"),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "SwiftExtras", package: "SwiftExtras"),
    ]),
]
```

## Installation (Xcode)

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/0xWDG/SwiftExtras`) and click **Next**.
3. Click **Finish**.

## Update Screenshots

Generate the macOS-rendered DocC assets from the repository root:

```shell
swift run SwiftExtrasScreenshots
```

To render with UIKit, boot an iOS Simulator, build the generator for the
simulator, and run the resulting executable:

```shell
xcodebuild build \
  -scheme SwiftExtrasScreenshots \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath .build/SwiftExtrasScreenshots-iOS \
  CODE_SIGNING_ALLOWED=NO

xcrun simctl spawn booted \
  "$PWD/.build/SwiftExtrasScreenshots-iOS/Build/Products/Debug-iphonesimulator/SwiftExtrasScreenshots"
```

The generator prints its output directory when it finishes. On iOS, screenshots
are saved under `Documents/SwiftExtrasScreenshots` with an `-ios` filename suffix
so they can coexist with the desktop assets. Set
`SWIFT_EXTRAS_SCREENSHOT_OUTPUT` to override the destination with a writable
path.

To capture localized screenshots of an app that uses SwiftExtras, add the
`SwiftExtrasScreenshotTesting` product to the app's UI-test target and subclass
`ScreenshotTestCase`. See the [screenshot testing guide](Sources/SwiftExtrasScreenshotTesting/SwiftExtrasScreenshotTesting.docc/SwiftExtrasScreenshotTesting.md)
for a complete light/dark, multi-language example.

## Test All Platforms

Run the reusable platform test script from the repository root:

```shell
Scripts/test-all-platforms.sh
```

On macOS, the script runs the test suite locally, builds the package for every
supported Apple platform whose SDK is installed in the selected Xcode, and
runs the Linux suite using
[Apple container](https://github.com/apple/container). Start the service with
`container system start` before running the script. Set `SKIP_LINUX=1` to omit
the containerized Linux tests, or set `SWIFT_CONTAINER_IMAGE` to select another
Swift image. Missing Apple platform SDKs are reported as skipped rather than as
build failures. Apple platform builds are also skipped when `CI=true`; macOS
and Linux tests continue to run in CI. On Linux, the script runs `swift test`
directly.

## Custom Views (+ Screenshots)

The screenshot assets are shared with the DocC catalog and can be refreshed with the command above.

| View | iOS Screenshot |
| --- | --- |
| CardView | ![CardView on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/card-view-ios.png) |
| CarouselView | ![CarouselView on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/carousel-view-ios.png) |
| ConfirmationButton | ![ConfirmationButton on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/confirmation-button-ios.png) |
| DisclosureSection | ![DisclosureSection on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/disclosure-section-ios.png) |
| HorizontalStepper | ![HorizontalStepper on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/horizontal-stepper-ios.png) |
| IndexedList | ![IndexedList on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/indexed-list-ios.png) |
| LabeledTextField | ![LabeledTextField on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/labeled-text-field-ios.png) |
| LimitedTextField | ![LimitedTextField on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/limited-text-field-ios.png) |
| MonthYearPickerView | ![MonthYearPickerView on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/month-year-picker-view-ios.png) |
| MultiSelectPickerView | ![MultiSelectPickerView on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/multi-select-picker-view-ios.png) |
| MultiSelectView | ![MultiSelectView on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/multi-select-view-ios.png) |
| NotificationView | ![NotificationView on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/notification-view-ios.png) |
| SEAcknowledgementView | ![SEAcknowledgementView on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/se-acknowledgement-view-ios.png) |
| SEChangeLogView | ![SEChangeLogView on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/se-changelog-view-ios.png) |
| SplitActionButton | ![SplitActionButton on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/split-action-button-ios.png) |
| WStack | ![WStack on iOS](Sources/SwiftExtras/SwiftExtras.docc/Resources/wstack-ios.png) |


## Contact

🦋 [@0xWDG](https://bsky.app/profile/0xWDG.bsky.social)
🐘 [mastodon.social/@0xWDG](https://mastodon.social/@0xWDG)
🐦 [@0xWDG](https://x.com/0xWDG)
🧵 [@0xWDG](https://www.threads.net/@0xWDG)
🌐 [wesleydegroot.nl](https://wesleydegroot.nl)
🤖 [Discord](https://discordapp.com/users/918438083861573692)

Interested learning more about Swift? [Check out my blog](https://wesleydegroot.nl/blog/).
