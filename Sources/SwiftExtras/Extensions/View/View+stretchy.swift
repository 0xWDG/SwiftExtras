//
//  View+stretchy.swift
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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Applies a stretchy effect to the view, scaling it based on the scroll offset.
    /// 
    /// - Returns: A view that stretches when pulled down in a scroll view.
    public func stretchy() -> some View {
        visualEffect { effect, geometry in
            let currentHeight = geometry.size.height
            let scrollOffset = geometry.frame(in: .scrollView).minY
            let positiveOffset = max(0, scrollOffset)
            let newHeight = currentHeight + positiveOffset
            let scaleFactor = newHeight / currentHeight
            return effect.scaleEffect(
                x: scaleFactor,
                y: scaleFactor,
                anchor: .bottom
            )
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Stretchy View") {
    ScrollView {
        ZStack {
            Color.teal
                .accessibilityHidden(true)
            Text("Pull to stretch")
                .font(.title.bold())
                .foregroundStyle(.white)
        }
        .frame(height: 220)
        .stretchy()

        Text("Preview content")
            .padding()
    }
}
#endif
#endif
