//
//  String+LocalizedStringKey.swift
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

extension String {
    /// Initialize a `String` from a `LocalizedStringKey`.
    ///
    /// - Parameter string: The `LocalizedStringKey` to convert to a `String`.
    public init(_ string: LocalizedStringKey) {
        self.init(
            NSLocalizedString(
                Mirror(reflecting: string)
                    .children
                    .first(where: { $0.label == "key" })?
                    .value as? String ?? "Unknown",
                comment: "None"
            )
        )
    }
}
#endif
