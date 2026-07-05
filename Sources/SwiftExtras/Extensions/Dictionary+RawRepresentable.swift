//
//  Dictionary+RawRepresentable.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS) || os(visionOS)
// MARK: - Dictionary+RawRepresentable
/// This extension allows a Dictionary with String keys and String values to be represented as a raw String value.
/// It provides an initializer to create a Dictionary from a raw String and a computed property \
/// to convert the Dictionary back to a raw String.
///
/// Example usage:
/// @AppStorage("data") private var data: [String: String] = [:]
extension Dictionary: @retroactive RawRepresentable where Key == String, Value == String {
    /// Initializes a Dictionary from a raw String value.
    /// - Parameter rawValue: The raw String value representing the Dictionary.
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),  // convert from String to Data
              let result = try? JSONDecoder().decode(
                [String: String].self,
                from: data
            )
        else {
            return nil
        }
        self = result
    }

    /// Converts the Dictionary to a raw String value.
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),   // data is  Data type
              let result = String(data: data, encoding: .utf8) // coerce NSData to String
        else {
            return "[:]"  // empty Dictionary respresented as String
        }
        return result
    }
}
#endif
