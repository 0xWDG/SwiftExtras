//
//  Image+Platform.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && !os(watchOS)
import SwiftUI

extension Image {
    /// Create an Image from a PlatformImage
    ///
    /// This initializer is available on all platforms that support SwiftUI.
    ///
    /// - Parameter platformImage: The PlatformImage to create the Image from
    public init(platformImage: PlatformImage) {
        #if os(macOS)
        self.init(nsImage: platformImage)
        #else
        self.init(uiImage: platformImage)
        #endif
    }
}

#if swift(>=5.9)
extension PlatformImage: @retroactive Identifiable {
    public typealias ID = Int // swiftlint:disable:this type_name
    /// The identifier of the color.
    ///
    /// This is a random hash value to make Color conform to Identifiable.
    public var id: Int {
        return UUID().hashValue
    }
}
#else
extension PlatformImage: Identifiable {
    public typealias ID = Int // swiftlint:disable:this type_name
    /// The identifier of the color.
    ///
    /// This is a random hash value to make Color conform to Identifiable.
    public var id: Int {
        return UUID().hashValue
    }
}
#endif
#endif
