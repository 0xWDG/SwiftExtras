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
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(LocalAuthentication)
import LocalAuthentication
#endif
#if canImport(Darwin)
import Darwin
#endif
#if os(macOS)
import AppKit
import IOKit
#elseif os(iOS) || os(tvOS)
import UIKit
#elseif os(watchOS)
import WatchKit
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
           let dName = dictionary["xCFBundleDisplayName"] as? String {
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

    /// The application's bundle identifier.
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
    public static var isAppExtension: Bool {
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
    public static var isSwiftUIPreview: Bool {
#if DEBUG
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
#else
        false
#endif
    }

    /// Detects if UI Tests are running
    public static var isUITesting: Bool {
#if DEBUG
        ProcessInfo.processInfo.arguments.contains("UI_TESTING")
#else
        false
#endif
    }

    /// Detects if Unit Tests are running
    public static var isUnitTesting: Bool {
#if DEBUG
        NSClassFromString("XCTestCase") != nil
#else
        false
#endif
    }

    /// Detects if Low Power Mode is enabled
    public static var isLowPowerModeActive: Bool {
#if os(iOS) || os(watchOS)
        ProcessInfo.processInfo.isLowPowerModeEnabled
#else
        false
#endif
    }

    /// Detects if running an iOS app on Mac
    public static var isRunningiOSAppOnMac: Bool {
#if os(iOS)
        ProcessInfo.processInfo.isiOSAppOnMac
#else
        false
#endif
    }

    /// Is a debugger attached to the process
    public static var isDebuggerAttached: Bool {
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

    /// open settings page
    public static func openSettings() {
        #if os(iOS) || os(tvOS) || os(visionOS)
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            openURL(settingsURL)
        }
        #endif
    }

    /// open notification settings page
    public static func openNotificationSettings() {
        #if os(iOS) || os(tvOS) || os(visionOS)
        if let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) {
            openURL(settingsURL)
        }
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
    public static var reviewURL: URL? {
        get async {
            if let identifier = await AppInfo.appStoreInfo()?.results.first?.trackId,
               let url = URL(
                string: "https://itunes.apple.com/app/id\(identifier)?action=write-review") {
                return url
            }

            return nil
        }
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
    public static var developerURL: URL? {
        get async {
            if let identifier = await AppInfo.appStoreInfo()?.results.first?.artistId,
               let url = URL(string: "https://apps.apple.com/developer/id\(identifier)") {
                return url
            }

            return nil
        }
    }

    /// Is this the latest version of the app?
    /// - Returns: Boolean indicating if this is the current version
    public static var updateAvailable: Bool {
        get async {
            if let version = await AppInfo.appStoreInfo(true)?.results.first?.version {
                UserDefaults.standard.set(version, forKey: "SEAppInfoAppVersion")
                return version > versionNumber
            }

            return false
        }
    }

    /// get the latest version on the appstore
    public static var appStoreVersion: String {
        get async {
            await AppInfo.appStoreInfo()?.results.first?.version ?? "Unknown"
        }
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
    public static var schemes: [String] {
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
    public static var mainScheme: String? {
        return schemes.first
    }

#if os(iOS)
    /// Get the shortcut item that was used to launch the app
    /// - Returns: The shortcut item that was used to launch the app, if available
    public static var getShortcutItem: UIApplicationShortcutItem? {
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene,
               let shortcutItem = windowScene
                    .session
                    .stateRestorationActivity?
                    .userInfo?["UIApplicationShortcutItem"] as? UIApplicationShortcutItem {
                return shortcutItem
            }
        }
        return nil
    }
#endif

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

    /// Get device type
    public static var deviceType: String {
#if os(iOS)
        UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
#elseif os(macOS)
        "Mac"
#elseif os(visionOS)
        "Vision Pro"
#elseif os(tvOS)
        "Apple TV"
#elseif os(watchOS)
        "Apple Watch"
#else
        "Unknown"
#endif
    }

    /// Is the app currently under review?
    public static var isUnderReview: Bool {
        // if CFNETWORK_DIAGNOSTICS and CFNETWORK_HAR_LOGGING are set, the app is under review
        let env = ProcessInfo.processInfo.environment
        return env["CFNETWORK_DIAGNOSTICS"] != nil && env["CFNETWORK_HAR_LOGGING"] != nil
    }

    /// Get the SF Symbol for the current device
    public static var deviceTypeSymbol: Image {
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

// MARK: - Signal and environment metadata

public extension AppInfo {
    /// Accessibility settings available on the current platform.
    @MainActor
    static var accessibilityParameters: [String: String] {
        var parameters: [String: String] = [:]

#if os(iOS) || os(tvOS)
        parameters["TelemetryDeck.Accessibility.isReduceMotionEnabled"] =
            "\(UIAccessibility.isReduceMotionEnabled)"
        parameters["TelemetryDeck.Accessibility.isBoldTextEnabled"] =
            "\(UIAccessibility.isBoldTextEnabled)"
        parameters["TelemetryDeck.Accessibility.isInvertColorsEnabled"] =
            "\(UIAccessibility.isInvertColorsEnabled)"
        parameters["TelemetryDeck.Accessibility.isDarkerSystemColorsEnabled"] =
            "\(UIAccessibility.isDarkerSystemColorsEnabled)"
        parameters["TelemetryDeck.Accessibility.isReduceTransparencyEnabled"] =
            "\(UIAccessibility.isReduceTransparencyEnabled)"
        parameters["TelemetryDeck.Accessibility.shouldDifferentiateWithoutColor"] =
            "\(UIAccessibility.shouldDifferentiateWithoutColor)"

        if !isAppExtension {
            parameters["TelemetryDeck.Accessibility.preferredContentSizeCategory"] =
                UIApplication.shared.preferredContentSizeCategory.rawValue
                    .replacingOccurrences(of: "UICTContentSizeCategory", with: "")
        }
#elseif os(macOS)
        if let preferences = UserDefaults.standard.persistentDomain(
            forName: "com.apple.universalaccess"
        ) {
            parameters["TelemetryDeck.Accessibility.isReduceMotionEnabled"] =
                "\(preferences["reduceMotion"] as? Bool ?? false)"
            parameters["TelemetryDeck.Accessibility.isInvertColorsEnabled"] =
                "\(preferences["InvertColors"] as? Bool ?? false)"
        }
#endif

        return parameters
    }

    /// Whether the app is running in Simulator or was installed through TestFlight.
    static var isSimulatorOrTestFlight: Bool { isSimulator || isTestFlight }

    /// Whether the app is running in Simulator.
    static var isSimulator: Bool {
#if targetEnvironment(simulator)
        true
#else
        false
#endif
    }

    /// Whether this is a debug build.
    static var isDebug: Bool {
#if DEBUG
        true
#else
        false
#endif
    }

    /// Whether this non-debug build was installed through TestFlight.
    static var isTestFlight: Bool {
        guard !isDebug, let receiptPath = Bundle.main.appStoreReceiptURL?.path else {
            return false
        }
        return receiptPath.contains("sandboxReceipt")
    }

    /// Whether the app is a native App Store build.
    static var isAppStore: Bool {
#if DEBUG || os(macOS) || targetEnvironment(macCatalyst) || targetEnvironment(simulator)
        false
#else
        !isTestFlight
#endif
    }

    /// The operating system name and its full version.
    static var systemVersion: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(platform) \(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }

    /// The operating system name and major version.
    static var majorSystemVersion: String {
        "\(platform) \(ProcessInfo.processInfo.operatingSystemVersion.majorVersion)"
    }

    /// The operating system name, major version, and minor version.
    static var majorMinorSystemVersion: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(platform) \(version.majorVersion).\(version.minorVersion)"
    }

    /// The bundle's user-facing version string.
    static var appVersion: String { versionNumber }

    /// The active app extension's extension-point identifier, when applicable.
    static var extensionIdentifier: String? {
        let extensionInfo = Bundle.main.infoDictionary?["NSExtension"] as? [String: Any]
        return extensionInfo?["NSExtensionPointIdentifier"] as? String
    }

    /// The hardware model identifier reported by the operating system.
    static var modelName: String {
#if os(iOS)
        if ProcessInfo.processInfo.isiOSAppOnMac {
            var size = 0
            sysctlbyname("hw.model", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: size)
            sysctlbyname("hw.model", &machine, &size, nil, 0)
            return String(cString: machine)
        }
#elseif os(macOS)
        let service = IOServiceGetMatchingService(
            kIOMainPortDefault,
            IOServiceMatching("IOPlatformExpertDevice")
        )
        defer { IOObjectRelease(service) }

        if service != 0,
           let data = IORegistryEntryCreateCFProperty(
            service,
            "model" as CFString,
            kCFAllocatorDefault,
            0
           )?.takeRetainedValue() as? Data,
           let model = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .controlCharacters),
           !model.isEmpty {
            return model
        }
#endif

        return Device.model
    }

    /// The architecture for which the app is currently running.
    static var architecture: String {
#if arch(x86_64)
        "x86_64"
#elseif arch(arm)
        "arm"
#elseif arch(arm64)
        "arm64"
#elseif arch(i386)
        "i386"
#elseif arch(powerpc64)
        "powerpc64"
#elseif arch(powerpc64le)
        "powerpc64le"
#elseif arch(s390x)
        "s390x"
#else
        "unknown"
#endif
    }

    /// The operating system reported by the Swift compilation target.
    static var operatingSystem: String {
#if os(macOS)
        "macOS"
#elseif os(visionOS)
        "visionOS"
#elseif os(iOS)
        "iOS"
#elseif os(watchOS)
        "watchOS"
#elseif os(tvOS)
        "tvOS"
#else
        "Unknown Operating System"
#endif
    }

    /// The actual runtime platform, including Catalyst and iOS apps on Mac.
    static var platform: String {
#if os(macOS)
        "macOS"
#elseif os(visionOS)
        "visionOS"
#elseif os(iOS)
#if targetEnvironment(macCatalyst)
        "macCatalyst"
#else
        ProcessInfo.processInfo.isiOSAppOnMac ? "isiOSAppOnMac" : "iOS"
#endif
#elseif os(watchOS)
        "watchOS"
#elseif os(tvOS)
        "tvOS"
#else
        "Unknown Platform"
#endif
    }

    /// The target environment: `simulator`, `macCatalyst`, or `native`.
    static var targetEnvironment: String {
#if targetEnvironment(simulator)
        "simulator"
#elseif targetEnvironment(macCatalyst)
        "macCatalyst"
#else
        "native"
#endif
    }

    /// The locale identifier in which the app is running.
    static var locale: String { Locale.current.identifier }

    /// The current locale's region identifier.
    static var region: String {
        Locale.current.region?.identifier
            ?? Locale.current.identifier.split(whereSeparator: { $0 == "-" || $0 == "_" }).last.map(String.init)
            ?? "Unknown"
    }

    /// The language identifier in which the app is running.
    static var appLanguage: String {
        Locale.current.language.languageCode?.identifier
            ?? Locale.current.identifier.split(whereSeparator: { $0 == "-" || $0 == "_" }).first.map(String.init)
            ?? "Unknown"
    }

    /// The user's most preferred language identifier.
    static var preferredLanguage: String {
        let identifier = Locale.preferredLanguages.first ?? "zz-ZZ"
        return identifier.split(whereSeparator: { $0 == "-" || $0 == "_" }).first.map(String.init)
            ?? "zz"
    }

    /// The user-selected color scheme, or `N/A` where unavailable.
    @MainActor
    static var colorScheme: String {
#if os(iOS) || os(tvOS)
        switch UIScreen.main.traitCollection.userInterfaceStyle {
        case .dark: "Dark"
        case .light: "Light"
        default: "N/A"
        }
#elseif os(macOS)
        guard let appearance = NSApp?.effectiveAppearance else { return "N/A" }
        switch appearance.name {
        case .aqua: return "Light"
        case .darkAqua: return "Dark"
        default: return "N/A"
        }
#else
        "N/A"
#endif
    }

    /// The user-selected interface layout direction.
    @MainActor
    static var layoutDirection: String {
#if os(iOS) || os(tvOS)
        guard !isAppExtension else { return "N/A" }
        return UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
            ? "leftToRight" : "rightToLeft"
#elseif os(macOS)
        guard let application = NSApp else { return "N/A" }
        return application.userInterfaceLayoutDirection == .leftToRight
            ? "leftToRight" : "rightToLeft"
#else
        return "N/A"
#endif
    }

    /// The current screen width in points, or `N/A` when unavailable.
    @MainActor
    static var screenResolutionWidth: String {
#if os(iOS) || os(tvOS)
        "\(UIScreen.main.bounds.width)"
#elseif os(watchOS)
        "\(WKInterfaceDevice.current().screenBounds.width)"
#elseif os(macOS)
        NSScreen.main.map { "\($0.frame.width)" } ?? "N/A"
#else
        "N/A"
#endif
    }

    /// The current screen height in points, or `N/A` when unavailable.
    @MainActor
    static var screenResolutionHeight: String {
#if os(iOS) || os(tvOS)
        "\(UIScreen.main.bounds.height)"
#elseif os(watchOS)
        "\(WKInterfaceDevice.current().screenBounds.height)"
#elseif os(macOS)
        NSScreen.main.map { "\($0.frame.height)" } ?? "N/A"
#else
        "N/A"
#endif
    }

    /// The current screen's scale factor, or `N/A` when unavailable.
    @MainActor
    static var screenScaleFactor: String {
#if os(iOS) || os(tvOS)
        "\(UIScreen.main.scale)"
#elseif os(macOS)
        NSScreen.main.map { "\($0.backingScaleFactor)" } ?? "N/A"
#else
        "N/A"
#endif
    }

    /// The current device orientation, or `Fixed` on non-rotating platforms.
    @MainActor
    static var orientation: String {
#if os(iOS)
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown: "Portrait"
        case .landscapeLeft, .landscapeRight: "Landscape"
        default: "Unknown"
        }
#else
        "Fixed"
#endif
    }

    /// The current time zone as a numeric UTC offset, such as `UTC+1` or `UTC-3:30`.
    static var timeZone: String {
        let seconds = TimeZone.current.secondsFromGMT()
        let absoluteSeconds = abs(seconds)
        let hours = absoluteSeconds / 3_600
        let minutes = absoluteSeconds / 60 % 60
        let sign = seconds >= 0 ? "+" : "-"
        return minutes == 0
            ? "UTC\(sign)\(hours)"
            : "UTC\(sign)\(hours):\(String(format: "%02d", minutes))"
    }
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
