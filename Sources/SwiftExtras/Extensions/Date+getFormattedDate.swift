//
//  Date+getFormattedDate.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-21.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension Date {
    /// Get a formatted date
    ///
    /// This function will return a formatted date
    ///
    /// Example:
    /// ```
    /// let date = Date()
    /// print(date.formatted("yyyy-MM-dd")) // 2025-02-21
    /// ```
    ///
    /// - Parameter format: The format you want to use
    /// - Returns: The formatted date
    func formatted(_ format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
