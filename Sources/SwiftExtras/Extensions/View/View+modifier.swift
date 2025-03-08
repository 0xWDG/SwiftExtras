//
//  View+modifier.swift
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
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Applies a transformation.
    ///
    /// This can be used to apply a transformation to a `View` based on a condition.
    ///
    /// Example:
    /// ```
    /// NavigationStack {
    ///     Text("Hello, World!")
    /// }
    /// .modify { 
    /// #if !os(macOS)
    ///     $0.navigationBarTitle("Hello, World!")
    /// #else
    ///     $0
    /// #endif
    /// }
    /// ```
    ///
    /// - Parameter transforation: The transform to apply to the source `View`.
    /// - Returns: the modified `View`.
    @ViewBuilder func modify<Content: View>(_ transforation: (Self) -> Content) -> some View {
        transforation(self)
    }
}
#endif
