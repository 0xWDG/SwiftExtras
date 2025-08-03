//
//  String+url.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension String {
    /// Readable string from a URL string.
    ///
    ///        "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    var urlDecoded: String {
        removingPercentEncoding ?? self
    }

    /// URL escaped string.
    ///
    ///        "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    var urlEncoded: String {
        guard let encodedString = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return self
        }

        return encodedString
    }

    /// Encode the string for `x-www-form-urlencoded`.
    ///
    /// This uses `urlEncoded()` then replaces `+` with `%2B`.
    var formEncoded: String {
        urlEncoded
            .replacingOccurrences(of: "+", with: "%2B")
    }
}
