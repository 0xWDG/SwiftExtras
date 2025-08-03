//
//  Collection+safeIndex.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-03.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(Foundation)
    import Foundation

    public extension Collection {
        /// Accesses the element at the specified position in a safe manner.
        ///
        /// This subscript provides a safe way to access elements within the collection by
        /// returning `nil` instead of crashing when accessing an index out of bounds.
        /// It is useful for avoiding runtime errors when the exact count of the collection
        /// might not be known or when dealing with dynamic data sources.
        /// This approach ensures that attempts to access indices outside the valid
        /// range simply result in `nil`, allowing for more graceful handling of such cases.
        ///
        /// - Parameter index: The position of the element to access.
        ///                    If the index is within the bounds of the collection, \
        ///                    the element at that position is returned. Otherwise, `nil` is returned.
        /// - Returns: The element at the specified index if it is within the collection's bounds; otherwise, `nil`.
        ///
        /// Example usage:
        /// ```
        /// let numbers = [1, 2, 3, 4, 5]
        /// if let number = numbers[safe: 3] {
        ///     print(number) // Prints "4"
        /// } else {
        ///     print("Index out of bounds")
        /// }
        ///
        /// if let outOfBoundsNumber = numbers[safe: 10] {
        ///     print(outOfBoundsNumber)
        /// } else {
        ///     print("Index out of bounds") // Prints "Index out of bounds"
        /// }
        /// ```
        ///
        /// This method enhances the safety and readability of collection access, \
        /// especially in more complex logic where bounds checks are necessary.
        subscript(safe index: Index) -> Element? {
            indices.contains(index) ? self[index] : nil
        }
    }
#endif
