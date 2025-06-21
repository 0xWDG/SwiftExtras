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

extension StringProtocol {
    /// Capitalize the first letter of a string
    public var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }

    /// Capitalize the first letter of a string
    public var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
