//
//  String+clean.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 09/06/2025.
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
