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
enum ANSIColors: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case `default` = "\u{001B}[0;0m"
}

/// Add ANSI colors to a string
/// - Parameters:
///   - left: ANSI Color
///   - right: String
/// - Returns: Colored String
func + (left: ANSIColors, right: String) -> String {
    return left.rawValue + right
}

/// Add ANSI colors to a string
/// - Parameters:
///   - left: String
///   - right: ANSI Color
/// - Returns: Colored String
func + (left: String, right: ANSIColors) -> String {
    return left + right.rawValue
}
