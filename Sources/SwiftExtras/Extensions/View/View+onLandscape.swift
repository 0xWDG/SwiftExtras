//
//  View+onLandscape.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A view wrapper for
extension View {
    /// Perform an action only if the device is landscape mode
    ///
    /// Only perform a view modifier if the device is in landscape mode.
    /// Use this view modifier after your element. e.g.
    ///
    ///     Text("I will be hidden, if we are in landscape mode")
    ///       .onLandscape {
    ///         // Hide if we are in landscape mode
    ///         $0.hidden()
    ///       }
    ///
    /// - Returns: ViewModifier
    @ViewBuilder public func onLandscape<Transform: View>(transform: (Self) -> Transform) -> some View {
#if os(iOS)
        if UIScreen.main.traitCollection.verticalSizeClass == .compact {
            transform(self)
        } else {
            self
        }
#elseif os(visionOS)
        self // VisionOS is always landscape at default
#else
        transform(self)
#endif
    }

    /// Perform an action only if the device is portrait mode
    ///
    /// Only perform a view modifier if the device is in portrait mode.
    /// Use this view modifier after your element. e.g.
    ///
    ///     Text("I will be hidden, if we are in portrait mode")
    ///       .onPortrait {
    ///         // Hide if we are in portrait mode
    ///         $0.hidden()
    ///       }
    ///
    /// - Returns: ViewModifier
    @ViewBuilder public func onPortrait<Transform: View>(transform: (Self) -> Transform) -> some View {
#if os(iOS)
        if UIScreen.main.traitCollection.verticalSizeClass == .regular {
            transform(self)
        } else {
            self
        }
#elseif os(visionOS)
        transform(self) // VisionOS is always landscape at default
#else
        self
#endif
    }
}

#endif
