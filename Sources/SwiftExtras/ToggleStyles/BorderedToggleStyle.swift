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

@available(iOS 17.0, *)
public struct BorderedToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        let symbol = configuration.isOn ? "checkmark.circle.fill" : "circle"
        let borderColor = configuration.isOn ? Color.blue : .clear

        Button(
            action: {
                configuration.isOn.toggle()
            },
            label: {
                HStack {
                    Image(systemName: symbol)
                        .foregroundStyle(.blue)
                    configuration.label
                    Spacer(minLength: .zero)
                }
            }
        )
        .buttonStyle(.gray)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    borderColor,
                    style: .init(lineWidth: 2)
                )
        )
    }
}

@available(iOS 17.0, *)
extension ToggleStyle where Self == BorderedToggleStyle {
    /// A toggle style that uses a border around the toggle.
    ///
    /// The style uses a ``GrayButtonStyle`` button style and a border around the toggle.
    ///
    /// Example:
    /// ```swift
    /// Toggle("Hello, World!", isOn: .constant(true))
    ///     .toggleStyle(.bordered)
    /// ```
    public static var bordered: BorderedToggleStyle { .init() }
}

@available(iOS 17.0, *)
struct BorderedToggleStylePreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Toggle(
                "Hello World",
                isOn: .constant(false)
            )
            .toggleStyle(.bordered)

            Toggle(
                "Hello World",
                isOn: .constant(true)
            )
            .toggleStyle(.bordered)
        }
        .padding()
    }
}
#endif
