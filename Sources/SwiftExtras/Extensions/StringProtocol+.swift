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

public extension StringProtocol {
    /// Capitalize the first letter of a string
    var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }

    /// Capitalize the first letter of a string
    var firstCapitalized: String {
        prefix(1).capitalized + dropFirst()
    }
}
