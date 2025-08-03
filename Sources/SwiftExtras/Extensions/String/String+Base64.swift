//
//  String+Base64.swift
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
    /// Base64 encode
    ///
    /// Encode the string to base64
    ///
    /// - Returns: Encoded string
    func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }

    /// Base64 decode
    ///
    /// Decode the base64 string
    ///
    /// - Returns: Decoded string
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {
            print("Unable to decode base64 string \"\(self)\"")
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    /// Base64 (url) decode
    ///
    /// Decode the base64 (url) string
    ///
    /// - Returns: Decoded string
    func base64UrlDecode() -> String? {
        var base64 = replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 += padding
        }
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            print("Unable to decode base64UrlDecode string \"\(self)\"")
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
