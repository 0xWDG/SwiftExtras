//
//  LimitedTextField.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && os(iOS)
    import SwiftUI

    /// A custom `TextField` view that limits the number of characters and
    /// displays a counter indicating the remaining characters.
    public struct LimitedTextField: View {
        let title: LocalizedStringKey
        @Binding var text: String

        let characterLimit: Int

        /// Initializes a `LimitedTextFieldWithCounter` view.
        ///
        /// - Parameters:
        ///   - text: A binding to the `String` value representing the text input.
        ///   - characterLimit: The maximum number of characters allowed.
        public init(_ title: LocalizedStringKey, text: Binding<String>, characterLimit: Int) {
            self.title = title
            _text = text
            self.characterLimit = characterLimit
        }

        public var body: some View {
            VStack(alignment: .trailing, spacing: 4) {
                TextField(title, text: $text)
                    .onChange(of: text) { _ in
                        if text.count > characterLimit {
                            text = String(text.prefix(characterLimit))
                        }
                    }
                #if !os(tvOS) && !os(watchOS)
                    .textFieldStyle(.roundedBorder)
                #endif

                Text(String(localized: "\(characterLimit - text.count) characters left", bundle: .module))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            @Previewable @State var previewText = ""

            Form {
                LimitedTextField("Enter text", text: $previewText, characterLimit: 10)
            }
            .formStyle(.grouped)
        }
    #endif
#endif
