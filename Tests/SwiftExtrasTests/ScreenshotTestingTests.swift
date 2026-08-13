//
//  ScreenshotTestingTests.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
import Testing
import SwiftExtrasScreenshotTesting

@Test func screenshotLanguageUsesLanguageAsDefaultLocale() {
    let language = ScreenshotLanguage(identifier: "nl")

    #expect(language.identifier == "nl")
    #expect(language.localeIdentifier == "nl")
    #expect(ScreenshotLanguage(identifier: "en", localeIdentifier: "en_US").localeIdentifier == "en_US")
}

@Test func screenshotScenarioProvidesUsefulDefaults() {
    let scenario = ScreenshotScenario(name: "Home")

    #expect(scenario.name == "Home")
    #expect(scenario.appearance == .light)
    #expect(scenario.launchArguments.isEmpty)
}

@Test func screenshotScenarioPreservesAppearanceAndLaunchArguments() {
    let scenario = ScreenshotScenario(
        name: "Details",
        appearance: .dark,
        launchArguments: ["-ScreenshotScenario", "details"]
    )

    #expect(scenario.appearance == .dark)
    #expect(scenario.launchArguments == ["-ScreenshotScenario", "details"])
}

#if canImport(Darwin)
@Test func screenshotTestCaseProvidesDefaultConfiguration() {
    let testCase = makeScreenshotTestCase()

    #expect(testCase.languages == [.init(identifier: "en")])
    #expect(testCase.scenarios == [.init(name: "default")])

    if let hostHome = ProcessInfo.processInfo.environment["SIMULATOR_HOST_HOME"] {
        #expect(testCase.screenshotsDirectory == URL(fileURLWithPath: hostHome, isDirectory: true)
            .appendingPathComponent("screenshots", isDirectory: true))
    } else {
        #expect(testCase.screenshotsDirectory == nil)
    }
}

@Test func screenshotNamesIncludeConfigurationAndSanitizeUnsafeCharacters() {
    let testCase = makeScreenshotTestCase()
    let name = testCase.screenshotName(
        language: .init(identifier: "pt-BR"),
        scenario: .init(name: "Details / Dark"),
        index: 7
    )

    #expect(name.hasSuffix("-pt-BR-7-Details___Dark"))
    #expect(!name.contains(" "))
    #expect(!name.contains("/"))
}

private func makeScreenshotTestCase() -> ScreenshotTestCase {
    ScreenshotTestCase()
}
#endif
