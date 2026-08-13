//
//  String+Split.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

public extension String {
    /// Splits the string into groups containing at most the given number of characters.
    ///
    /// The final group can contain fewer characters than `groupSize`. An empty
    /// string produces an empty array.
    ///
    /// - Parameter groupSize: The maximum number of characters in each group.
    ///   This value must be greater than zero.
    /// - Returns: The string divided into groups, while preserving character boundaries.
    /// - Precondition: `groupSize` is greater than zero.
    ///
    /// ```swift
    /// "SwiftExtras".split(every: 5) // ["Swift", "Extra", "s"]
    /// ```
    func split(every groupSize: Int) -> [String] {
        precondition(groupSize > 0, "The group size must be greater than zero.")

        var groups: [String] = []
        var groupStart = startIndex

        while groupStart < endIndex {
            let groupEnd = index(
                groupStart,
                offsetBy: groupSize,
                limitedBy: endIndex
            ) ?? endIndex

            groups.append(String(self[groupStart..<groupEnd]))
            groupStart = groupEnd
        }

        return groups
    }
}
