//
//  StringProtocol+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-03-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

/// Adds `StringProtocol ` functionality to `StringProtocol`.
///
/// The declarations in this scope provide focused utilities while preserving the type’s standard behavior.
extension StringProtocol {
    /// Capitalize the first letter of a string
    public var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }

    /// Capitalize the first letter of a string
    public var firstCapitalized: String {
        prefix(1).capitalized + dropFirst()
    }
}
