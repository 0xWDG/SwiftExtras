//
//  LocalizedStringKey+Identifiable.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-03-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

#if swift(>=5.9)
/// Declares the `Identifiable` conformance for `LocalizedStringKey`.
///
/// The conformance supplies the protocol behavior implemented by the declarations in this scope.
extension LocalizedStringKey: @retroactive Identifiable {
    /// The identifier of the localized string key.
    ///
    /// This is a random hash value to make LocalizedStringKey conform to Identifiable.
    public var id: Int {
        self.stringKey?.hashValue ?? UUID().hashValue
    }
}
#else
/// Declares the `Identifiable` conformance for `LocalizedStringKey`.
///
/// The conformance supplies the protocol behavior implemented by the declarations in this scope.
extension LocalizedStringKey: Identifiable {
    /// The identifier of the localized string key.
    ///
    /// This is a random hash value to make LocalizedStringKey conform to Identifiable.
    public var id: Int {
        self.stringKey?.hashValue ?? UUID().hashValue
    }
}
#endif
#endif
