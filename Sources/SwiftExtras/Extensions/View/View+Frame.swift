//
//  View+Frame.swift
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
    /// Set a frame size (HxB)
    ///
    /// - Parameter size: The size to set for both width and height.
    /// - Returns: self
    public func frame(size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }

    /// Set a frame size (HxB)
    ///
    /// - Parameter size: The size to set for both width and height.
    /// - Returns: self
    public func frame(size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }

    /// Set a max frame size (HxB)
    ///
    /// - Parameter maxSize: The max size to set for both width and height.
    /// - Returns: self
    public func frame(maxSize: CGFloat) -> some View {
        self.frame(maxWidth: maxSize, maxHeight: maxSize)
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Square Frames") {
    HStack {
        Color.blue
            .frame(size: 64)
            .accessibilityLabel("64 point blue square")

        Color.purple
            .frame(size: CGSize(width: 96, height: 64))
            .accessibilityLabel("Purple rectangle")

        Image(systemName: "swift")
            .frame(maxSize: 80)
            .accessibilityLabel("Swift")
    }
    .padding()
}
#endif
#endif
