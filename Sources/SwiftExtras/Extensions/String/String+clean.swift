//
//  String+clean.swift
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
    /// Strips diacritics from the string
    /// - Returns: String without diacritics
    public func clean() -> Self {
        return self.folding(
            options: .diacriticInsensitive,
            locale: .current
        )
    }
}
