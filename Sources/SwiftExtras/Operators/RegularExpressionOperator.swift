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
///   - source: String to be checked
///   - pattern: against regular expression
/// - Returns: true if found, otherwise false
public func =~ (source: String, pattern: String) -> Bool {
    return source.range(
        of: pattern,
        options: .regularExpression,
        range: nil,
        locale: nil
    ) != nil
}

///  Regular expression infix operator (inverse matching)
infix operator !~

/// Regular expression infix operator (inverse matching)
/// - Parameters:
///   - source: String to be checked
///   - pattern: against regular expression
/// - Returns: true if not found, otherwise false
public func !~ (source: String, pattern: String) -> Bool {
    return !(source =~ pattern)
}
