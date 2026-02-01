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
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
