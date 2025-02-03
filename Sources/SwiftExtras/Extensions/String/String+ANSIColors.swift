//
//  String+ANSIColors.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

/// ANSI Colors
public enum ANSIColors: String {
    /// ANSI Color: Black
    case black = "\u{001B}[0;30m"
    /// ANSI Color: Red
    case red = "\u{001B}[0;31m"
    /// ANSI Color: Green
    case green = "\u{001B}[0;32m"
    /// ANSI Color: Yellow
    case yellow = "\u{001B}[0;33m"
    /// ANSI Color: Blue
    case blue = "\u{001B}[0;34m"
    /// ANSI Color: Magenta
    case magenta = "\u{001B}[0;35m"
    /// ANSI Color: Cyan
    case cyan = "\u{001B}[0;36m"
    /// ANSI Color: White
    case white = "\u{001B}[0;37m"
    /// ANSI Color: Default
    case `default` = "\u{001B}[0;0m"
}

/// Add ANSI colors to a string
///
/// This allows you to use the `+` operator to add ANSI colors to a string.
///
/// Example:
/// ```swift
/// print(ANSIColors.red + "Hello, " + ANSIColors.default + "World")
/// ```
///
/// - Parameters:
///   - left: ANSI Color
///   - right: String
/// - Returns: Colored String
func + (left: ANSIColors, right: String) -> String {
    return left.rawValue + right
}

/// Add ANSI colors to a string
///
/// This allows you to use the `+` operator to add ANSI colors to a string.
///
/// Example:
/// ```swift
/// print("Hello, " + ANSIColors.red + "World" + ANSIColors.default)
/// ```
///
/// - Parameters:
///   - left: String
///   - right: ANSI Color
/// - Returns: Colored String
func + (left: String, right: ANSIColors) -> String {
    return left + right.rawValue
}
