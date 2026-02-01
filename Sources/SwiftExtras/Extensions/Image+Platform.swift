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

    /// Create an Image from a PlatformImage
    ///
    /// This initializer is available on all platforms that support SwiftUI.
    ///
    /// - Parameter data: The image to create the image from
    public init?(data: Data) {
#if os(macOS)
        guard let native = PlatformImage(data: data) else { return nil }
        self.init(nsImage: native)
#else
        guard let native = PlatformImage(data: data) else { return nil }
        self.init(uiImage: native)
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

    /// Make the current image squared
    ///
    /// Makes the current image squared by fitting it into a square frame.
    ///
    /// - Returns: The squared image view
    @warn_unqualified_access
    public func square() -> some View {
        Rectangle()
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                self
                    .resizable()
                    .scaledToFill()
            )
            .clipShape(Rectangle())
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

