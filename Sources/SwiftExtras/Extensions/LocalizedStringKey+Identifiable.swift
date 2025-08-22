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
extension LocalizedStringKey: @retroactive Identifiable {
    /// The identifier of the localized string key.
    ///
    /// This is a random hash value to make LocalizedStringKey conform to Identifiable.
    public var id: Int {
        return self.stringKey?.hashValue ?? UUID().hashValue
    }
}
#else
extension LocalizedStringKey: Identifiable {
    /// The identifier of the localized string key.
    ///
    /// This is a random hash value to make LocalizedStringKey conform to Identifiable.
    public var id: Int {
        return self.stringKey?.hashValue ?? UUID().hashValue
    }
}
#endif
#endif
