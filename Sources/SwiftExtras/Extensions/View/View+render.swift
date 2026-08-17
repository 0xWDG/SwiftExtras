//
//  View+showError.swift
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

extension View {
    /// Render the current view as a ``PlatformImage``
    /// Usually you would pass  `@Environment(\.displayScale) var displayScale`
    /// 
    /// - Parameter displayScale: The scale of the display. Defaults to 1.0
    /// - Returns: A ``PlatformImage`` of the current view
    @MainActor public func render(scale displayScale: CGFloat = 1.0) -> PlatformImage? {
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

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, *)
#Preview("Rendered View") {
    let source = Label("Rendered", systemImage: "sparkles")
        .font(.title2.bold())
        .foregroundStyle(.white)
        .padding()
        .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 16))
    let renderedImage = source.render()

    VStack(spacing: 16) {
        source

        if let renderedImage {
            Image(platformImage: renderedImage)
                .accessibilityLabel("Image rendered from the source view")
        }
    }
    .padding()
}
#endif
#endif
