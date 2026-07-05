//
//
//  View+colorScheme.swift
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
    /// Configures the view's subtitle for purposes of navigation,
    /// using a string.
    ///
    /// A view's navigation subtitle is used to provide additional
    /// contextual information alongside the navigation title.
    /// On macOS, the primary destination's subtitle is displayed
    /// with the navigation title in the titlebar. On iOS and iPadOS,
    /// the subtitle is displayed with the navigation title in the
    /// navigation bar.
    ///
    /// - Parameter subtitle: The subtitle to display.
    @ViewBuilder
    public func subtitle(_ title: String) -> some View {
        #if os(iOS) || os(macOS)
            if #available(iOS 26, *) {
                self.navigationSubtitle(title)
            } else {
                self
            }
        #else
            self
        #endif
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    NavigationStack {
        Text("Hello, World!")
            .subtitle("Subtitle")
    }
}
#endif
#endif
