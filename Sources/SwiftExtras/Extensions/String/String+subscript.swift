//
//  String+subscript.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension String {
    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)

        let end = index(
            startIndex,
            offsetBy: (self.count <= bounds.upperBound ? bounds.upperBound : self.count) - 1
        )

        // If self is empty, then do nothing with it.
        if self.isEmpty {
            return self
        }

        return String(self[start...end])
    }

    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }

    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }

    /// A subscript to get a substring at a specified range.
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }

    /// A subscript to get the character at a specified index.
    /// - Parameter integerIndex: The index of the character that we search for.
    /// - Returns: The character found at the specified index.
    subscript(integerIndex: Int) -> Character {
        self[index(startIndex, offsetBy: integerIndex)]
    }

    /// Get character at index
    subscript (index: Int) -> String {
        return String(self[index] as Character)
    }
}
