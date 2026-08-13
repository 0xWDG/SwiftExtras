//
//  DeviceInfo.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

#if canImport(UIKit) && !os(watchOS)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Information about the current application and operating system.
public struct DeviceInfo: Sendable {
    /// Creates a device information value.
    public init() { }

    /// The application bundle's name.
    public static var bundleName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? "Unknown"
    }

    /// The application bundle's identifier.
    public static var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "Unknown"
    }

    /// The application bundle's build number.
    public static var bundleVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            ?? "0"
    }

    /// The application bundle's user-facing version.
    public static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            ?? "0"
    }

    /// A human-readable description of the operating system version.
    public static var systemVersionString: String {
        ProcessInfo.processInfo.operatingSystemVersionString
    }

    /// The operating system version components.
    public static var systemVersion: OperatingSystemVersion {
        ProcessInfo.processInfo.operatingSystemVersion
    }

    /// The operating system's major version number.
    public static var systemMajorVersion: Int { systemVersion.majorVersion }

    /// The operating system's minor version number.
    public static var systemMinorVersion: Int { systemVersion.minorVersion }

    /// The operating system's patch version number.
    public static var systemPatchVersion: Int { systemVersion.patchVersion }

    /// Whether the process is running inside an application sandbox container.
    public static var appIsSandboxed: Bool {
        ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
    }

    /// The human-readable copyright string in the application bundle.
    public static var copyright: String {
        Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? ""
    }

    /// The name of the current Apple operating system.
    @MainActor
    public static var osName: String {
#if canImport(UIKit) && !os(watchOS)
        UIDevice.current.systemName
#elseif os(macOS)
        "macOS"
#elseif os(watchOS)
        "watchOS"
#else
        ProcessInfo.processInfo.operatingSystemVersionString
#endif
    }

    /// Whether the current system appearance is dark.
    @MainActor
    public static var isDarkMode: Bool {
#if canImport(UIKit) && !os(watchOS)
        UIScreen.main.traitCollection.userInterfaceStyle == .dark
#elseif canImport(AppKit)
        NSApp?.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
#else
        false
#endif
    }

#if canImport(UIKit) && !os(watchOS)
    /// The current application's native icon image, when it can be loaded.
    @MainActor
    public static var appIcon: UIImage? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconName = iconFiles.last else {
            return nil
        }

        return UIImage(named: iconName)
    }
#elseif canImport(AppKit)
    /// The current application's native icon image, when an application is available.
    @MainActor
    public static var appIcon: NSImage? {
        NSApp?.applicationIconImage
    }
#endif
}
