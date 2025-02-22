//
//  UserDefaults+subscript.swift
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
extension UserDefaults {
    /// Subscript from UserDefaults (Any)
    ///
    /// This allows you to use the `UserDefaults` as a dictionary.
    ///
    /// - Parameter key: The key to search/update
    /// - Returns: The object
    public subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }

    /// Subscript from UserDefaults (Bool)
    ///
    /// This allows you to use the `UserDefaults` as a dictionary.
    ///
    /// - Parameter key: The key to search/update
    /// - Returns: The boolean
    public subscript(key: String) -> Bool {
        get {
            return bool(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }

    /// Remove all the keys and their values stored in the user's defaults database.
    public func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
}
#endif
