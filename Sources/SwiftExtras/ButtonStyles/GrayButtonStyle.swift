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

@available(iOS 17.0, macOS 14.0, *)
public struct GrayButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                .background.secondary,
                in: .rect(cornerRadius: 10)
            )
            .foregroundStyle(.primary)
            .foregroundStyle(isEnabled ? .primary : Color.gray)
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

@available(iOS 17.0, *)
extension ButtonStyle where Self == GrayButtonStyle {
    /// A button style makes a filled gray button.
    ///
    /// The style uses the system's gray color for the background of the button.
    /// The text color is primary when the button is enabled and gray when the button is disabled.
    ///
    /// Example:
    /// ```swift
    /// Button("Hello, World!") {}
    ///     .buttonStyle(.gray)
    /// ```
    public static var gray: GrayButtonStyle { .init() }
}

@available(iOS 17.0, *)
struct GrayButtonStyleButtonStylePreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Hello, World!") {}
                .buttonStyle(.gray)

            Button("Hello, World!") {}
                .buttonStyle(.gray)
                .disabled(true)
        }
        .padding()
    }
}
#endif
