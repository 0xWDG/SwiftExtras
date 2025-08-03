//
//  Error+errorCode.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-07-19.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension Error {
    /// Returns the error code of the error if it is an NSError.
    /// If the error is not an NSError, this will return nil.
    /// This is useful for extracting error codes from errors that conform to
    /// the NSError protocol.
    ///
    /// Example usage:
    /// ```swift
    /// let error: Error = NSError(domain: "nl.wesleydegroot.SwiftExtras", code:
    /// 404, userInfo: nil)
    /// if let code = error.errorCode {
    ///     print("Error code: \(code)") // Output: Error code: 404
    /// }
    /// ```
    /// - Returns: The error code if the error is an NSError, otherwise nil.
    var errorCode: Int? {
        (self as NSError).code
    }
}
