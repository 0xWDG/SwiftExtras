//
//  LabeledTextField.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A SwiftUI view that displays a text field with a floating label.
public struct LabeledTextField: View {
    private var title: String

    @Binding
    private var text: String

    @FocusState
    private var isActive: Bool

    /// Initializes a new instance of `LabeledTextField`.
    /// - Parameters:
    ///   - title: The label text to display when the text field is empty.
    ///   - text: A binding to the text value of the text field.
    public init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            TextField(isActive ? "" : title, text: $text)
                .padding(.leading)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .focused($isActive)
                .accessibilityLabel(title)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentColor, lineWidth: 1)
                )

            if isActive {
                Text(title)
                    .padding(.horizontal)
                    .offset(y: (isActive || !text.isEmpty) ? -50 : 0)
                    .foregroundStyle(isActive ? .secondary : .secondary)
                    .animation(.spring, value: isActive)
                    .accessibilityHidden(true)
            }
        }
        .padding(.top, isActive ? 50 : 0)
        .animation(.easeInOut, value: isActive)
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
   @Previewable @State var previewText = ""

   Form {
      LabeledTextField("Enter text", text: $previewText)
   }
}
#endif
#endif
