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

extension String {
    /// Readable string from a URL string.
    ///
    ///        "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    public var urlDecoded: String {
        return removingPercentEncoding ?? self
    }

    /// URL escaped string.
    ///
    ///        "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    public var urlEncoded: String {
        guard let encodedString = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return self
        }

        return encodedString
    }

    /// Encode the string for `x-www-form-urlencoded`.
    ///
    /// This uses `urlEncoded()` then replaces `+` with `%2B`.
    func formEncoded() -> String? {
        self.urlEncoded
            .replacingOccurrences(of: "+", with: "%2B")
    }
}
