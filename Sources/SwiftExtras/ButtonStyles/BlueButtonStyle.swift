//
//  BlueButtonStyle.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-28.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A button style that uses the system's blue color.
///
/// The style uses the system's blue color for the background of the button.
/// The text color is white when the button is enabled and blue when the button is disabled.
///
/// - Returns: A button style that uses the system's blue color.
///
/// Example:
/// ```swift
/// Button("Hello, World!") {}
///     .buttonStyle(.blue)
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct BlueButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled

    /// Creates a blue button style.
    ///
    /// - Parameter configuration: The configuration of the button.
    /// - Returns: A blue button style.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                isEnabled ? .blue : .blue.opacity(0.2),
                in: .rect(cornerRadius: 10)
            )
            .foregroundStyle(isEnabled ? .white : .blue)
            .font(.body.weight(.medium))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(
                .easeOut(duration: 0.2),
                value: configuration.isPressed
            )
            .sensoryFeedback(
                .selection,
                trigger: configuration.isPressed
            )
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension ButtonStyle where Self == BlueButtonStyle {
    /// A button style that uses the system's blue color.
    ///
    /// The style uses the system's blue color for the background of the button.
    /// The text color is white when the button is enabled and blue when the button is disabled.
    ///
    /// - Returns: A button style that uses the system's blue color.
    ///
    /// Example:
    /// ```swift
    /// Button("Hello, World!") {}
    ///     .buttonStyle(.blue)
    /// ```
    public static var blue: BlueButtonStyle { .init() }
}

@available(iOS 17.0, macOS 14.0, *)
struct BlueButtonPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Hello, World!") {}
                .buttonStyle(.blue)

            Button("Hello, World!") {}
                .buttonStyle(.blue)
                .disabled(true)
        }
        .padding()
    }
}
#endif
