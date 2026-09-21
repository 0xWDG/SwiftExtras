//
//  KeyboardDoneToolbar.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-09-21.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(watchOS)
import SwiftUI

/// Adds a Done button above the software keyboard.
///
/// Apply this modifier to a view containing editable controls to give people
/// an explicit way to dismiss the keyboard. It is available on UIKit-based
/// platforms other than watchOS.
public struct KeyboardDoneToolbar: ViewModifier {
    /// Adds a keyboard toolbar containing a Done button.
    ///
    /// - Parameter content: The content to modify.
    /// - Returns: The content with keyboard dismissal behavior applied.
    @ViewBuilder
    public func body(content: Content) -> some View {
#if os(tvOS)
        content
#else
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        UIApplication
                            .shared
                            .sendAction(
                                #selector(UIResponder.resignFirstResponder),
                                to: nil,
                                from: nil,
                                for: nil
                            )
                    }
                    .accessibilityLabel("Dismiss keyboard")
                }
            }
#endif
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
        .modifier(KeyboardDoneToolbar())
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, *)
#Preview("Keyboard Done Toolbar") {
    KeyboardDismissPreview()
}
#endif
#endif
