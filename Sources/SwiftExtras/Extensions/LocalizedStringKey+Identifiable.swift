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
    public typealias ID = Int // swiftlint:disable:this type_name

    /// The identifier of the color.
    ///
    /// This is a random hash value to make Color conform to Identifiable.
    public var id: Int {
        stringKey?.hashValue ?? UUID().hashValue
    }
}
#else
extension LocalizedStringKey: Identifiable {
    public typealias ID = Int // swiftlint:disable:this type_name

    /// The identifier of the color.
    ///
    /// This is a random hash value to make Color conform to Identifiable.
    public var id: Int {
        stringKey?.hashValue ?? UUID().hashValue
    }
}
#endif
#endif
