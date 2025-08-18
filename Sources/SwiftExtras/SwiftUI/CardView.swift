//
//  CardView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// Card View
///
/// This view to represent a `CardView` like Apple is using in Maps, Find My, etc.
@available(macOS 11.0, *, iOS 14, *)
public struct CardView<Content: View>: View {
    // To dismiss this screen using the button.
    @Environment(\.presentationMode) var presentationMode

    let title: String
    let subtitle: String?
    let content: Content

    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var closeButton: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.system(size: 26))
            .foregroundColor(.gray.opacity(0.50))
            .accessibility(label: Text("Close"))
            .accessibility(hint: Text("Tap to close the screen"))
            .accessibility(addTraits: .isButton)
            .accessibility(removeTraits: .isImage)
    }

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(.init(title))
                            .font(.headline)
                            .lineLimit(1)

                        if let subtitle = subtitle {
                            Text(.init(subtitle))
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                    }

                    Spacer()
                    if #available(iOS 26, watchOS 26, macOS 26, *) {
                        Button(role: .cancel) {
                            presentationMode.wrappedValue.dismiss()
                        }
#if !os(watchOS)
                        .keyboardShortcut(.cancelAction)
#endif
                    } else {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            self.closeButton
                        }
#if !os(watchOS)
                        .keyboardShortcut(.cancelAction)
#endif
                    }
                }
                .padding(12)

                Divider()
                    .ignoresSafeArea()
                    .padding(0)

                ScrollView {
                    VStack(alignment: .leading) {
                        // Custom Content
                        self.content
                            .padding(.top, 5)
                            .padding(.horizontal)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )

                        // Move everything up
                        Spacer()
                    }
                }
            }
            .padding(5)
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Text("Hello World!")
        .sheet(isPresented: .constant(true)) {
            CardView(title: "Title", subtitle: "Subtitle") {
                Text("Hello World!")
            }
        }
}
#endif
#endif
