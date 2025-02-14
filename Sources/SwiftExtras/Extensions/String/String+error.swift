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

public extension String {
    /// Sometimes you just want to throw an arbitrary error message.
    /// This extension adds `LocalizedError` conformance to `String` in order to allow that.
    var errorDescription: String? { self }

    /// Sometimes you just want to throw an arbitrary error message.
    /// This extension adds `LocalizedError` conformance to `String` in order to allow that.
    var failureReason: String? { self }

}

#if swift(>=6.0)
extension String: @retroactive LocalizedError { }
#else
extension String: LocalizedError { }
#endif
