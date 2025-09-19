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

    /// Remove any decimals
    public var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
