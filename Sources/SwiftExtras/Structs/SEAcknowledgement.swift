//
//  SEAcknowledgement.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

/// SwiftExtras Acknoledgement Entry
///
/// Acknowledgement entry for use in the `SEAcknowledgementView`.
public struct SEAcknowledgement: Identifiable, Hashable {
    /// The unique identifier for this entry.
    public var id: String {
        name
    }

    /// The name of the framework.
    public var name: String

    /// The copyright holder.
    public var copyright: String

    /// The licence under which the framework is distributed.
    public var licence: String

    /// The URL to the framework's website/repo.
    public var url: String?

    /// Initialize a new acknowledgement entry.
    ///
    /// - Parameters:
    ///   - name: The name of the framework.
    ///   - copyright: The copyright holder.
    ///   - licence: The licence under which the framework is distributed.
    ///   - url: The URL to the framework's website/repo.
    public init(
        name: String,
        copyright: String,
        licence: String,
        url: String? = nil
    ) {
        self.name = name
        self.copyright = copyright
        self.licence = licence
        self.url = url
    }
}
