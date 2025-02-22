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

import SwiftUI

#if canImport(SwiftUI)
/// A modifier that applies a shake animation to a view when triggered.
public struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakes: Int = 3
    public var animatableData: CGFloat

    public init(animatableData: CGFloat) {
        self.animatableData = animatableData
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakes)), y: 0))
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
#endif
