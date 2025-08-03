//
//  View+render.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

public extension View {
    /// Render the current view as a ``PlatformImage``
    /// Usually you would pass  `@Environment(\.displayScale) var displayScale`
    ///
    /// - Parameter displayScale: The scale of the display. Defaults to 1.0
    /// - Returns: A ``PlatformImage`` of the current view
    @MainActor
    func render(scale displayScale: CGFloat = 1.0) -> PlatformImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = displayScale
        #if canImport(UIKit)
        return renderer.uiImage
        #elseif canImport(AppKit)
        return renderer.nsImage
        #else
        // Unsupported
        return nil
        #endif
    }
}
#endif
