//
//  AutoEquatable.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-03-27.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

/// A marker protocol that derives equality by comparing textual value dumps.
///
/// This helper is intended for package-internal types whose dumped representations
/// are stable and contain every value relevant to equality.
protocol AutoEquatable: Equatable {}

extension AutoEquatable {
    /// Compares two values using their textual dump representations.
    ///
    /// - Parameters:
    ///   - lhs: The value on the left side of the equality operator.
    ///   - rhs: The value on the right side of the equality operator.
    /// - Returns: `true` when both dump representations are identical.
    static func == (lhs: Self, rhs: Self) -> Bool {
        var lhsDump = String()
        dump(lhs, to: &lhsDump)

        var rhsDump = String()
        dump(rhs, to: &rhsDump)

        return rhsDump == lhsDump
    }
}
