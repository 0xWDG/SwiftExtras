//
//  ListButtonStyle.swift
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

/// This style makes the button take up the entire row, then
/// applies a shape that makes the entire view tappable.
///
/// You can apply this style with `.buttonStyle(.list)`, and
/// can apply it to an entire list, like any other style.
public struct ListButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled

    /// This style makes the button take up the entire row, then
    /// applies a shape that makes the entire view tappable.
    ///
    /// - Parameter configuration: The configuration of the button.
    /// - Returns: A filled button style.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? .primary : .secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(
                .easeOut(duration: 0.2),
                value: configuration.isPressed
            )
    }
}

public extension ButtonStyle where Self == ListButtonStyle {
    /// This style makes the button take up the entire row, then
    /// applies a shape that makes the entire view tappable.
    ///
    /// Example:
    /// ```swift
    /// Button("Hello, World!") {}
    ///     .buttonStyle(.list)
    /// ```
    static var list: ListButtonStyle { .init() }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    List {
        Button("Hello, World!") {
            print("Hello World!")
        }

        Button("Hello, World!") {
            print("Hello World!")
        }
        .disabled(true)
    }
    .buttonStyle(.list)
}
#endif
#endif
