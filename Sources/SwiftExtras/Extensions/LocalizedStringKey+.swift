//
//  LocalizedStringKey+.swift
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

    extension LocalizedStringKey {
        /// The string key of the LocalizedStringKey
        var stringKey: String? {
            Mirror(reflecting: self)
                .children
                .first(where: { $0.label == "key" })?
                .value as? String
        }

        /// The string value of the LocalizedStringKey
        public var stringValue: String {
            NSLocalizedString(stringKey ?? "Unknown", comment: "None")
        }
    }
#endif
