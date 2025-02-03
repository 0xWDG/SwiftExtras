//
//  TransparentBlurView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(UIKit)
import SwiftUI

/// Transparent blur view
///
/// This view is a wrapper around `UIVisualEffectView` on iOS.
///
/// Usage:
/// ```swift
/// VStack {
///     Text("Hello, World!")
///         .padding()
/// }
/// .background(TransparentBlurView())
/// ```
public struct TransparentBlurView: UIViewRepresentable {
    var removeAllFilters: Bool = false

    /// Make UI View
    /// - Parameter _: context
    /// - Returns: UIVisualEffectView
    public func makeUIView(context _: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    }

    /// Update UI View
    /// - Parameters:
    ///   - uiView: UIVisualEffectView
    ///   - _: context
    public func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                if removeAllFilters {
                    backdropLayer.filters = []
                } else {
                    // Removing All Expect Blur Filter
                    backdropLayer.filters?.removeAll { filter in
                        String(describing: filter) != "gaussianBlur"
                    }
                }
            }
        }
    }
}
#endif
