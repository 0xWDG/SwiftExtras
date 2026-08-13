# ``SwiftExtrasScreenshotTesting``

Capture localized light and dark appearance screenshots from an Xcode UI-test target.

## Overview

Add the `SwiftExtrasScreenshotTesting` product to your app's UI-test target. Then
subclass ``ScreenshotTestCase`` and describe the languages and application states
you want to capture:

```swift
import SwiftExtrasScreenshotTesting

final class AppScreenshotTests: ScreenshotTestCase {
    override var languages: [ScreenshotLanguage] {
        [
            .init(identifier: "en", localeIdentifier: "en_US"),
            .init(identifier: "nl", localeIdentifier: "nl_NL")
        ]
    }

    override var scenarios: [ScreenshotScenario] {
        [
            .init(name: "overview", launchArguments: ["-ScreenshotScenario", "overview"]),
            .init(
                name: "details-dark",
                appearance: .dark,
                launchArguments: ["-ScreenshotScenario", "details"]
            )
        ]
    }

    override func prepareForScreenshot(
        _ application: XCUIApplication,
        language: ScreenshotLanguage,
        scenario: ScreenshotScenario
    ) throws {
        XCTAssertTrue(application.otherElements["screenshot-ready"].waitForExistence(timeout: 10))
    }
}
```

The inherited test method launches the app for each combination, preserves each
capture as an XCTest attachment, and writes PNG files to `~/screenshots` when the
test runs in Simulator. Native macOS tests retain attachments because sandboxing
typically prevents writing to that location; override ``ScreenshotTestCase/screenshotsDirectory``
to select another writable directory.

Use accessible identifiers for readiness checks and navigation so the screenshot
workflow remains reliable and usable with assistive UI-testing tools.

## Topics

### Test Case

- ``ScreenshotTestCase``

### Configuration

- ``ScreenshotLanguage``
- ``ScreenshotScenario``
- ``ScreenshotAppearance``
