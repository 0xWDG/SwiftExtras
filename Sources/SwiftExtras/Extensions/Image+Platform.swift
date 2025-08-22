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

    /// Get the platform native image
    /// 
    /// This property is available on all platforms that support SwiftUI.
    ///
    /// - Returns: The platform native image, or nil if the image could not be rendered
    @MainActor
    public var asNativeImage: PlatformImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = 1.0
        #if os(macOS)
        return renderer.nsImage
        #else
        return renderer.uiImage
        #endif
    }
}

#if swift(>=5.9)
extension PlatformImage: @retroactive Identifiable {
    /// The identifier of the image.
    ///
    /// This is a random hash value to make PlatformImage conform to Identifiable.
    public var id: Int {
        return UUID().hashValue
    }
}
#else
extension PlatformImage: Identifiable {
    /// The identifier of the image.
    ///
    /// This is a random hash value to make PlatformImage conform to Identifiable.
    public var id: Int {
        return UUID().hashValue
    }
}
#endif
#endif
