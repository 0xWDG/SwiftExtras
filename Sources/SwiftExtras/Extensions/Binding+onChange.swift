//
//  Binding+onChange.swift
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

/// Adds binding transformations that observe value changes.
///
/// The resulting bindings retain the original source of truth while invoking caller-supplied work when a
/// new value is written.
public extension Binding {
    /// On change
    ///
    /// This operator allows you to execute code when a `Binding` value changes.
    ///
    /// Example usage:
    /// ```swift
    /// @State private var text = ""
    ///
    /// var body: some View {
    ///     TextField("Enter text", text: $text.onChange { newText in
    ///         print("Text changed to \(newText)")
    ///     })
    /// }
    /// ```
    ///
    /// - Parameter handler: code to execute on change
    ///
    /// - Returns: Binding
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            })
    }
}
#endif
