//
//  Collection+.swift
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

extension Collection where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    public func average() -> Element { isEmpty ? .zero : sum() / Element(count) }
    /// Returns the average of all elements in the array as Floating Point type
    public func average<T: FloatingPoint>() -> T { isEmpty ? .zero : T(sum()) / T(count) }
}
#endif
