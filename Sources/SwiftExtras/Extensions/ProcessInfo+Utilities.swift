//
//  Processinfo+Utilities.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension ProcessInfo {
    /// Detects if running in Xcode SwiftUI Preview mode
    static var isSwiftUIPreview: Bool {
#if DEBUG
        processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
#else
        false
#endif
    }

    /// Detects if UI Tests are running
    static var isUITesting: Bool {
#if DEBUG
        processInfo.arguments.contains("UI_TESTING")
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
        processInfo.isLowPowerModeEnabled
#else
        false
#endif
    }

    /// Detects if running an iOS app on Mac
    static var isRunningiOSAppOnMac: Bool {
#if os(iOS)
        processInfo.isiOSAppOnMac
#else
        false
#endif
    }
}
