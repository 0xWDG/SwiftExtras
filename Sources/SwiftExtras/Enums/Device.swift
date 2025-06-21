//
//  Device.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Device information
///
/// Get information about the current running device.
/// This can be used to get the device model, OS version, etc.
public enum Device {
    /// Obtain the machine hardware platform from the `uname()` unix command
    public static var model: String {
#if canImport(Darwin)
        var utsnameInstance = utsname()
        uname(&utsnameInstance)
        let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                String(validatingUTF8: ptr)
            }
        }

        return optionalString ?? "N/A"
#else
        return "N/A"
#endif
    }

    /// Operating system version
    public static var osVersion: String {
        ProcessInfo.processInfo.operatingSystemVersionString
    }

    /// Are we running on Carplay?
    var isCarplay: Bool {
#if canImport(UIKit) && os(iOS)
        if #available(iOS 16, *) {
            return UIApplication.shared.connectedScenes.filter {
                ($0 as? UIWindowScene)?.traitCollection.userInterfaceIdiom == .carPlay
            }.count >= 1
        } else {
            return UIScreen.screens.filter {
                $0.traitCollection.userInterfaceIdiom == .carPlay
            }.count >= 1
        }
#else
    return false
#endif
}

#if canImport(UIKit)
/// The device name (e.g., "John’s iPhone")
static var deviceName: String {
    UIDevice.current.name
}

/// The system name (e.g., "iOS")
static var deviceSystemName: String { UIDevice.current.systemName }

/// The unique vendor identifier (IDFV)
static var deviceIdentifierForVendor: String { UIDevice.current.identifierForVendor?.uuidString ?? "No ID" }

/// Detect if the device is an iPad
static var isiPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

/// Detect if the device is an iPhone
static var isiPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }

#if !os(tvOS)
/// The current battery level (0.0 to 1.0)
static var deviceBatteryLevel: Float { UIDevice.current.batteryLevel }

/// The current battery state (charging, full, unplugged)
static var deviceBatteryState: UIDevice.BatteryState { UIDevice.current.batteryState }

#if !os(visionOS)
/// The device’s orientation (portrait, landscape, etc.)
static var deviceOrientation: UIDeviceOrientation { UIDevice.current.orientation }

/// Detect if the device is in portrait mode
static var isPortraitMode: Bool { UIDevice.current.orientation.isPortrait }

/// Detect if the device is in landscape mode
static var isLandscapeMode: Bool { UIDevice.current.orientation.isLandscape }
#endif
#endif
#endif
}
