//
//  UbiquitousStorage.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) || os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
import SwiftUI

extension Notification.Name {
    /// Notification posted when a value in `UbiquitousStorage` changes.
    public static let ubiquitousStorageDidChange = Notification.Name("UbiquitousStorage.didChange")
}

private enum UbiquitousStorageNotificationUserInfoKey {
    static let key = "key"
}

private func notifyUbiquitousStorageChange(forKey key: String) {
    NotificationCenter.default.post(
        name: .ubiquitousStorageDidChange,
        object: nil,
        userInfo: [UbiquitousStorageNotificationUserInfoKey.key: key]
    )
}

/// Selects the persistence domain used by ``UbiquitousStorage``.
///
/// Use ``iCloud`` for the default cross-device key-value store. Use
/// ``appGroup(_:)`` when an app and its extensions need to share a value on
/// the current device through the same app-group suite.
public enum UbiquitousStorageBackend: Sendable, Equatable {
    /// Stores the value in `NSUbiquitousKeyValueStore.default`.
    case iCloud

    /// Stores the value in the `UserDefaults` suite identified by an app-group name.
    case appGroup(String)
}

/// A property wrapper that stores values in iCloud's key-value store (`NSUbiquitousKeyValueStore`).
///
/// Values are automatically synchronized across all devices signed into the same iCloud account
/// and are accessible from both the main app and extensions.
///
/// Supported types:
/// - `Bool`
/// - `Int`
/// - `Double`
/// - `String`
/// - `String?`
/// - `Color` (via `RawRepresentable`)
@propertyWrapper
public struct UbiquitousStorage<Value> {
    fileprivate let key: String
    fileprivate let defaultValue: Value
    fileprivate let reader: () -> Value
    fileprivate let writer: (Value) -> Void

    /// Initializes a new instance of `UbiquitousStorage`.
    ///
    /// - Parameters:
    ///   - key: The key used to store the value in iCloud's key-value store.
    ///   - defaultValue: The default value to return when the key is absent.
    ///   - reader: A closure that reads the value from iCloud's key-value store.
    ///   - writer: A closure that writes the value to iCloud's key-value store
    public init(
        key: String,
        defaultValue: Value,
        reader: @escaping () -> Value,
        writer: @escaping (Value) -> Void
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.reader = reader
        self.writer = writer
    }

    /// The value stored in iCloud's key-value store.
    public var wrappedValue: Value {
        get { reader() }
        nonmutating set { writer(newValue) }
    }

