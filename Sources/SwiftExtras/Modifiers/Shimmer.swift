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

/// A view modifier that applies a simple animated shimmer to a view.
public struct Shimmer: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var isInitialState = true

    private static let animation = Animation
        .linear(duration: 1.5)
        .delay(0.25)
        .repeatForever(autoreverses: false)

    private var gradient: Gradient {
        Gradient(colors: [
            .black.opacity(reduceMotion ? 1.0 : 0.3),
            .black,
            .black.opacity(reduceMotion ? 1.0 : 0.3)
        ])
    }

    private var startPoint: UnitPoint {
        if reduceMotion {
            return .topLeading
        }

        switch layoutDirection {
        case .rightToLeft:
            return isInitialState ? UnitPoint(x: 1.3, y: -0.3) : UnitPoint(x: 0.0, y: 1.0)
        case .leftToRight:
            return isInitialState ? UnitPoint(x: -0.3, y: -0.3) : UnitPoint(x: 1.0, y: 1.0)
        @unknown default:
            return isInitialState ? UnitPoint(x: -0.3, y: -0.3) : UnitPoint(x: 1.0, y: 1.0)
        }
    }

    private var endPoint: UnitPoint {
        if reduceMotion {
            return .bottomTrailing
        }

        switch layoutDirection {
        case .rightToLeft:
            return isInitialState ? UnitPoint(x: 1.0, y: 0.0) : UnitPoint(x: -0.3, y: 1.3)
        case .leftToRight:
            return isInitialState ? UnitPoint(x: 0.0, y: 0.0) : UnitPoint(x: 1.3, y: 1.3)
        @unknown default:
            return isInitialState ? UnitPoint(x: 0.0, y: 0.0) : UnitPoint(x: 1.3, y: 1.3)
        }
    }

    /// Applies the shimmer effect to the supplied content.
    ///
    /// - Parameter content: The content to animate.
    /// - Returns: The content with a shimmer mask applied.
    public func body(content: Content) -> some View {
        content
            .mask(
                LinearGradient(
                    gradient: gradient,
                    startPoint: startPoint,
                    endPoint: endPoint
                )
            )
            .animation(reduceMotion ? nil : Self.animation, value: isInitialState)
            .onAppear {
                guard !reduceMotion else { return }
                DispatchQueue.main.async {
                    isInitialState = false
                }
            }
    }
}

public extension View {
    /// Applies a simple animated shimmer to the view.
    ///
    /// - Returns: A view with a shimmer effect applied.
    func shimmer() -> some View {
        modifier(Shimmer())
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    VStack(alignment: .leading, spacing: 12) {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: 220, height: 24)

        RoundedRectangle(cornerRadius: 8)
            .frame(width: 180, height: 24)

        RoundedRectangle(cornerRadius: 8)
            .frame(width: 140, height: 24)
    }
    .foregroundStyle(.secondary)
    .padding()
    .shimmer()
}
#endif
#endif
