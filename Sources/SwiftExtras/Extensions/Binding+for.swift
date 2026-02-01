//
//  Binding+onChange.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-02-01.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

public extension Binding {
    /// Create a read-only Binding for an optional source
    ///
    /// Example usage:
    /// ```swift
    /// Binding(for: myOptionalValue?)
    /// ```
    ///
    /// - Parameter source: optional source value
    /// - Returns: read-only Binding
    init<T>(for source: T?) where Value == T? {
        self.init(
            get: { source },
            set: { _, _ in }
        )
    }
}
#endif
