//
//  ShakeEffect.swift
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

/// A modifier that applies a shake animation to a view when triggered.
public struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakes: Int = 3
    /// The animation progress used to calculate the horizontal offset.
    public var animatableData: CGFloat

    /// Creates a shake effect at the specified animation progress.
    /// - Parameter animatableData: The animation progress used to calculate the shake offset.
    public init(animatableData: CGFloat) {
        self.animatableData = animatableData
    }

    /// Returns the horizontal translation for the current animation progress.
    ///
    /// - Parameter size: The size of the modified view.
    /// - Returns: A projection transform that applies the shake offset.
    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * CGFloat(shakes)),
                y: 0
            )
        )
    }
}

/// A View extension to apply the shake effect.
public extension View {
    /// Applies a shake effect to the view.
    /// - Parameter times: The number of times the view should shake.
    /// - Returns: A view with the shake effect applied.
    func shake(_ times: CGFloat) -> some View {
        modifier(ShakeEffect(animatableData: times))
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Text("Hello World!")
        .shake(10)
}
#endif
#endif
