//
//  Date+IdentifiableString.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2024-08-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

#if swift(>=5.9)
extension Date: @retroactive Identifiable {
    public typealias ID = Int // swiftlint:disable:this type_name

    /// The identifier of the string.
    ///
    /// This is a hash value of the string to make String conform to Identifiable.
    public var id: Int {
        return self.description.hashValue
    }
}
#else
extension Date: Identifiable {
    public typealias ID = Int // swiftlint:disable:this type_name

    /// The identifier of the string.
    ///
    /// This is a hash value of the string to make String conform to Identifiable.
    public var id: Int {
        return self.description.hashValue
    }
}
#endif
