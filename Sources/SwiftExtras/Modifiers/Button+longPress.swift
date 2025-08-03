//
//  Button+longPress.swift
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

    /// A button style that triggers an action on long press.
    /// This style allows you to create a button that responds to long press gestures.
    /// It scales down the button when pressed and executes the provided action on long press.
    struct LongPressButtonStyle: PrimitiveButtonStyle {
        /// An action to execute on long press
        let longPressAction: () -> Void

        /// Whether the button is being pressed
        @State var isPressed: Bool = false

        /// Creates a view that applies the long press button style.
        ///
        /// - Parameter configuration: The configuration for the button.
        ///
        /// - Returns: A view that applies the long press button style.
        ///
        /// Example usage:
        /// ```swift
        /// Text("Long Press Me")
        ///     .buttonStyle(LongPressButtonStyle(longPressAction: { print("Long pressed!") }))
        /// ```
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .onTapGesture {
                    configuration.trigger()
                }
                .onLongPressGesture(
                    perform: {
                        longPressAction()
                    },
                    onPressingChanged: { pressing in
                        isPressed = pressing
                    }
                )
        }
    }

    //// A view modifier that applies a long press action to a view.
    struct LongPressModifier: ViewModifier {
        /// The action to perform on long press.
        let longPressAction: () -> Void

        /// Applies the long press button style to the content.
        ///
        /// - Parameter content: The content to apply the modifier to.
        ///
        /// - Returns: A view that applies the long press button style.
        ///
        /// Example usage:
        /// ```swift
        /// Text("Long Press Me")
        ///     .buttonStyle(LongPressButtonStyle(longPressAction: { print("Long pressed!") }))
        /// ```
        func body(content: Content) -> some View {
            content.buttonStyle(LongPressButtonStyle(longPressAction: longPressAction))
        }
    }

    public extension View {
        /// Adds a long press action to the view.
        ///
        /// - Parameter action: The action to perform on long press.
        ///
        /// - Returns: A view that applies the long press action.
        ///
        /// Example usage:
        /// ```swift
        /// Text("Long Press Me")
        ///     .longPress {
        ///         print("Long pressed!")
        ///     }
        /// ```
        func longPress(action: @escaping () -> Void) -> some View {
            modifier(LongPressModifier(longPressAction: action))
        }
    }
#endif
