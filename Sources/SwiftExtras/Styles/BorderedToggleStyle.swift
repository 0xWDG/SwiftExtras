//
//  BorderedToggleStyle.swift
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

    /// A toggle style that uses a border around the toggle.
    ///
    /// The style uses a ``GrayButtonStyle`` button style and a border around the toggle.
    ///
    /// Example:
    /// ```swift
    /// Toggle("Hello World!", isOn: .constant(true))
    ///     .toggleStyle(.bordered)
    /// ```
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public struct BorderedToggleStyle: ToggleStyle {
        /// Creates a bordered toggle style.
        ///
        /// - Parameter configuration: The configuration of the toggle.
        /// - Returns: A bordered toggle style.
        public func makeBody(configuration: Configuration) -> some View {
            let symbol = configuration.isOn ? "checkmark.circle.fill" : "circle"

            Button(
                action: {
                    configuration.isOn.toggle()
                },
                label: {
                    HStack {
                        Image(systemName: symbol)
                            .foregroundStyle(.tint)
                        configuration.label
                        Spacer(minLength: .zero)
                    }
                }
            )
            .buttonStyle(.gray)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        .tint,
                        style: .init(lineWidth: configuration.isOn ? 2 : 0)
                    )
            )
        }
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public extension ToggleStyle where Self == BorderedToggleStyle {
        /// A toggle style that uses a border around the toggle.
        ///
        /// The style uses a ``GrayButtonStyle`` button style and a border around the toggle.
        ///
        /// Example:
        /// ```swift
        /// Toggle("Hello World!", isOn: .constant(true))
        ///     .toggleStyle(.bordered)
        /// ```
        static var bordered: BorderedToggleStyle { .init() }
    }

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            VStack {
                Toggle(
                    "Hello World!",
                    isOn: .constant(false)
                )
                .toggleStyle(.bordered)

                Toggle(
                    "Hello World!",
                    isOn: .constant(true)
                )
                .toggleStyle(.bordered)

                Toggle(
                    "Hello World!",
                    isOn: .constant(false)
                )
                .accentColor(.green)
                .toggleStyle(.bordered)

                Toggle(
                    "Hello World!",
                    isOn: .constant(true)
                )
                .accentColor(.green)
                .toggleStyle(.bordered)

                Toggle(
                    "Hello World!",
                    isOn: .constant(false)
                )
                .tint(.red)
                .toggleStyle(.bordered)

                Toggle(
                    "Hello World!",
                    isOn: .constant(true)
                )
                .tint(.red)
                .toggleStyle(.bordered)
            }
            .padding()
        }
    #endif
#endif
