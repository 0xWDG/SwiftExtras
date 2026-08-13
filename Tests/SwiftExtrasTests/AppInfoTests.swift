//
//  AppInfoTests.swift
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
@testable import SwiftExtras

@Test func appInfoSystemVersionStringsContainCurrentVersion() {
    let version = ProcessInfo.processInfo.operatingSystemVersion

    #expect(AppInfo.systemVersion == (
        "\(AppInfo.platform) \(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    ))
    #expect(AppInfo.majorSystemVersion == "\(AppInfo.platform) \(version.majorVersion)")
    #expect(AppInfo.majorMinorSystemVersion == (
        "\(AppInfo.platform) \(version.majorVersion).\(version.minorVersion)"
    ))
}

@Test func appInfoBuildAndDistributionMetadataIsConsistent() {
    #expect(AppInfo.appVersion == AppInfo.versionNumber)
    #expect(AppInfo.isSimulatorOrTestFlight == (AppInfo.isSimulator || AppInfo.isTestFlight))
    #expect(!AppInfo.architecture.isEmpty)
    #expect(!AppInfo.modelName.isEmpty)
    #expect(!AppInfo.operatingSystem.isEmpty)
    #expect(!AppInfo.platform.isEmpty)
    #expect(["simulator", "macCatalyst", "native"].contains(AppInfo.targetEnvironment))
#if DEBUG
    #expect(AppInfo.isDebug)
    #expect(!AppInfo.isTestFlight)
    #expect(!AppInfo.isAppStore)
#endif
}

@Test func appInfoLocaleMetadataMatchesFoundation() {
    #expect(AppInfo.locale == Locale.current.identifier)
    #expect(!AppInfo.region.isEmpty)
    #expect(!AppInfo.appLanguage.isEmpty)
    #expect(!AppInfo.preferredLanguage.isEmpty)
    #expect(AppInfo.timeZone.hasPrefix("UTC+") || AppInfo.timeZone.hasPrefix("UTC-"))
}

@MainActor
@Test func appInfoPresentationMetadataUsesDocumentedValues() {
    #expect(["Light", "Dark", "N/A"].contains(AppInfo.colorScheme))
    #expect(["leftToRight", "rightToLeft", "N/A"].contains(AppInfo.layoutDirection))
    #expect(!AppInfo.screenResolutionWidth.isEmpty)
    #expect(!AppInfo.screenResolutionHeight.isEmpty)
    #expect(!AppInfo.screenScaleFactor.isEmpty)
    #expect(["Portrait", "Landscape", "Unknown", "Fixed"].contains(AppInfo.orientation))
    _ = AppInfo.accessibilityParameters
}
