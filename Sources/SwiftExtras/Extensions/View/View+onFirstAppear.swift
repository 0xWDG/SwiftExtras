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

/// Adds `View onFirstAppear` functionality to `View`.
///
/// The declarations in this scope provide focused utilities while preserving the type’s standard behavior.
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

    /// Builds the view hierarchy represented by this declaration.
    ///
    /// SwiftUI evaluates this when it needs the current visual representation.
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

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
private struct OnFirstAppearPreview: View {
    @State private var didAppear = false

    var body: some View {
        Label(
            didAppear ? "First appearance handled" : "Waiting to appear",
            systemImage: didAppear ? "checkmark.circle.fill" : "circle"
        )
        .onFirstAppear {
            didAppear = true
        }
        .padding()
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("First Appearance") {
    OnFirstAppearPreview()
}
#endif
#endif
