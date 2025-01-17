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
public extension UserDefaults {
    /// Subscript from UserDefaults (Any)
    /// - Parameter key: The key to search/update
    /// - Returns: The object
    subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }

    /// Subscript from UserDefaults (Bool)
    /// - Parameter key: The key to search/update
    /// - Returns: The boolean
    subscript(key: String) -> Bool {
        get {
            return bool(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }

    /// Remove all the keys and their values stored in the user's defaults database.
    func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
}
#endif
