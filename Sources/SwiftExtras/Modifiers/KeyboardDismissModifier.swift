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
    /// Adds a tap gesture that dismisses the current first responder.
    ///
    /// - Parameter content: The content to modify.
    /// - Returns: The content with keyboard dismissal behavior applied.
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

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, *)
private struct KeyboardDismissPreview: View {
    @State private var text = "Example text"

    var body: some View {
        VStack {
#if os(tvOS)
            TextField("Editable text", text: $text)
                .accessibilityHint("Select the surrounding area to dismiss text entry")
#else
            TextField("Editable text", text: $text)
                .textFieldStyle(.roundedBorder)
                .accessibilityHint("Tap outside the field to dismiss the keyboard")
#endif

            Text("Tap this area to dismiss the keyboard")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .dismissKeyboardOnTap()
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, *)
#Preview("Keyboard Dismissal") {
    KeyboardDismissPreview()
}
#endif
#endif
