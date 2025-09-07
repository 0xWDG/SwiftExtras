//
//  FloatingTextField.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-09-05.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// Floating text field.
///
/// A FloatingTextField is a custom text field that displays a floating placeholder
/// when the user is editing the field or when there is text present.
public struct FloatingTextField: View {
    /// The text value of the text field.
    @Binding private var text: String
    /// Whether the text field is currently being edited.
    @State private var isEditing = false
    /// The placeholder (label) text for the text field.
    private let placeHolderText: String
    /// Should the text field draw a box around it?
    private let shouldDrawBox: Bool

    // Should the placeholder move?
    private var shouldPlaceHolderMove: Bool {
        isEditing || !text.isEmpty
    }

    /// Floating text field.
    ///
    /// A FloatingTextField is a custom text field that displays a floating placeholder
    /// when the user is editing the field or when there is text present.
    /// 
    /// - Parameters:
    ///   - label: The placeholder text for the text field.
    ///   - text: A binding to the text value of the text field.
    ///   - shouldDrawBorder: A Boolean value indicating whether to draw a border around the text field.
    public init(
        _ label: String,
        text: Binding<String>,
        shouldDrawBorder: Bool = false
    ) {
        self._text = text
        self.placeHolderText = label
        self.shouldDrawBox = shouldDrawBorder
    }

    /// The view body
    public var body: some View {
        ZStack(alignment: .leading) {
            TextField(isEditing ? "" : placeHolderText, text: $text, onEditingChanged: { (edit) in
#if !os(macOS)
                isEditing = edit
#endif
            })
            .foregroundColor(Color.primary)
            .animation(Animation.easeInOut(duration: 0.4), value: EdgeInsets())
            .frame(alignment: .leading)
            .padding(shouldDrawBox ? .all : .vertical)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: shouldDrawBox ? (isEditing ? 1 : 0) : 0)
                    .foregroundStyle(Color.placeholderText)
            }

            // Floating Placeholder
            Text(isEditing ? " " + placeHolderText + " " : "")
                .foregroundColor(Color.accentColor)
                .scaleEffect(shouldPlaceHolderMove ? 1.0 : 1.2)
                .animation(Animation.easeInOut(duration: 0.4), value: shouldPlaceHolderMove)
                .background(Color.systemBackground)
                .padding(
                    shouldPlaceHolderMove
                    ? EdgeInsets(top: 0, leading: shouldDrawBox ? 15 : -4, bottom: 50, trailing: 0)
                    : EdgeInsets(top: 0, leading: shouldDrawBox ? 15 : 0, bottom: 0, trailing: 0)
                )
        }
        .frame(height: 50)
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    @Previewable @State var text = ""
    Form {
        FloatingTextField("Label", text: .constant(""))
        FloatingTextField("Label", text: .constant("Test"))
        FloatingTextField("Label", text: $text)

        FloatingTextField("Label", text: .constant(""), shouldDrawBorder: true)
        FloatingTextField("Label", text: .constant("Test"), shouldDrawBorder: true)
        FloatingTextField("Label", text: $text, shouldDrawBorder: true)
    }
}
#endif
#endif
