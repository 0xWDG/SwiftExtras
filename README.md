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

`swift run SwiftExtrasScreenshots`

## Custom Views (+ Screenshots)

The screenshot assets are shared with the DocC catalog and can be refreshed with the command above.

| View | Screenshot |
| --- | --- |
| CardView | ![CardView screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/card-view.png) |
| CarouselView | ![CarouselView screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/carousel-view.png) |
| ConfirmationButton | ![ConfirmationButton screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/confirmation-button.png) |
| DisclosureSection | ![DisclosureSection screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/disclosure-section.png) |
| HorizontalStepper | ![HorizontalStepper screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/horizontal-stepper.png) |
| IndexedList | ![IndexedList screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/indexed-list.png) |
| LabeledTextField | ![LabeledTextField screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/labeled-text-field.png) |
| LimitedTextField | ![LimitedTextField screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/limited-text-field.png) |
| MonthYearPickerView | ![MonthYearPickerView screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/month-year-picker-view.png) |
| MultiSelectPickerView | ![MultiSelectPickerView screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/multi-select-picker-view.png) |
| MultiSelectView | ![MultiSelectView screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/multi-select-view.png) |
| NotificationView | ![NotificationView screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/notification-view.png) |
| SEAcknowledgementView | ![SEAcknowledgementView screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/se-acknowledgement-view.png) |
| SEChangeLogView | ![SEChangeLogView screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/se-changelog-view.png) |
| SplitActionButton | ![SplitActionButton screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/split-action-button.png) |
| WStack | ![WStack screenshot](Sources/SwiftExtras/SwiftExtras.docc/Resources/wstack.png) |


## Contact

🦋 [@0xWDG](https://bsky.app/profile/0xWDG.bsky.social)
🐘 [mastodon.social/@0xWDG](https://mastodon.social/@0xWDG)
🐦 [@0xWDG](https://x.com/0xWDG)
🧵 [@0xWDG](https://www.threads.net/@0xWDG)
🌐 [wesleydegroot.nl](https://wesleydegroot.nl)
🤖 [Discord](https://discordapp.com/users/918438083861573692)

Interested learning more about Swift? [Check out my blog](https://wesleydegroot.nl/blog/).
