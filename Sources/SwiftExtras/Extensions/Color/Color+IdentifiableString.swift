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

#if swift(>=6.0)
extension Color: @retroactive Identifiable {
    public typealias ID = Int // swiftlint:disable:this type_name
    public var id: Int {
        return UUID().hashValue
    }
}
#else
extension Color: Identifiable {
    public typealias ID = Int // swiftlint:disable:this type_name
    public var id: Int {
        return UUID().hashValue
    }
}
#endif
#endif
