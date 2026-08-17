//
//  Color+Random.swift
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

extension Color {
    /// Returns a random color
    ///
    /// This variable returns a random color.
    public static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: 1
        )
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Random Colors") {
    let colors = (1...5).map { _ in Color.random }

    HStack(spacing: 8) {
        ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: 52, height: 90)
                .accessibilityLabel("Random color \(index + 1)")
        }
    }
    .padding()
}
#endif
#endif
