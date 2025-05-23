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

    public init(title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var closeButton: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
            .font(.system(size: 26))
            .opacity(0.75)
            .accessibility(label: Text("Close"))
            .accessibility(hint: Text("Tap to close the screen"))
            .accessibility(addTraits: .isButton)
            .accessibility(removeTraits: .isImage)
    }

    public var body: some View {
        NavigationView {
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
            .toolbar {
#if !os(watchOS) && !os(tvOS)
                ToolbarItem(placement: .navigation) {
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
                }

                ToolbarItem(placement: .primaryAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        self.closeButton
                    }
                    .keyboardShortcut(.cancelAction)
                }
#else
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    self.closeButton
                }
#endif
            }
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
