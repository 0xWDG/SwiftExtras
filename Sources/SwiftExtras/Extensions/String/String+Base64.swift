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

extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {
            print("Unable to decode base64 string \"\(self)\"")
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func base64UrlDecode() -> String? {
        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
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
