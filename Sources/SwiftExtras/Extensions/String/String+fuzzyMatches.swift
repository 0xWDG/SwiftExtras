//
//  String+fuzzyMatches.swift
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
    /// Returns whether the receiver is a fuzzy match for the given query.
    ///
    /// Fuzzy matching checks that every character in `query` appears in the
    /// receiver in order (case-insensitive), allowing for gaps between characters.
    /// For example, `"rjks"` fuzzy-matches `"Rijksmuseum"`.
    ///
    /// - Parameter query: The search string to test against.
    /// - Returns: `true` when all characters of `query` occur in the receiver in
    ///   order; `false` otherwise.
    public func fuzzyMatches(_ query: String) -> Bool {
        guard !query.isEmpty else { return true }

        let selfChars = Array(self.lowercased())
        let queryChars = Array(query.lowercased())

        var selfIndex = 0
        var queryIndex = 0

        while selfIndex < selfChars.count, queryIndex < queryChars.count {
            if selfChars[selfIndex] == queryChars[queryIndex] {
                queryIndex += 1
            }
            selfIndex += 1
        }

        return queryIndex == queryChars.count
    }
}
