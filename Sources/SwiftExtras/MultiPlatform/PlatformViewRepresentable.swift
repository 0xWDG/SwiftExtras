//
//  PlatformViewRepresentable.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if !os(watchOS) && canImport(SwiftUI)
import SwiftUI

/// A platform-agnostic version of `UIViewRepresentable`/`NSViewRepresentable`,
/// allowing for a single implementation to be used for both UIKit and AppKit platforms.
public protocol PlatformViewRepresentable: PlatformViewRepresentableType {
    /// The type of view this representable manages.
    associatedtype PlatformViewType

    /// Create the platform view.
    ///
    /// - Parameter context: SwiftUI context.
    /// - Returns: The new instance of your platform view.
    ///
    /// This is equivalent to `makeUIView` on UIKit platforms and `makeNSView` on AppKit platforms.
    func makePlatformView(context: Context) -> PlatformViewType

    /// Update the platform view.
    ///
    /// - Parameters:
    ///   - platformView: The platform view instance.
    ///   - context: SwiftUI context.
    ///
    /// This is equivalent to `updateUIView` on UIKit platforms and `updateNSView` on AppKit platforms.
    func updatePlatformView(_ platformView: PlatformViewType, context: Context)
}

#if canImport(UIKit)
/// A platform-agnostic version of `UIViewRepresentable`/`NSViewRepresentable`,
/// allowing for a single implementation to be used for both UIKit and AppKit platforms.
public extension PlatformViewRepresentable where UIViewType == PlatformViewType {
    /// Create the platform view.
    ///
    /// - Parameter context: SwiftUI context.
    /// - Returns: The new instance of your platform view.
    ///
    /// This is equivalent to `makeUIView` on UIKit platforms and `makeNSView` on AppKit platforms.
    func makeUIView(context: Context) -> UIViewType {
        makePlatformView(context: context)
    }

    /// Update the platform view.
    ///
    /// - Parameters:
    ///   - platformView: The platform view instance.
    ///   - context: SwiftUI context.
    ///
    /// This is equivalent to `updateUIView` on UIKit platforms and `updateNSView` on AppKit platforms.
    func updateUIView(_ uiView: UIViewType, context: Context) {
        updatePlatformView(uiView, context: context)
    }
}
#else
public extension PlatformViewRepresentable where NSViewType == PlatformViewType {
    /// Create the platform view.
    ///
    /// - Parameter context: SwiftUI context.
    /// - Returns: The new instance of your platform view.
    ///
    /// This is equivalent to `makeUIView` on UIKit platforms and `makeNSView` on AppKit platforms.
    func makeNSView(context: Context) -> NSViewType {
        makePlatformView(context: context)
    }

    /// Update the platform view.
    ///
    /// - Parameters:
    ///   - platformView: The platform view instance.
    ///   - context: SwiftUI context.
    ///
    /// This is equivalent to `updateUIView` on UIKit platforms and `updateNSView` on AppKit platforms.
    func updateNSView(_ nsView: NSViewType, context: Context) {
        updatePlatformView(nsView, context: context)
    }
}
#endif
#endif
