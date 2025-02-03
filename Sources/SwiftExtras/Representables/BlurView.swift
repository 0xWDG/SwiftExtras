//
//  BlurView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(UIKit) || canImport(AppKit)
import SwiftUI

/// Create a blurred view
///
/// This view is a wrapper around `UIVisualEffectView` on iOS and `NSVisualEffectView` on macOS.
///
/// Usage:
/// ```swift
/// VStack {
///     Text("Hello, World!")
///         .padding()
/// }
/// .background(BlurView(style: .systemMaterial))
/// ```
public struct BlurView: ViewRepresentable {
#if canImport(UIKit)
    public var style: UIBlurEffect.Style = .regular

    /// Create a blurred view
    ///
    /// - Parameters:
    ///   - style: Blur effect style
    public init(style: UIBlurEffect.Style = .regular) {
        self.style = style
    }

    public func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(
            effect: UIBlurEffect(style: style)
        )

        // Hack to make the view clear.
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }

        return view
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
#endif
#if canImport(AppKit)
    public var style: NSVisualEffectView.Material = .sidebar
    public var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow

    /// Create a blurred view
    ///
    /// - Parameters:
    ///   - style: Material style
    ///   - blendingMode: Blending mode
    public init(
        style: NSVisualEffectView.Material = .sidebar,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow
    ) {
        self.style = style
        self.blendingMode = blendingMode
    }

    public func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView(frame: .zero)
        view.material = style
        view.blendingMode = blendingMode
        return view
    }

    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = style
        nsView.blendingMode = blendingMode
    }
#endif
}

#endif
