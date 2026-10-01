//
//  String+error.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

/// Adds error-construction conveniences to `String`.
///
/// These APIs make a string suitable for use where an `Error` or localized error description is required.
public extension String {
    /// Sometimes you just want to throw an arbitrary error message.
    /// This extension adds `LocalizedError` conformance to `String` in order to allow that.
    var errorDescription: String? { self }

    /// Sometimes you just want to throw an arbitrary error message.
    /// This extension adds `LocalizedError` conformance to `String` in order to allow that.
    var failureReason: String? { self }

}

#if swift(>=5.9)
/// Declares `String` as a localized error value on Swift 5.9 and later.
///
/// The conformance uses the error description supplied by this file's string error utilities.
extension String: @retroactive LocalizedError { }
#else
/// Declares `String` as a localized error value on toolchains before Swift 5.9.
///
/// The conformance matches the modern implementation while avoiding the unavailable retroactive-conformance
/// spelling on older Swift versions.
extension String: LocalizedError { }
#endif
