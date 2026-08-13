//
//  DeviceInfoTests.swift
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

@Test func deviceInfoExposesBundleMetadataWithoutEmptyRequiredValues() {
    #expect(!DeviceInfo.bundleName.isEmpty)
    #expect(!DeviceInfo.bundleIdentifier.isEmpty)
    #expect(!DeviceInfo.bundleVersion.isEmpty)
    #expect(!DeviceInfo.version.isEmpty)
    #expect(DeviceInfo.copyright == (
        Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? ""
    ))
}

@Test func deviceInfoExposesOperatingSystemVersion() {
    let expected = ProcessInfo.processInfo.operatingSystemVersion

    #expect(!DeviceInfo.systemVersionString.isEmpty)
    #expect(DeviceInfo.systemMajorVersion == expected.majorVersion)
    #expect(DeviceInfo.systemMinorVersion == expected.minorVersion)
    #expect(DeviceInfo.systemPatchVersion == expected.patchVersion)
    #expect(DeviceInfo.appIsSandboxed == (
        ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
    ))
}

@MainActor
@Test func deviceInfoExposesPlatformPresentationInformation() {
    #expect(!DeviceInfo.osName.isEmpty)
    _ = DeviceInfo.isDarkMode
#if (canImport(UIKit) && !os(watchOS)) || canImport(AppKit)
    _ = DeviceInfo.appIcon
#endif
}
