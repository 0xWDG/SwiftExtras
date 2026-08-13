//
//  DynamicJSON.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

/// A dynamically accessible JSON value.
@dynamicMemberLookup
public enum JSON {
    /// A JSON object.
    case dictionary([String: JSON])

    /// A JSON array.
    case array([JSON])

    /// A JSON string.
    case string(String)

    /// A JSON number.
    case number(NSNumber)

    /// A JSON Boolean.
    case bool(Bool)

    /// A JSON null value.
    case null

    /// Returns the value at an array index, or `nil` for a non-array or invalid index.
    public subscript(index: Int) -> JSON? {
        guard case .array(let values) = self, values.indices.contains(index) else {
            return nil
        }
        return values[index]
    }

    /// Returns the value for an object key, or `nil` for a non-object or missing key.
    public subscript(key: String) -> JSON? {
        guard case .dictionary(let values) = self else { return nil }
        return values[key]
    }

    /// Returns the value for an object key using dynamic-member syntax.
    public subscript(dynamicMember member: String) -> JSON? {
        self[member]
    }

    /// Creates a JSON value by parsing data.
    ///
    /// - Parameters:
    ///   - data: Data containing JSON.
    ///   - options: Options used by `JSONSerialization` while reading.
    /// - Throws: A parsing error when the data does not contain valid JSON.
    public init(data: Data, options: JSONSerialization.ReadingOptions = []) throws {
        self.init(try JSONSerialization.jsonObject(with: data, options: options))
    }

    /// Creates a JSON value from a Foundation JSON object.
    ///
    /// Unsupported values become ``null``. Passing `Data` attempts to parse the
    /// data as JSON, including top-level fragments.
    public init(_ object: Any) {
        switch object {
        case let data as Data:
            self = (try? JSON(data: data, options: .fragmentsAllowed)) ?? .null
        case let dictionary as [String: Any]:
            self = .dictionary(dictionary.mapValues(JSON.init))
        case let array as [Any]:
            self = .array(array.map(JSON.init))
        case let string as String:
            self = .string(string)
        case let bool as Bool:
            self = .bool(bool)
        case let number as NSNumber:
            self = .number(number)
        default:
            self = .null
        }
    }

    /// The object value, when this is a JSON object.
    public var dictionary: [String: JSON]? {
        guard case .dictionary(let value) = self else { return nil }
        return value
    }

    /// The array value, when this is a JSON array.
    public var array: [JSON]? {
        guard case .array(let value) = self else { return nil }
        return value
    }

    /// A string representation for string, Boolean, and number values.
    public var string: String? {
        switch self {
        case .string(let value): value
        case .bool(let value): value ? "true" : "false"
        case .number(let value): value.stringValue
        default: nil
        }
    }

    /// A number representation for number, Boolean, and numeric string values.
    public var number: NSNumber? {
        switch self {
        case .number(let value): value
        case .bool(let value): NSNumber(value: value)
        case .string(let value): Double(value).map(NSNumber.init(value:))
        default: nil
        }
    }

    /// The value converted to `Double`, when possible.
    public var double: Double? { number?.doubleValue }

    /// The value converted to `Int`, when possible.
    public var int: Int? { number?.intValue }

    /// A Boolean representation for Boolean, number, and recognized string values.
    public var bool: Bool? {
        switch self {
        case .bool(let value):
            value
        case .number(let value):
            value.boolValue
        case .string(let value):
            if ["true", "t", "yes", "y", "1"].contains(where: {
                value.caseInsensitiveCompare($0) == .orderedSame
            }) {
                true
            } else if ["false", "f", "no", "n", "0"].contains(where: {
                value.caseInsensitiveCompare($0) == .orderedSame
            }) {
                false
            } else {
                nil
            }
        default:
            nil
        }
    }

    /// The Foundation object represented by this JSON value.
    public var object: Any {
        switch self {
        case .dictionary(let value): value.mapValues(\.object)
        case .array(let value): value.map(\.object)
        case .string(let value): value
        case .number(let value): value
        case .bool(let value): value
        case .null: NSNull()
        }
    }

    /// Serializes the value to JSON data.
    ///
    /// Top-level scalar values are supported automatically.
    /// - Parameter options: Options used by `JSONSerialization` while writing.
    /// - Returns: Serialized data, or empty data if serialization fails.
    public func data(options: JSONSerialization.WritingOptions = []) -> Data {
        (try? JSONSerialization.data(
            withJSONObject: object,
            options: options.union(.fragmentsAllowed)
        )) ?? Data()
    }
}
