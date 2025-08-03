//
//  String+slugified.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension String {
    /// Slugify a string
    var slugified: String {
        let input = self
        let lowercased = input.lowercased()
        let trimmed = lowercased.trimmingCharacters(in: .whitespacesAndNewlines)
        let slugified = trimmed.replacingOccurrences(of: " ", with: "-")
        return slugified
    }
}
