//
//  Optional+isNilOrEmpty.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-02-01.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension Optional where Wrapped: Collection {
    /// Checks if the optional collection is nil or empty.
    ///
    /// Usage example:
    /// ```swift
    /// let array: [Int]? = nil
    /// if array.isNilOrEmpty {
    ///     print("Array is either nil or empty")
    /// }
    /// ```
    ///
    /// - Returns: `true` if the collection is nil or empty, `false` otherwise.
    @inlinable
    @inline(__always)
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }

    /// Checks if the optional collection is not nil nor empty.
    ///
    /// Usage example:
    /// ```swift
    /// let array: [Int]? = [0]
    /// if array.isNotNilNorEmpty {
    ///     print("Array is not nil or empty")
    /// }
    /// ```
    ///
    /// - Returns: `true` if the collection is nil or empty, `false` otherwise.
    @inlinable
    @inline(__always)
    var isNotNilNorEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public extension Optional {
    /// - Returns: `true` if the wrapped value is equal to nil, `false` otherwise.
    @inlinable
    @inline(__always)
    var isNil: Bool {
        return self == nil
    }

    /// - Returns: `true` if the wrapped value is not equal to nil, `false` otherwise.
    @inlinable
    @inline(__always)
    var isNotNil: Bool {
        return self != nil
    }
}
