//
//
//  View+adaptiveColor.swift
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
    /// Adaptive color that switches between two colors based on the background.
    /// - Parameters:
    ///   - color: The primary color to use (default is white).
    ///   - second: The secondary color to use (default is black).
    /// - Returns: A view with adaptive coloring.
    public func adaptiveColor(_ color: Color = .white, or second: Color = .black) -> some View {
        self
            .foregroundStyle(color)
            .blendMode(.difference)
            .overlay(self.blendMode(.hue))
            .overlay(self.foregroundStyle(color))
            .blendMode(.overlay)
            .overlay(self.foregroundStyle(second))
            .blendMode(.overlay)
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    VStack {
        Text("Hello World!")
            .adaptiveColor()

        ZStack {
            HStack(spacing: 0) {
                ForEach(
                    [Color.red, .orange, .yellow, .green, .blue, .indigo, .purple],
                    id: \.self
                ) { color in
                    color
                }
            }
            .frame(height: 40)

            Text("Hello World!")
                .adaptiveColor()
        }
    }
}
#endif
#endif
