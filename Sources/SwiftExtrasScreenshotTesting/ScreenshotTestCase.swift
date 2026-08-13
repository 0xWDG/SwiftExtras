//
//  ScreenshotTestCase.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
import SwiftExtras
#if canImport(Darwin)
import XCTest
#endif

/// An appearance to apply before capturing a screenshot.
public enum ScreenshotAppearance: Sendable {
    /// The system's light appearance.
    case light

    /// The system's dark appearance.
    case dark

#if canImport(Darwin)
    fileprivate var deviceAppearance: XCUIDevice.Appearance {
        switch self {
        case .light: .light
        case .dark: .dark
        }
    }
#endif
}

/// A language and locale combination used to launch an application.
public struct ScreenshotLanguage: Equatable, Sendable {
    /// The language identifier passed through `AppleLanguages`.
    public let identifier: String

    /// The locale identifier passed through `AppleLocale`.
    public let localeIdentifier: String

    /// Creates a screenshot language configuration.
    ///
    /// - Parameters:
    ///   - identifier: A language identifier such as `"en"` or `"nl"`.
    ///   - localeIdentifier: A locale identifier such as `"en_US"`. When
    ///     omitted, `identifier` is used for both launch arguments.
    public init(identifier: String, localeIdentifier: String? = nil) {
        self.identifier = identifier
        self.localeIdentifier = localeIdentifier ?? identifier
    }
}

/// A named application state to capture.
public struct ScreenshotScenario: Equatable, Sendable {
    /// The scenario name included in the screenshot filename.
    public let name: String

    /// The appearance applied before launching the application.
    public let appearance: ScreenshotAppearance

    /// Additional arguments passed to the application at launch.
    public let launchArguments: [String]

    /// Creates a screenshot scenario.
    ///
    /// - Parameters:
    ///   - name: A stable name for the application state.
    ///   - appearance: The appearance used for the screenshot.
    ///   - launchArguments: Additional app-specific launch arguments.
    public init(
        name: String,
        appearance: ScreenshotAppearance = .light,
        launchArguments: [String] = []
    ) {
        self.name = name
        self.appearance = appearance
        self.launchArguments = launchArguments
    }
}

/// A reusable UI-test case for capturing localized application screenshots.
///
/// Subclass this type in an Xcode UI-test target and override ``languages`` and
/// ``scenarios``. The inherited ``testScreenshots()`` method launches the app
/// once for every language and scenario combination.
#if canImport(Darwin)
open class ScreenshotTestCase: XCTestCase {
    /// The languages to capture.
    open var languages: [ScreenshotLanguage] {
        [.init(identifier: "en")]
    }

    /// The application scenarios to capture.
    open var scenarios: [ScreenshotScenario] {
        [.init(name: "default")]
    }

    /// The directory to which PNG files are written.
    ///
    /// The default is `~/screenshots` for Simulator-hosted tests. Return `nil`
    /// to keep screenshots only as test-result attachments.
    open var screenshotsDirectory: URL? {
        guard let hostHome = ProcessInfo.processInfo.environment["SIMULATOR_HOST_HOME"] else {
            return nil
        }

        return URL(fileURLWithPath: hostHome, isDirectory: true)
            .appendingPathComponent("screenshots", isDirectory: true)
    }

    /// Configures an application after the standard language and scenario
    /// launch arguments have been added.
    open func configure(
        _ application: XCUIApplication,
        language: ScreenshotLanguage,
        scenario: ScreenshotScenario
    ) { }

    /// Prepares the launched application for capture.
    ///
    /// Override this hook to navigate, dismiss onboarding, or wait for a
    /// specific accessible element before taking the screenshot.
    open func prepareForScreenshot(
        _ application: XCUIApplication,
        language: ScreenshotLanguage,
        scenario: ScreenshotScenario
    ) throws { }

    /// Captures every configured language and scenario combination.
    public final func testScreenshots() throws {
        guard type(of: self) != ScreenshotTestCase.self else {
            throw XCTSkip("ScreenshotTestCase is a reusable base class.")
        }

        if let screenshotsDirectory {
            try FileManager.default.createDirectory(
                at: screenshotsDirectory,
                withIntermediateDirectories: true
            )
        }

        for language in languages {
            for (index, scenario) in scenarios.enumerated() {
                XCUIDevice.shared.appearance = scenario.appearance.deviceAppearance

                let application = XCUIApplication()
                application.launchArguments += [
                    "-AppleLanguages", "(\(language.identifier))",
                    "-AppleLocale", language.localeIdentifier
                ]
                application.launchArguments += scenario.launchArguments
                configure(application, language: language, scenario: scenario)
                application.launch()

                try prepareForScreenshot(
                    application,
                    language: language,
                    scenario: scenario
                )

                let screenshot = application.screenshot()
                let name = screenshotName(
                    language: language,
                    scenario: scenario,
                    index: index
                )
                let attachment = XCTAttachment(screenshot: screenshot)
                attachment.name = name
                attachment.lifetime = .keepAlways
                add(attachment)

                if let screenshotsDirectory,
                   let pngData = screenshot.image.pngData() {
                    try pngData.write(
                        to: screenshotsDirectory.appendingPathComponent("\(name).png"),
                        options: .atomic
                    )
                }

                application.terminate()
            }
        }
    }

    /// Creates the filename used for a screenshot and its test attachment.
    open func screenshotName(
        language: ScreenshotLanguage,
        scenario: ScreenshotScenario,
        index: Int
    ) -> String {
        let environment = ProcessInfo.processInfo.environment
        let device = environment["SIMULATOR_DEVICE_NAME"] ?? "mac"
        return [device, language.identifier, String(index), scenario.name]
            .map(Self.filenameComponent(from:))
            .joined(separator: "-")
    }

    private static func filenameComponent(from value: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        return value.unicodeScalars.map { scalar in
            allowed.contains(scalar) ? String(scalar) : "_"
        }.joined()
    }
}
#endif
