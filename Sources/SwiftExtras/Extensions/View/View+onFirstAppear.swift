//
//
//  View+onFirstAppear.swift
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
    /// Performs an action when the view first appears.
    /// - Parameter action: The action to perform when the view first appears.
    public func onFirstAppear(_ action: @escaping () async -> Void) -> some View {
        modifier(OnFirstAppearModifier {
            Task {
                await action()
            }
        })
    }
}

private struct OnFirstAppearModifier: ViewModifier {
    let action: () -> Void

    // Use this to only fire your block one time
    @State private var hasAppeared = false

    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else {
                return
            }
            hasAppeared = true
            action()
        }
    }
}
#endif
