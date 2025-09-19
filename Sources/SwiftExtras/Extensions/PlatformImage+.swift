//
//  NotificationName+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-19-11.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

extension PlatformImage {
    /// Converts the `PlatformImage` to PNG image data.
    /// - Returns: The PNG representation of the image as `Data`, or `nil` if the conversion fails.
    public func toImageData() -> Data? {
#if os(iOS) || os(tvOS) || os(visionOS)
        return self.pngData()
#elseif os(macOS)
        guard let tiffData = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return nil
        }
        return pngData
#else
        return nil
#endif
    }
}

#if os(iOS) || os(tvOS) || os(visionOS) || os(macOS)
extension Image {
    /// Converts a SwiftUI `Image` to PNG image data.
    /// - Returns: The PNG representation of the image as `Data`, or `nil` if the conversion fails.
    @MainActor
    public func toImageData() -> Data? {
        return self.asNativeImage?.toImageData()
    }
}
#endif
#endif
