//
//  GrayButtonStyle.swift
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

/// A button style makes a filled gray button.
///
/// The style uses the system's gray color for the background of the button.
/// The text color is primary when the button is enabled and gray when the button is disabled.
///
/// Example:
/// ```swift
/// Button("Hello World!") {}
///     .buttonStyle(.gray)
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct GrayButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled

    /// Creates a gray button style.
    ///
    /// - Parameter configuration: The configuration of the button.
    /// - Returns: A gray button style.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                .background.secondary,
                in: .rect(cornerRadius: 10)
            )
            .foregroundStyle(isEnabled ? .primary : .secondary)
            .font(.body.weight(.medium))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(
                .easeOut(duration: 0.2),
                value: configuration.isPressed
            )
#if !os(visionOS)
            .sensoryFeedback(
                .selection,
                trigger: configuration.isPressed
            )
#endif
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ButtonStyle where Self == GrayButtonStyle {
    /// A button style makes a filled gray button.
    ///
    /// The style uses the system's gray color for the background of the button.
    /// The text color is primary when the button is enabled and gray when the button is disabled.
    ///
    /// Example:
    /// ```swift
    /// Button("Hello World!") {}
    ///     .buttonStyle(.gray)
    /// ```
    public static var gray: GrayButtonStyle { .init() }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    VStack {
        Button("Hello World!") {}
            .buttonStyle(.gray)

        Button("Hello World!") {}
            .buttonStyle(.gray)
            .disabled(true)
    }
    .padding()
}
#endif
#endif
