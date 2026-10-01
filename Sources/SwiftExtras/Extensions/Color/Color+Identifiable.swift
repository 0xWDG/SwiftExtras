//
//  Color+Identifiable.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

#if swift(>=5.9)
/// Declares the `Identifiable` conformance for `Color`.
///
/// The conformance supplies the protocol behavior implemented by the declarations in this scope.
extension Color: @retroactive Identifiable {
    /// The identifier of the color.
    ///
    /// This is a random hash value to make Color conform to Identifiable.
    public var id: Int {
        UUID().hashValue
    }
}
#else
/// Declares the `Identifiable` conformance for `Color`.
///
/// The conformance supplies the protocol behavior implemented by the declarations in this scope.
extension Color: Identifiable {
    /// The identifier of the color.
    ///
    /// This is a random hash value to make Color conform to Identifiable.
    public var id: Int {
        UUID().hashValue
    }
}
#endif
#endif
