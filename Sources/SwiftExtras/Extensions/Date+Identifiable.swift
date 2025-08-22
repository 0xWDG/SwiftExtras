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
    /// The identifier of the date.
    ///
    /// This is a hash value of the description to make Date conform to Identifiable.
    public var id: Int {
        return self.description.hashValue
    }
}
#else
extension Date: Identifiable {
    /// The identifier of the date.
    ///
    /// This is a hash value of the description to make Date conform to Identifiable.
    public var id: Int {
        return self.description.hashValue
    }
}
#endif
