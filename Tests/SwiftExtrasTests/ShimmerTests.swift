//
//  ShimmerTests.swift
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
import Testing
@testable import SwiftExtras

@MainActor
@Test func viewShimmerAPIsSupportDefaultsAndCustomization() {
    let content = Text("Loading")

    _ = content.modifier(Shimmer(mode: .mask))
    _ = content.modifier(Shimmer(mode: .overlay()))
    _ = content.modifier(Shimmer(mode: .background))
    _ = content.shimmer()
    _ = content.shimmering(active: false)
    _ = content.shimmering(
        animation: .linear(duration: 2),
        gradient: Gradient(colors: [.clear, .white, .clear]),
        bandSize: 0.5,
        mode: .overlay(blendMode: .screen)
    )
}
#endif