    /// A binding to the value stored in iCloud's key-value store.
    public var projectedValue: Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

extension UbiquitousStorage where Value == Bool {
    /// Initializes a new instance of `UbiquitousStorage` for a `Bool` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value to return when the key is absent.
    ///   - key: The key used to store the value in iCloud's key-value store.
    ///   - backend: The store that persists the value. Defaults to iCloud.
    ///
    /// Example usage:
    /// ```swift
    /// @UbiquitousStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false
    /// ```
    public init(
        wrappedValue: Bool,
        _ key: String,
        backend: UbiquitousStorageBackend = .iCloud
    ) {
        switch backend {
        case .iCloud:
            let store = NSUbiquitousKeyValueStore.default
            self.init(
                key: key,
                defaultValue: wrappedValue,
                reader: { store.object(forKey: key) != nil ? store.bool(forKey: key) : wrappedValue },
                writer: {
                    store.set($0, forKey: key)
                    notifyUbiquitousStorageChange(forKey: key)
                }
            )
        case let .appGroup(suiteName):
            let store = UserDefaults(suiteName: suiteName)
            self.init(
                key: key,
                defaultValue: wrappedValue,
                reader: { store?.object(forKey: key) != nil ? store?.bool(forKey: key) ?? wrappedValue : wrappedValue },
                writer: {
                    store?.set($0, forKey: key)
                    notifyUbiquitousStorageChange(forKey: key)
                }
            )
        }
    }
}

extension UbiquitousStorage where Value: RawRepresentable, Value.RawValue == String {
    /// Initializes storage for a string-backed raw-representable value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value to return when the key is absent or invalid.
    ///   - key: The key used to store the raw value in the selected persistence backend.
    ///   - backend: The store that persists the value. Defaults to iCloud.
    public init(
        wrappedValue: Value,
        _ key: String,
        backend: UbiquitousStorageBackend = .iCloud
    ) {
        switch backend {
        case .iCloud:
            let store = NSUbiquitousKeyValueStore.default
            self.init(
                key: key,
                defaultValue: wrappedValue,
                reader: { store.string(forKey: key).flatMap(Value.init(rawValue:)) ?? wrappedValue },
                writer: {
                    store.set($0.rawValue, forKey: key)
                    notifyUbiquitousStorageChange(forKey: key)
                }
            )
        case let .appGroup(suiteName):
            let store = UserDefaults(suiteName: suiteName)
            self.init(
                key: key,
                defaultValue: wrappedValue,
                reader: { store?.string(forKey: key).flatMap(Value.init(rawValue:)) ?? wrappedValue },
                writer: {
                    store?.set($0.rawValue, forKey: key)
                    notifyUbiquitousStorageChange(forKey: key)
                }
            )
        }
    }
}

extension UbiquitousStorage where Value == Int {
    /// Initializes a new instance of `UbiquitousStorage` for an `Int` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value to return when the key is absent.
    ///   - key: The key used to store the value in iCloud's key-value store.
    ///
    /// Example usage:
    /// ```swift
    /// @UbiquitousStorage("launchCount") var launchCount: Int = 0
    /// ```
    public init(wrappedValue: Int, _ key: String) {
        let store = NSUbiquitousKeyValueStore.default
        self.init(
            key: key,
            defaultValue: wrappedValue,
            reader: { store.object(forKey: key) != nil ? Int(store.longLong(forKey: key)) : wrappedValue },
            writer: {
                store.set(Int64($0), forKey: key)
                notifyUbiquitousStorageChange(forKey: key)
            }
        )
    }
}

extension UbiquitousStorage where Value == Double {
    /// Initializes a new instance of `UbiquitousStorage` for a `Double` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value to return when the key is absent.
    ///   - key: The key used to store the value in iCloud's key-value store.
    ///
    /// Example usage:
    /// ```swift
    /// @UbiquitousStorage("volumeLevel") var volumeLevel: Double = 0.5
    /// ```
    public init(wrappedValue: Double, _ key: String) {
        let store = NSUbiquitousKeyValueStore.default
        self.init(
            key: key,
            defaultValue: wrappedValue,
            reader: { store.object(forKey: key) != nil ? store.double(forKey: key) : wrappedValue },
            writer: {
                store.set($0, forKey: key)
                notifyUbiquitousStorageChange(forKey: key)
            }
        )
    }
}

extension UbiquitousStorage where Value == String {
    /// Initializes a new instance of `UbiquitousStorage` for a `String` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value to return when the key is absent.
    ///   - key: The key used to store the value in iCloud's key-value store.
    ///
    /// Example usage:
    /// ```swift
    /// @UbiquitousStorage("username") var username: String = "Guest"
    /// ```
    public init(wrappedValue: String, _ key: String) {
        let store = NSUbiquitousKeyValueStore.default
        self.init(
            key: key,
            defaultValue: wrappedValue,
            reader: { store.string(forKey: key) ?? wrappedValue },
            writer: {
                store.set($0, forKey: key)
                notifyUbiquitousStorageChange(forKey: key)
            }
        )
    }
}

extension UbiquitousStorage where Value == String? {
    /// Initializes a new instance of `UbiquitousStorage` for an optional `String` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value to return when the key is absent.
    ///   - key: The key used to store the value in iCloud's key-value store.
    ///
    /// Example usage:
    /// ```swift
    /// @UbiquitousStorage("nickname") var nickname: String? = nil
    /// ```
    public init(wrappedValue: String?, _ key: String) {
        let store = NSUbiquitousKeyValueStore.default
        self.init(
            key: key,
            defaultValue: wrappedValue,
            reader: { store.string(forKey: key) },
            writer: { value in
                if let value {
                    store.set(value, forKey: key)
                } else {
                    store.removeObject(forKey: key)
                }
                notifyUbiquitousStorageChange(forKey: key)
            }
        )
    }
}

extension UbiquitousStorage where Value == Color {
    /// Initializes a new instance of `UbiquitousStorage` for a `Color` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value to return when the key is absent.
    ///   - key: The key used to store the value in iCloud's key-value store.
    ///
    /// Example usage:
    /// ```swift
    /// @UbiquitousStorage("themeColor") var themeColor: Color = .blue
    /// ```
    public init(wrappedValue: Color, _ key: String) {
        let store = NSUbiquitousKeyValueStore.default
        self.init(
            key: key,
            defaultValue: wrappedValue,
            // Color conforms to RawRepresentable (RawValue == String) on iOS 14+,
            // so it is serialized as its hex-encoded raw value string.
            reader: {
                guard let raw = store.string(forKey: key),
                      let color = Color(rawValue: raw) else { return wrappedValue }
                return color
            },
            writer: { color in
                store.set(color.rawValue, forKey: key)
                notifyUbiquitousStorageChange(forKey: key)
            }
        )
    }
}

extension NSUbiquitousKeyValueStore {
    /// Returns the integer stored for `key`, or `defaultValue` when the key is absent.
    ///
    /// - Parameters:
    ///   - key: The key used to retrieve the value from iCloud's key-value store.
    ///   - defaultValue: The default value to return when the key is absent.
    public func intValue(forKey key: String, default defaultValue: Int) -> Int {
        object(forKey: key) != nil ? Int(longLong(forKey: key)) : defaultValue
    }
}
#endif
