//
//  Testing.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

/// UITest
///
/// Great additions for UITesting
public enum UITest {
    /// Check if interface tests are running or not.
    public static var isRunning: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui_testing")
    }
}

/// UnitTest
///
/// Great additions for UnitTesting
public enum UnitTest {
    /// Check if unit tests are running or not.
    public static var isRunning: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    #if !os(watchOS)
    /// Count time for action
    /// - Parameter closure: item to be performed
    /// - Returns: execution time in Float
    public static func measure(closure: () -> Void) -> Float {
        let start = CACurrentMediaTime()
        closure()

        let end = CACurrentMediaTime()
        return Float(end - start)
    }
    #endif
}
