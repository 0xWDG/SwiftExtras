//
//  View+onLandscape.swift
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

extension View {
    /// Applies a transform in a compact vertical size class.
    ///
    /// A compact vertical size class usually corresponds to a landscape
    /// iPhone layout. The size class is read from the view's environment, so
    /// the result also adapts correctly in split views, sheets, and previews.
    /// Use this view modifier after your element. For example:
    ///
    ///     Text("I will be hidden, if we are in landscape mode")
    ///       .onLandscape {
    ///         // Hide in a compact vertical size class.
    ///         $0.hidden()
    ///       }
    ///
    /// - Returns: The transformed view in a compact vertical size class;
    ///   otherwise, the original view.
    public func onLandscape<Transform: View>(transform: @escaping (Self) -> Transform) -> some View {
        VerticalSizeClassTransform(
            content: self,
            targetSizeClass: .compact,
            transform: transform
        )
    }

    /// Applies a transform in a regular vertical size class.
    ///
    /// A regular vertical size class usually corresponds to a portrait iPhone
    /// layout. The size class is read from the view's environment, so the
    /// result also adapts correctly in split views, sheets, and previews.
    /// Use this view modifier after your element. For example:
    ///
    ///     Text("I will be hidden, if we are in portrait mode")
    ///       .onPortrait {
    ///         // Hide in a regular vertical size class.
    ///         $0.hidden()
    ///       }
    ///
    /// - Returns: The transformed view in a regular vertical size class;
    ///   otherwise, the original view.
    public func onPortrait<Transform: View>(transform: @escaping (Self) -> Transform) -> some View {
        VerticalSizeClassTransform(
            content: self,
            targetSizeClass: .regular,
            transform: transform
        )
    }
}

/// Conditionally transforms a view using its local vertical size class.
private struct VerticalSizeClassTransform<Content: View, Transformed: View>: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    let content: Content
    let targetSizeClass: UserInterfaceSizeClass
    let transform: (Content) -> Transformed

    @ViewBuilder
    var body: some View {
        if verticalSizeClass == targetSizeClass {
            transform(content)
        } else {
            content
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Orientation Modifiers") {
    VStack {
        Text("Landscape transformation")
            .onLandscape { $0.foregroundStyle(.blue) }

        Text("Portrait transformation")
            .onPortrait { $0.foregroundStyle(.purple) }
    }
    .padding()
}
#endif
#endif
