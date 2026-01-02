//
//  String+slice.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-12-25.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

extension String {
    /// Slices a string between two substrings.
    /// - Parameters:
    ///   - from: The starting substring.
    ///   - to: The ending substring.
    /// - Returns: The sliced substring, or nil if the substrings are not found.
    public func slice(from: String, to end: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: end)?.lowerBound else { return nil }
        return String(self[rangeFrom..<rangeTo])
    }
}
