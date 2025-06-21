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
extension String: @retroactive Identifiable {
    public typealias ID = Int // swiftlint:disable:this type_name

    /// The identifier of the string.
    ///
    /// This is a hash value of the string to make String conform to Identifiable.
    public var id: Int {
        return hash
    }
}
#else
extension String: Identifiable {
    public typealias ID = Int // swiftlint:disable:this type_name

    /// The identifier of the string.
    ///
    /// This is a hash value of the string to make String conform to Identifiable.
    public var id: Int {
        return hash
    }
}
#endif
