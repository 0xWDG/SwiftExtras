//
//  RegularExpressionOperator.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-03-05.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

///  Regular expression infix operator (Matching)
infix operator =~

/// Regular expression infix operator (Matching)
/// - Parameters:
///   - string: String to be checked
///   - regex: against regular expression
/// - Returns: true if found, otherwise false
public func =~ (string: String, regex: String) -> Bool {
    string.range(
        of: regex,
        options: .regularExpression,
        range: nil,
        locale: nil
    ) != nil
}

///  Regular expression infix operator (inverse matching)
infix operator !~

/// Regular expression infix operator (inverse matching)
/// - Parameters:
///   - string: String to be checked
///   - regex: against regular expression
/// - Returns: true if not found, otherwise false
public func !~ (source: String, pattern: String) -> Bool {
    !(source =~ pattern)
}
