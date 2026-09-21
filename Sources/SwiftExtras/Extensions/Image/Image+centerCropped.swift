//
//  Image+centerCropped.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && !os(watchOS)
import SwiftUI

extension Image {
    /// Crops the image to the center, filling the available space.
    public func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, *)
#Preview("Center Cropped Image") {
    Image(systemName: "mountain.2.fill")
        .centerCropped()
        .foregroundStyle(.teal)
        .frame(width: 240, height: 140)
        .background(.secondary.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityLabel("Center-cropped mountain placeholder")
        .padding()
}
#endif
#endif
