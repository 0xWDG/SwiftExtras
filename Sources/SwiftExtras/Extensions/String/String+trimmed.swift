//
//  String+trimmed.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

extension String {
    /// This is a shorthand for `trimmingCharacters(in:)`.
    ///
    /// - Parameter set: The set of characters to trim.
    /// - Returns: A new string with the specified characters trimmed.
    public func trimmed(
        for set: CharacterSet = .whitespacesAndNewlines
    ) -> String {
        self.trimmingCharacters(in: set)
    }
}
