//
//  KeyboardDismissModifier.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(watchOS)
import SwiftUI

/// A modifier to dismiss the keyboard when tapping outside a text field.
public struct KeyboardDismissModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}

/// A helper function to extend UIApplication for dismissing the keyboard.
public extension UIApplication {
    /// Dismisses the keyboard.
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/// A view extension to use the modifier easily.
public extension View {
    /// Dismisses the keyboard when tapping outside a text field.
    /// - Returns: A view with the keyboard dismiss modifier applied.
    func dismissKeyboardOnTap() -> some View {
        self.modifier(KeyboardDismissModifier())
    }
}
#endif
