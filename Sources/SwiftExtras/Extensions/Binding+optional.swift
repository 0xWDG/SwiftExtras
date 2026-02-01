//
//  Binding+optional.swift
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

public extension Binding {
    /// Provides a binding that unwraps an optional binding, providing a default value if the optional is nil.
    ///
    /// - Usage Example:
    /// ```swift
    /// @State var optionalString: String?
    /// var body: some View {
    ///     let unwrappedBinding = $optionalString ?? "Default Value"
    ///     TextField("Enter text", text: unwrappedBinding)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: The optional binding to unwrap.
    ///   - rhs: The default value to use if the optional is nil.
    /// - Returns: A binding to the unwrapped value or the default value.
    static func ??(lhs: Binding<Optional<Value>>, rhs: Value) -> Binding<Value> {
        Binding {
            lhs.wrappedValue ?? rhs
        } set: {
            lhs.wrappedValue = $0
        }
    }
}
#endif
