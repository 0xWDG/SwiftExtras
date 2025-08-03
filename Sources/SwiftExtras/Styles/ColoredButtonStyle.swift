//
//  ColoredButtonStyle.swift
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
    /// Button("Hello World!") {}
    ///     .buttonStyle(colored(color: .blue))
    /// ```
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public struct ColoredButtonStyle: ButtonStyle {
        @Environment(\.isEnabled)
        private var isEnabled

        @Environment(\.colorScheme)
        private var colorSheme

        var color: Color

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
                    isEnabled ? color : color.opacity(0.2),
                    in: .rect(cornerRadius: 10)
                )
                .foregroundStyle(isEnabled ? .white : color)
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
    extension ButtonStyle where Self == ColoredButtonStyle {
        /// A button style that uses a custom color.
        ///
        /// The style uses a custom color for the background of the button.
        /// The text color is white when the button is enabled and the custom color when the button is disabled.
        ///
        /// - Returns: A button style that uses a custom color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(colored(color: .blue))
        /// ```
        public static func colored(color: Color) -> ColoredButtonStyle {
            .init(color: color)
        }

        /// A button style that uses the system's red color.
        ///
        /// The style uses the system's red color for the background of the button.
        /// The text color is white when the button is enabled and red when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's red color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.redColor)
        /// ```
        public static var redColor: ColoredButtonStyle {
            .init(color: .red)
        }

        /// A button style that uses the system's orange color.
        ///
        /// The style uses the system's orange color for the background of the button.
        /// The text color is white when the button is enabled and orange when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's orange color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.orangeColor)
        /// ```
        public static var orangeColor: ColoredButtonStyle {
            .init(color: .orange)
        }

        /// A button style that uses the system's yellow color.
        ///
        /// The style uses the system's yellow color for the background of the button.
        /// The text color is white when the button is enabled and yellow when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's yellow color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.yellowColor)
        /// ```
        public static var yellowColor: ColoredButtonStyle {
            .init(color: .yellow)
        }

        /// A button style that uses the system's green color.
        ///
        /// The style uses the system's green color for the background of the button.
        /// The text color is white when the button is enabled and green when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's green color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.greenColor)
        /// ```
        public static var greenColor: ColoredButtonStyle {
            .init(color: .green)
        }

        /// A button style that uses the system's mint color.
        ///
        /// The style uses the system's mint color for the background of the button.
        /// The text color is white when the button is enabled and mint when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's mint color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.mintColor)
        /// ```
        public static var mintColor: ColoredButtonStyle {
            .init(color: .mint)
        }

        /// A button style that uses the system's teal color.
        ///
        /// The style uses the system's teal color for the background of the button.
        /// The text color is white when the button is enabled and teal when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's teal color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.tealColor)
        /// ```
        public static var tealColor: ColoredButtonStyle {
            .init(color: .teal)
        }

        /// A button style that uses the system's cyan color.
        ///
        /// The style uses the system's cyan color for the background of the button.
        /// The text color is white when the button is enabled and cyan when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's cyan color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.cyanColor)
        /// ```
        public static var cyanColor: ColoredButtonStyle {
            .init(color: .cyan)
        }

        /// A button style that uses the system's blue color.
        ///
        /// The style uses the system's blue color for the background of the button.
        /// The text color is white when the button is enabled and blue when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's blue color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.blueColor)
        /// ```
        public static var blueColor: ColoredButtonStyle {
            .init(color: .blue)
        }

        /// A button style that uses the system's indigo
        ///
        /// The style uses the system's indigo for the background of the button.
        /// The text color is white when the button is enabled and indigo when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's indigo color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.indigoColor)
        /// ```
        public static var indigoColor: ColoredButtonStyle {
            .init(color: .indigo)
        }

        /// A button style that uses the system's purple color.
        ///
        /// The style uses the system's purple color for the background of the button.
        /// The text color is white when the button is enabled and purple when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's purple color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.purpleColor)
        /// ```
        public static var purpleColor: ColoredButtonStyle {
            .init(color: .purple)
        }

        /// A button style that uses the system's pink color.
        ///
        /// The style uses the system's pink color for the background of the button.
        /// The text color is white when the button is enabled and pink when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's pink color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.pinkColor)
        /// ```
        public static var pinkColor: ColoredButtonStyle {
            .init(color: .pink)
        }

        /// A button style that uses the system's brown color.
        ///
        /// The style uses the system's brown color for the background of the button.
        /// The text color is white when the button is enabled and brown when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's brown color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.brownColor)
        /// ```
        public static var brownColor: ColoredButtonStyle {
            .init(color: .brown)
        }

        /// A button style that uses the system's white color.
        ///
        /// The style uses the system's white color for the background of the button.
        /// The text color is white when the button is enabled and white when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's white color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.whiteColor)
        /// ```
        public static var whiteColor: ColoredButtonStyle {
            .init(color: .white)
        }

        /// A button style that uses the system's gray color.
        ///
        /// The style uses the system's gray color for the background of the button.
        /// The text color is white when the button is enabled and gray when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's gray color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.grayColor)
        /// ```
        public static var grayColor: ColoredButtonStyle {
            .init(color: .gray)
        }

        /// A button style that uses the system's black color.
        ///
        /// The style uses the system's black color for the background of the button.
        /// The text color is white when the button is enabled and black when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's black color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.blackColor)
        /// ```
        public static var blackColor: ColoredButtonStyle {
            .init(color: .black)
        }

        /// A button style that uses the system's primary color.
        ///
        /// The style uses the system's primary color for the background of the button.
        /// The text color is white when the button is enabled and primary when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's primary color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.primaryColor)
        /// ```
        public static var primaryColor: ColoredButtonStyle {
            .init(color: .primary)
        }

        /// A button style that uses the system's secondary color.
        ///
        /// The style uses the system's secondary color for the background of the button.
        /// The text color is white when the button is enabled and secondary when the button is disabled.
        ///
        /// - Returns: A button style that uses the system's secondary color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.secondaryColor)
        /// ```
        public static var secondaryColor: ColoredButtonStyle {
            .init(color: .secondary)
        }

        /// A button style that uses the system's blue color.
        ///
        /// The style uses the system's blue color for the background of the button.
        /// The text color is white when the button is enabled and blue when the button is disabled.
        /// - Returns: A button style that uses the system's blue color.
        ///
        /// Example:
        /// ```swift
        /// Button("Hello World!") {}
        ///     .buttonStyle(.blue)
        /// ```
        /// - Note: This is a deprecated alias for `blueColor`.
        @available(*, deprecated, renamed: "blueColor")
        public static var blue: ColoredButtonStyle {
            .init(color: .blue)
        }
    }

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            let colors: [Color] = [
                .blue, .red, .orange, .yellow, .green, .mint, .teal,
                .cyan, .indigo, .purple, .pink, .brown, .white, .gray,
                .black,  // swiftlint:disable:this trailing_comma
            ]

            VStack {
                HStack {
                    Button("Light") {}
                        .buttonStyle(ColoredButtonStyle(color: .red))
                    Button("Light (disabled)") {}
                        .buttonStyle(ColoredButtonStyle(color: .red))
                        .disabled(true)
                    Button("Dark") {}
                        .environment(\.colorScheme, .dark)
                        .buttonStyle(ColoredButtonStyle(color: .red))
                    Button("Dark (disabled)") {}
                        .environment(\.colorScheme, .dark)
                        .buttonStyle(ColoredButtonStyle(color: .red))
                        .disabled(true)
                }
                ScrollView {
                    ForEach(colors, id: \.self) { color in
                        HStack {
                            Button("Hello World!") {}
                                .buttonStyle(ColoredButtonStyle(color: color))

                            Button("Hello World!") {}
                                .buttonStyle(ColoredButtonStyle(color: color))
                                .disabled(true)

                            Button("Hello World!") {}
                                .buttonStyle(ColoredButtonStyle(color: color))
                                .environment(\.colorScheme, .dark)

                            Button("Hello World!") {}
                                .buttonStyle(ColoredButtonStyle(color: color))
                                .environment(\.colorScheme, .dark)
                                .disabled(true)
                        }
                    }
                }
            }
            .padding()
        }
    #endif
#endif
// swiftlint:disable:this file_length
