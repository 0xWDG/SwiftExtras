//
//  Int+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-03-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

extension Int {
    /// Convert Int to Currency
    ///
    /// - Returns: String
    public func toCurrency(digits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = digits
        if let currencyString = formatter.string(from: self as NSNumber) {
            return currencyString
        }

        return String(self)
    }
}
