//
//  Color+IdentifiableString.swift
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
extension Color: @retroactive Identifiable {
    /// The identifier of the color.
    ///
    /// This is a random hash value to make Color conform to Identifiable.
    public var id: Int {
        return UUID().hashValue
    }
}
#else
extension Color: Identifiable {
    /// The identifier of the color.
    ///
    /// This is a random hash value to make Color conform to Identifiable.
    public var id: Int {
        return UUID().hashValue
    }
}
#endif
#endif
