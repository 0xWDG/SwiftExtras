//
//  PulsatingEffect.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A modifier that applies a pulsating animation effect to a view.
public struct PulsatingEffect: ViewModifier {
    @State private var scale: CGFloat = 1.0

    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .animation(
                Animation
                    .easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true),
                value: scale
            )
            .onAppear {
                scale = 1.2
            }
    }
}

/// A View extension to apply the pulsating effect.
public extension View {
    /// Applies a pulsating effect to the view.
    /// - Returns: A view with the pulsating effect applied.
    func pulsating() -> some View {
        modifier(PulsatingEffect())
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Button("Hello World!") {}
        .pulsating()
}
#endif
#endif
