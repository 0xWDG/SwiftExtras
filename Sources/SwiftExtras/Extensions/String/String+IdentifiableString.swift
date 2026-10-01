//
//  String+IdentifiableString.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

#if swift(>=5.9)
/// Declares the `Identifiable` conformance for `String`.
///
/// The conformance supplies the protocol behavior implemented by the declarations in this scope.
extension String: @retroactive Identifiable {
    /// The identifier of the string.
    ///
    /// This is a hash value of the string to make String conform to Identifiable.
    public var id: Int {
        hash
    }
}
#else
/// Declares the `Identifiable` conformance for `String`.
///
/// The conformance supplies the protocol behavior implemented by the declarations in this scope.
extension String: Identifiable {
    /// The identifier of the string.
    ///
    /// This is a hash value of the string to make String conform to Identifiable.
    public var id: Int {
        hash
    }
}
#endif
