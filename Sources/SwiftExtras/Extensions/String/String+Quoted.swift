//
//  String+Quoted.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

private let backslashesAndQuotes = CharacterSet(["\"", "\\"])

public extension StringProtocol {
    /// The string enclosed in double quotation marks, with nested quotation
    /// marks and backslashes escaped using backslashes.
    ///
    /// ```swift
    /// "SwiftExtras".quoted // "\"SwiftExtras\""
    /// "Say \"hello\"".quoted // "\"Say \\\"hello\\\"\""
    /// ```
    var quoted: String {
        var result = "\""
        var currentIndex = startIndex

        while currentIndex < endIndex {
            if let range = rangeOfCharacter(
                from: backslashesAndQuotes,
                range: currentIndex..<endIndex
            ) {
                result.append(contentsOf: self[currentIndex..<range.lowerBound])
                result.append(#"\"#)
                result.append(contentsOf: self[range])
                currentIndex = range.upperBound
            } else {
                result.append(contentsOf: self[currentIndex..<endIndex])
                currentIndex = endIndex
            }
        }

        result.append("\"")
        return result
    }
}
