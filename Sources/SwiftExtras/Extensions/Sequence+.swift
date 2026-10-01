//
//  Sequence+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-03-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(Foundation)
import Foundation

/// Declares the `AdditiveArithmetic` conformance for `Sequence where Element`.
///
/// The conformance supplies the protocol behavior implemented by the declarations in this scope.
extension Sequence where Element: AdditiveArithmetic {
    /// Returns the total sum of all elements in the sequence
    public func sum() -> Element { reduce(.zero, +) }
}
#endif
