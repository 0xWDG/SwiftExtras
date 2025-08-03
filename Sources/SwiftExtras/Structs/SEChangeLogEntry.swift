//
//  SEChangeLogEntry.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

/// SwiftExtras Change Log Entry
public struct SEChangeLogEntry: Identifiable {
    /// The unique identifier for this entry.
    public var id: String {
        version
    }

    /// The version number for this entry.
    public var version: String

    /// The changelog for this entry.
    public var text: String

    #if canImport(SwiftUI)
    /// Initialize a new change log entry.
    ///
    /// - Parameters:
    ///   - version: The version number for this entry.
    ///   - text: The changelog for this entry.
    public init(version: String, text: LocalizedStringKey) {
        self.version = version
        self.text = text.stringValue
    }
    #else
    /// Initialize a new change log entry.
    ///
    /// - Parameters:
    ///   - version: The version number for this entry.
    ///   - text: The changelog for this entry.
    public init(version: String, text: String) {
        self.version = version
        self.text = text
    }
    #endif
}
