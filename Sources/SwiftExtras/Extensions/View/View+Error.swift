//
//  View+showError.swift
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
    /// Show an error message if there is any.
    ///
    /// This allows you to show an error message if there is any.
    ///
    /// Usage:
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var error: Error?
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text("Hello, World!")
    ///                 .padding()
    ///         }
    ///         .task {
    ///             do {
    ///                 throw CustomError(message: "This is a custom error message")
    ///             } catch {
    ///                 error = error
    ///             }
    ///         }
    ///         .showError(error: $error)
    ///     }
    /// ```
    ///
    /// - Parameter error: Error message
    /// - Parameter buttonTitle: Button title
    ///
    /// - Returns: self
    public func showError(error: Binding<Error?>, buttonTitle: LocalizedStringKey = "OK") -> some View {
        alert(
            error.wrappedValue?.localizedDescription ?? "Unknown error",
            isPresented: .constant(error.wrappedValue != nil)
        ) {
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        }
    }
}

/// Create a (custom) error.
///
/// This allows you to create a custom error message.
///
/// Usage:
/// ```swift
/// CustomError(message: "This is a custom error message")
/// ```
public struct CustomError: Error {
    let message: String

    /// Create a (custom) error.
    ///
    /// This allows you to create a custom error message.
    ///
    /// - Parameter message: The error message
    public init(message: String) {
        self.message = message
    }
}

extension CustomError: LocalizedError {
    /// A localized message describing what error occurred.
    ///
    /// This is the error message wrapped in a `LocalizedStringKey`.
    public var errorDescription: String? {
        NSLocalizedString(message, comment: "")
    }
}
#endif
