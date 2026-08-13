//
//  Shimmer.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-05.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A view modifier that applies an animated shimmer to a view.
public struct Shimmer: ViewModifier {
    /// The way the animated gradient is combined with the content.
    public enum Mode {
        /// Masks the content with the gradient.
        case mask

        /// Overlays the gradient using a blend mode.
        case overlay(blendMode: BlendMode = .sourceAtop)

        /// Places the gradient behind the content.
        case background
    }

    /// The default repeating shimmer animation.
    public static let defaultAnimation = Animation
        .linear(duration: 1.5)
        .delay(0.25)
        .repeatForever(autoreverses: false)

    /// The default translucent-to-opaque shimmer gradient.
    public static let defaultGradient = Gradient(colors: [
        .black.opacity(0.3),
        .black,
        .black.opacity(0.3)
    ])

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var isInitialState = true

    private let animation: Animation
    private let gradient: Gradient
    private let minimumPoint: CGFloat
    private let maximumPoint: CGFloat
    private let mode: Mode

    /// Creates a shimmer modifier.
    ///
    /// - Parameters:
    ///   - animation: The animation used for each shimmer cycle.
    ///   - gradient: The gradient moved across the content.
    ///   - bandSize: The width of the animated band as a fraction of the view.
    ///   - mode: The way the gradient is combined with the content.
    public init(
        animation: Animation = Self.defaultAnimation,
        gradient: Gradient = Self.defaultGradient,
        bandSize: CGFloat = 0.3,
        mode: Mode = .mask
    ) {
        self.animation = animation
        self.gradient = gradient
        self.minimumPoint = -bandSize
        self.maximumPoint = 1 + bandSize
        self.mode = mode
    }

    private var startPoint: UnitPoint {
        switch layoutDirection {
        case .rightToLeft:
            if isInitialState {
                return UnitPoint(x: maximumPoint, y: minimumPoint)
            }
            return UnitPoint(x: 0, y: 1)
        case .leftToRight:
            if isInitialState {
                return UnitPoint(x: minimumPoint, y: minimumPoint)
            }
            return UnitPoint(x: 1, y: 1)
        @unknown default:
            if isInitialState {
                return UnitPoint(x: minimumPoint, y: minimumPoint)
            }
            return UnitPoint(x: 1, y: 1)
        }
    }

    private var endPoint: UnitPoint {
        switch layoutDirection {
        case .rightToLeft:
            if isInitialState {
                return UnitPoint(x: 1, y: 0)
            }
            return UnitPoint(x: minimumPoint, y: maximumPoint)
        case .leftToRight:
            if isInitialState {
                return UnitPoint(x: 0, y: 0)
            }
            return UnitPoint(x: maximumPoint, y: maximumPoint)
        @unknown default:
            if isInitialState {
                return UnitPoint(x: 0, y: 0)
            }
            return UnitPoint(x: maximumPoint, y: maximumPoint)
        }
    }

    /// Applies the shimmer effect to the supplied content.
    @ViewBuilder
    public func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            applyingGradient(to: content)
                .animation(animation, value: isInitialState)
                .task {
                    await Task.yield()
                    isInitialState = false
                }
        }
    }

    /// Combines the configured gradient with content using ``Mode``.
    ///
    /// - Parameter content: The content to which the gradient is applied.
    /// - Returns: The gradient-enhanced content.
    @ViewBuilder
    public func applyingGradient(to content: Content) -> some View {
        let linearGradient = LinearGradient(
            gradient: gradient,
            startPoint: startPoint,
            endPoint: endPoint
        )

        switch mode {
        case .mask:
            content.mask(linearGradient)
        case .overlay(let blendMode):
            content.overlay(linearGradient.blendMode(blendMode))
        case .background:
            content.background(linearGradient)
        }
    }
}

public extension View {
    /// Applies the default animated shimmer to the view.
    func shimmer() -> some View {
        shimmering()
    }

    /// Applies a configurable animated shimmer to the view.
    ///
    /// Reduce Motion disables the visual effect and returns the content unchanged.
    /// - Parameters:
    ///   - active: Whether the effect is enabled.
    ///   - animation: The animation used for each shimmer cycle.
    ///   - gradient: The gradient moved across the content.
    ///   - bandSize: The width of the animated band as a fraction of the view.
    ///   - mode: The way the gradient is combined with the content.
    @ViewBuilder
    func shimmering(
        active: Bool = true,
        animation: Animation = Shimmer.defaultAnimation,
        gradient: Gradient = Shimmer.defaultGradient,
        bandSize: CGFloat = 0.3,
        mode: Shimmer.Mode = .mask
    ) -> some View {
        if active {
            modifier(Shimmer(
                animation: animation,
                gradient: gradient,
                bandSize: bandSize,
                mode: mode
            ))
        } else {
            self
        }
    }

    /// Applies a duration-based animated shimmer to the view.
    @available(*, deprecated, message: "Use shimmering(active:animation:gradient:bandSize:mode:) instead.")
    func shimmering(
        active: Bool = true,
        duration: Double,
        bounce: Bool = false,
        delay: Double = 0.25
    ) -> some View {
        shimmering(
            active: active,
            animation: .linear(duration: duration)
                .delay(delay)
                .repeatForever(autoreverses: bounce)
        )
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    VStack(alignment: .leading, spacing: 12) {
        RoundedRectangle(cornerRadius: 8).frame(width: 220, height: 24)
        RoundedRectangle(cornerRadius: 8).frame(width: 180, height: 24)
        RoundedRectangle(cornerRadius: 8).frame(width: 140, height: 24)
    }
    .foregroundStyle(.secondary)
    .padding()
    .shimmering(mode: .overlay())
}
#endif
#endif
