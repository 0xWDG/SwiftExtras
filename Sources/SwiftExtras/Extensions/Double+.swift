//
//  Double+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-09-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

extension Double {
    /// Convert a length value from one unit to another.
    /// - Parameters:
    ///  - originalUnit: The original unit of the length value.
    ///  - convertedUnit: The unit to convert the length value to.
    public func convert(_ originalUnit: UnitLength, to convertedUnit: UnitLength) -> Double {
        return Measurement(value: self, unit: originalUnit).converted(to: convertedUnit).value
    }
}

extension BinaryFloatingPoint {
    /// Strips trailing decimal zeros, returning a clean string representation.
    ///
    /// Returns an integer-formatted string when the fractional part is zero,
    /// otherwise returns the default string representation.
    ///
    /// Example usage:
    /// ```swift
    /// (3.0 as Double).clean  // "3"
    /// (3.14 as Float).clean  // "3.14"
    /// ```
    public var clean: String {
        truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", Double(self)) : String(Double(self))
    }
}
