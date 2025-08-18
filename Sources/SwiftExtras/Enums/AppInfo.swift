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
#if canImport(LocalAuthentication)
    import LocalAuthentication
#endif
#if canImport(Darwin)
    import Darwin
#endif

/// AppInfo
///
/// Get information about the current running application.
/// This can be used to get the application name, version number, build number, etc.
public enum AppInfo {
    // swiftlint:disable:previous type_body_length
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
        Bundle.main.appStoreReceiptURL?.absoluteString.contains("sandboxReceipt") ?? false
    }

    /// Is the application running downloaded from TestFlight or locally debugging
    public static var isDebugBuild: Bool {
        #if DEBUG
        true
        #else
        Bundle.main.appStoreReceiptURL?.absoluteString.contains("sandboxReceipt") ?? false
        #endif
    }

    /// Is the application an app extension
    public var isAppExtension: Bool {
        return Bundle.main.executablePath?.contains(".appex/") ?? false
    }

    /// Is the iOS application running on a mac
    public static var isiOSAppOnMac: Bool {
        #if os(macOS) || os(iOS)
            if #available(iOS 14.0, *) {
                return ProcessInfo.processInfo.isiOSAppOnMac
            }
        #endif

        return false
    }

    /// Is the iOS application running on a Vision Pro
    public static var isiOSAppOnVisionPro: Bool {
        #if targetEnvironment(simulator)
            return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]?.hasPrefix(
                "RealityDevice") ?? false
        #elseif canImport(LocalAuthentication) && os(iOS)
            if #available(iOS 17, *) {
                let authContext = LAContext()
                _ = authContext.canEvaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics, error: nil)
                return authContext.biometryType == .opticID
            } else {
                return false
            }
        #else
            return false
        #endif
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

    /// Detects if running in Xcode SwiftUI Preview mode
    static var isSwiftUIPreview: Bool {
        #if DEBUG
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
            false
        #endif
    }

    /// Detects if UI Tests are running
    static var isUITesting: Bool {
        #if DEBUG
            ProcessInfo.processInfo.arguments.contains("UI_TESTING")
        #else
            false
        #endif
    }

    /// Detects if Unit Tests are running
    static var isUnitTesting: Bool {
        #if DEBUG
            NSClassFromString("XCTestCase") != nil
        #else
            false
        #endif
    }

    /// Detects if Low Power Mode is enabled
    static var isLowPowerModeActive: Bool {
        #if os(iOS) || os(watchOS)
            ProcessInfo.processInfo.isLowPowerModeEnabled
        #else
            false
        #endif
    }

    /// Detects if running an iOS app on Mac
    static var isRunningiOSAppOnMac: Bool {
        #if os(iOS)
            ProcessInfo.processInfo.isiOSAppOnMac
        #else
            false
        #endif
    }

    static var isDebuggerAttached: Bool {
        #if canImport(Darwin)
            var info = kinfo_proc()
            var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
            var size = MemoryLayout<kinfo_proc>.stride
            sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
            return (info.kp_proc.p_flag & P_TRACED) != 0
        #else
            return false
        #endif
    }

    /// Get the AppStore information of the application
    /// - Parameter forceRefresh: forced refresh?
    /// - Returns: AppStore information
    public static func appStoreInfo(_ forceRefresh: Bool = false) async -> SEAppInfoAppStoreInfo? {
        #if os(macOS) || os(iOS)
            let decoder = JSONDecoder()

            if let cached = UserDefaults.standard.data(forKey: "SEAppInfoAppStoreInfo"),
                let appStoreInfo = try? decoder.decode(SEAppInfoAppStoreInfo.self, from: cached),
                !forceRefresh {
                return appStoreInfo
            }

            guard
                let itunesURL = URL(
                    string: "http://itunes.apple.com/lookup?bundleId=\(AppInfo.bundleIdentifier)"
                )
            else {
                return nil
            }

            do {
                let session = URLSession(configuration: .default)
                let request = URLRequest(url: itunesURL)
                let (data, _) = try await session.data(for: request)
                UserDefaults.standard.set(data, forKey: "SEAppInfoAppStoreInfo")
                return try decoder.decode(SEAppInfoAppStoreInfo.self, from: data)
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
            let url = URL(
                string: "https://itunes.apple.com/app/id\(identifier)?action=write-review") {
            return url
        }

        return nil
    }

    /// Open the AppStore Page for the current app
    /// - Returns: URL of the review page in the AppStore
    @discardableResult
    public static func openAppStorePage() async -> Bool {
        if let identifier = await AppInfo.appStoreInfo()?.results.first?.trackId,
            let url = URL(string: "https://itunes.apple.com/app/id\(identifier)") {
            return openURL(url)
        }

        return false
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

    /// Is this the latest version of the app?
    /// - Returns: Boolean indicating if this is the current version
    public static func isLatestVersion() async -> Bool? {
        if let version = await AppInfo.appStoreInfo(true)?.results.first?.version {
            return version > versionNumber
        }

        return false
    }

    /// Is the app running tests
    public static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    /// Is the app running UI tests
    public static var isRunningUITests: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui_testing")
    }

    /// Is the app running in Xcode Preview
    public static var isRunningInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil
    }

    /// URL Schemes
    public var schemes: [String] {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let urlTypes = infoDictionary["CFBundleURLTypes"] as? [AnyObject],
            let urlType = urlTypes.first as? [String: AnyObject],
            let urlSchemes = urlType["CFBundleURLSchemes"] as? [String]
        else {
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
            #if canImport(UIKit)
                if isSwiftUIPreview {
                    return Image(systemName: "hammer.fill")
                }

                guard
                    let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons")
                        as? [String: Any],
                    let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
                    let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
                    let iconFileName = iconFiles.last
                else {
                    return Image(systemName: "xmark.app")
                }

                guard let uiImage = UIImage(named: iconFileName) else {
                    return Image(systemName: "xmark.app")
                }

                return Image(uiImage: uiImage)
            #elseif canImport(AppKit)
                if isSwiftUIPreview {
                    return Image(systemName: "hammer.fill")
                }

                guard
                    let iconFileName = Bundle.main.object(forInfoDictionaryKey: "CFBundleIconName")
                        as? String
                else {
                    return Image(systemName: "xmark.app")
                }

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
                Image(
                    systemName: UIDevice.current.userInterfaceIdiom == .pad
                        ? "apps.ipad" : "apps.iphone")
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

/// AppStore Search Result
public struct SEAppInfoAppStoreInfo: Decodable {
    /// Result Count
    public let resultCount: Int

    /// Results
    public let results: [SEAppInfoAppStoreResult]
}

/// AppStore App Info Result
public struct SEAppInfoAppStoreResult: Decodable {
    /// Developer Identifier
    public let artistId: Int

    /// App Identifier
    public let trackId: Int

    /// App Version number
    public let version: String
}
// swiftlint:disable:this file_length
