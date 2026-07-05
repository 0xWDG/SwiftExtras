//
//  AnyCodable.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

/// A type-erased wrapper for any `Codable` value,
/// allowing it to be encoded and decoded without knowing its concrete type at compile time.
public struct AnyCodable: Codable, @unchecked Sendable {
    public let value: (any Sendable)?
    private var mirror: Mirror

    /// Initializes an `AnyCodable` instance from any `Sendable` value.
    /// - Parameter value: The `Sendable` value to wrap.
    public init<T: Sendable>(_ value: T?) {
        if let value = value as? AnyCodable {
            self = value
        } else {
            self.value = value
            self.mirror = value.customMirror
        }
    }

    /// Initializes an `AnyCodable` instance from a decoder.
    /// - Parameter decoder: The decoder to read from.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.init(Self?.none)
        } else if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let uint = try? container.decode(UInt.self) {
            self.init(uint)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([AnyCodable].self) {
            self.init(array.map { $0.value })
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.init(dictionary.mapValues { $0.value })
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Value cannot be decoded")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case nil:
            try container.encodeNil()
        case let value as [(any Sendable)?]:
            try container.encode(value.map { AnyCodable($0) })
        case let value as [String: (any Sendable)?]:
            try container.encode(value.mapValues { AnyCodable($0) })
        case let value as any Encodable:
            try container.encode(value)
        default:
            let context = EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Value cannot be encoded"
            )
            throw EncodingError.invalidValue(value as Any, context)
        }
    }
}

extension AnyCodable: CustomReflectable {
    /// Returns a mirror that reflects the underlying value of the `AnyCodable` instance.
    public var customMirror: Mirror {
        mirror
    }
}
