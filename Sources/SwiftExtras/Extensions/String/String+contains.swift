//
//  String+contains.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension String {
    /// Check if this string contains another string.
    /// - Parameters:
    ///   - string: The string to check for.
    ///   - caseSensitive: Whether the search should be case-sensitive.
    /// - Returns: `true` if the string contains the other string, `false`
    /// otherwise.
    func contains(_ string: String, caseSensitive: Bool) -> Bool {
        caseSensitive
            ? contains(string)
            : range(of: string, options: .caseInsensitive) != nil
    }
}
