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
/// Get information about the current running application.
/// This can be used to get the application name, version number, build number, etc.
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

    /// Application Bundle Indentifier
    public static var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "Unknown"
    }

    /// Is the application running downloaded from TestFlight
    public static var isTestflight: Bool {
        Bundle.main.appStoreReceiptURL?.absoluteString.contains("testflight") ?? false
    }

    /// Is the application an app extension
    public var isAppExtension: Bool {
        return Bundle.main.executablePath?.contains(".appex/") ?? false
    }

    /// Is the application running downloaded from AppStore
    public static var isiOSAppOnMac: Bool {
#if os(macOS) || os(iOS)
        if #available(iOS 14.0, *) {
            return ProcessInfo.processInfo.isiOSAppOnMac
        }
#endif

        return false
    }

    /// Is the application running as a Mac Catalyst app
    public static var isMacCatalystApp: Bool {
#if os(macOS) || os(iOS)
        if #available(iOS 14.0, *) {
            return ProcessInfo.processInfo.isMacCatalystApp
        }
#endif

        return false
    }

    /// Get the AppStore information of the application
    /// - Returns: AppStore information
    public static func appStoreInfo() async -> SKAppInfoAppStoreInfo? {
#if os(macOS) || os(iOS)
        let decoder = JSONDecoder()

        guard let itunesURL = URL(
            string: "http://itunes.apple.com/lookup?bundleId=\(AppInfo.bundleIdentifier)"
        ) else {
            return nil
        }

        do {
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: itunesURL)
            let (data, _) = try await session.data(for: request)
            return try decoder.decode(SKAppInfoAppStoreInfo.self, from: data)
        } catch {
            print("Error")
        }
#endif

        return nil
    }

    /// Get the Review URL of the application
    /// - Returns: URL of the review page in the AppStore
    public static func getReviewURL() async -> URL? {
        if let identifier = await AppInfo.appStoreInfo()?.results.first?.trackId,
           let url = URL(string: "https://itunes.apple.com/app/id\(identifier)?action=write-review") {
            return url
        }

        return nil
    }

    /// Get the URL of the developer page in the AppStore
    /// - Returns: URL of the developer page in the AppStore
    public static func getDeveloperURL() async -> URL? {
        if let identifier = await AppInfo.appStoreInfo()?.results.first?.artistId,
           let url = URL(string: "https://apps.apple.com/developer/id\(identifier)") {
            return url
        }

        return nil
    }

    /// Is the app running tests
    public static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    /// Is the app running UI tests
    public static var isRunningUITests: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui_testing")
    }

    /// URL Schemes
    public var schemes: [String] {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let urlTypes = infoDictionary["CFBundleURLTypes"] as? [AnyObject],
              let urlType = urlTypes.first as? [String: AnyObject],
              let urlSchemes = urlType["CFBundleURLSchemes"] as? [String] else {
            return []
        }

        return urlSchemes
    }

    /// Main URL scheme
    public var mainScheme: String? {
        return schemes.first
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

public struct SKAppInfoAppStoreInfo: Decodable {
    let results: [SKAppInfoAppStoreResult]
}

public struct SKAppInfoAppStoreResult: Decodable {
    let artistId: Int
    let trackId: Int
}
