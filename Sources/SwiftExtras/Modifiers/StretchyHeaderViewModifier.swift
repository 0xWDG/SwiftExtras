//
//  StretchyHeaderViewModifier.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A modifier that stretches a header when its scroll view is pulled beyond its top edge.
public struct StretchyHeaderViewModifier: ViewModifier {
    private let startingHeight: CGFloat
    private let coordinateSpace: CoordinateSpace

    /// Creates a stretchy header modifier.
    ///
    /// - Parameters:
    ///   - startingHeight: The header's height when the scroll view is at rest.
    ///   - coordinateSpace: The coordinate space used to measure the scroll offset.
    public init(
        startingHeight: CGFloat = 300,
        coordinateSpace: CoordinateSpace = .global
    ) {
        self.startingHeight = startingHeight
        self.coordinateSpace = coordinateSpace
    }

    /// Applies the stretchy header behavior to the supplied content.
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .frame(
                    width: geometry.size.width,
                    height: stretchedHeight(for: geometry)
                )
                .clipped()
                .offset(y: stretchedOffset(for: geometry))
        }
        .frame(height: startingHeight)
    }

    private func yOffset(for geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: coordinateSpace).minY
    }

    private func stretchedHeight(for geometry: GeometryProxy) -> CGFloat {
        startingHeight + max(0, yOffset(for: geometry))
    }

    private func stretchedOffset(for geometry: GeometryProxy) -> CGFloat {
        -max(0, yOffset(for: geometry))
    }
}

public extension View {
    /// Makes the view stretch when its scroll view is pulled beyond its top edge.
    ///
    /// - Parameters:
    ///   - startingHeight: The header's height when the scroll view is at rest.
    ///   - coordinateSpace: The coordinate space used to measure the scroll offset.
    /// - Returns: A view that grows to fill the revealed area above the scroll view.
    func asStretchyHeader(
        startingHeight: CGFloat,
        coordinateSpace: CoordinateSpace = .global
    ) -> some View {
        modifier(
            StretchyHeaderViewModifier(
                startingHeight: startingHeight,
                coordinateSpace: coordinateSpace
            )
        )
    }
}

#if DEBUG
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Stretchy Header") {
    ScrollView {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .accessibilityHidden(true)

            Text("Pull to stretch")
                .font(.title.bold())
                .foregroundStyle(.white)
        }
        .asStretchyHeader(startingHeight: 220)

        LazyVStack(alignment: .leading, spacing: 16) {
            ForEach(1...12, id: \.self) { item in
                Label("Example item \(item)", systemImage: "sparkles")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
}
#endif
#endif
