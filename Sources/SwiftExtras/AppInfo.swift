//
//  AppInfo.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI
#endif

/// AppInfo
///
/// Get information about the application
public enum AppInfo {
    /// Get application name
    /// - Returns: application name
    public static var appName: String {
        if let dictionary = Bundle.main.infoDictionary,
           let dName = dictionary["CFBundleDisplayName"] as? String {
            return dName
        }

        if let dictionary = Bundle.main.infoDictionary,
           let dName = dictionary["CFBundleName"] as? String {
            return dName
        }

        return "Unknown"
    }

    /// Get application version number
    /// - Returns: application version number
    public static var versionNumber: String {
        if let dictionary = Bundle.main.infoDictionary,
           let dVersion = dictionary["CFBundleShortVersionString"] as? String {
            return dVersion
        }

        return "0"
    }

    /// Get application build number
    /// - Returns: application build number
    public static var buildNumber: String {
        if let dictionary = Bundle.main.infoDictionary,
           let dBuild = dictionary["CFBundleVersion"] as? String {
            return dBuild
        }

        return "0"
    }

    /// Is the application running downloaded from TestFlight
    public static var isTestflight: Bool {
        Bundle.main.appStoreReceiptURL?.absoluteString.contains("testflight") ?? false
    }

    /// Is the application running downloaded from AppStore
    public static var isiOSAppOnMac: Bool {
        if #available(iOS 14.0, *) {
            return ProcessInfo.processInfo.isiOSAppOnMac
        }

        return false
    }

    /// Is the application running as a Mac Catalyst app
    public static var isMacCatalystApp: Bool {
        if #available(iOS 14.0, *) {
            return ProcessInfo.processInfo.isMacCatalystApp
        }

        return false
    }

#if canImport(SwiftUI)
    /// Get application icon
    ///
    /// - Returns: Application icon
    public static var appIcon: Image {
        guard let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last else {
            return Image.init(systemName: "xmark.app")
        }

#if canImport(UIKit)
        guard let uiImage = UIImage(named: iconFileName) else {
            return Image(systemName: "xmark.app")
        }

        return Image(uiImage: uiImage)
#elseif canImport(AppKit)
        guard let nsImage = NSImage(named: iconFileName) else {
            return Image(systemName: "xmark.app")
        }

        return Image(nsImage: nsImage)
#else
        return Image(systemName: "xmark.app")
#endif
    }

    /// Get the SF Symbol for the current device
    public static var deviceType: Image {
#if os(iOS)
        Image(systemName: UIDevice.current.userInterfaceIdiom == .pad ? "ipad" : "iphone")
#elseif os(macOS)
        Image(systemName: "macbook")
#elseif os(visionOS)
        Image(systemName: "visionpro")
#elseif os(tvOS)
        Image(systemName: "appletv")
#elseif os(watchOS)
        Image(systemName: "applewatch")
#endif
    }

    /// Get device icon showing the app-grid (if available)
    public static var deviceTypeApps: Image {
#if os(iOS)
        Image(systemName: UIDevice.current.userInterfaceIdiom == .pad ? "apps.ipad" : "apps.iphone")
#elseif os(macOS)
        Image(systemName: "macbook")
#elseif os(visionOS)
        Image(systemName: "visionpro")
#elseif os(tvOS)
        Image(systemName: "appletv")
#elseif os(watchOS)
        Image(systemName: "applewatch")
#endif
    }
#endif
}
