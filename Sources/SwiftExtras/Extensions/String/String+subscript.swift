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

extension String {
    /// A subscript to get a substring at a specified range.
    ///
    /// This subscript allows you to get a substring at a specified range.
    /// 
    /// Usage:
    /// ```swift
    /// let string = "Hello World!"
    /// print(string[0...7]) // "Hello, W"
    /// ```
    ///
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    public subscript (bounds: CountableClosedRange<Int>) -> String {
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
    ///
    /// This subscript allows you to get a substring at a specified range.
    ///
    /// Usage:
    /// ```swift
    /// let string = "Hello World!"
    /// print(string[0..<7]) // "Hello, "
    /// ```
    /// 
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    public subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    /// A subscript to get a substring at a specified range.
    ///
    /// This subscript allows you to get a substring at a specified range.
    ///
    /// Usage:
    /// ```swift
    /// let string = "Hello World!"
    /// print(string[..<7]) // "Hello, "
    /// ```
    /// 
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    public subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }

    /// A subscript to get a substring at a specified range.
    ///
    /// This subscript allows you to get a substring at a specified range.
    ///
    /// Usage:
    /// ```swift
    /// let string = "Hello World!"
    /// print(string[...7]) // "Hello, "
    /// ```
    /// 
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    public subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }

    /// A subscript to get a substring at a specified range.
    ///
    /// This subscript allows you to get a substring at a specified range.
    ///
    /// Usage:
    /// ```swift
    /// let string = "Hello World!"
    /// print(string[7...]) // "World!"
    /// ```
    /// 
    /// - Parameter bounds: The range that will be used to find the substring.
    /// - Returns: The substring corresponding to the specified range.
    public subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }

    /// A subscript to get the character at a specified index.
    ///
    /// This subscript allows you to get a substring at a specified range.
    /// 
    /// Usage:
    /// ```swift
    /// let string = "Hello World!"
    /// print(string[7]) // "W"
    /// ```
    ///
    /// - Parameter characterIndex: The index of the character that we search for.
    /// - Returns: The character found at the specified index.
    public subscript(characterIndex: Int) -> String {
        return String(self[self.index(startIndex, offsetBy: characterIndex)])
    }
}
