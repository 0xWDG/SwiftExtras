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

/// A dismissible card that displays a title, optional subtitle, and custom content.
@available(iOS 15, macOS 12, tvOS 15, watchOS 8, visionOS 1, *)
public struct CardView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let subtitle: String?
    let content: Content

    /// Creates a card view.
    ///
    /// - Parameters:
    ///   - title: The card's title.
    ///   - subtitle: Optional supporting text displayed below the title.
    ///   - content: A view builder that creates the card's scrollable content.
    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var closeButtonImage: some View {
        Image(systemName: "xmark")
            .font(.body.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(width: 40, height: 40)
            .background(Color.secondary.opacity(0.14), in: Circle())
            .accessibilityHidden(true)
    }

    /// A button that dismisses the current presentation.
    @ViewBuilder
    public var closeButton: some View {
#if compiler(>=6.2)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            Button(role: .close) {
                dismiss()
            } label: {
                self
                    .closeButtonImage
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
            }
            .tint(Color.secondary)
            .accessibilityLabel(Text("Close", bundle: .module))
            .accessibilityHint(Text("Tap to close the screen", bundle: .module))
#if !os(watchOS) && !os(tvOS)
            .keyboardShortcut(.cancelAction)
#endif
        } else {
            fallbackCloseButton
        }
#else
        fallbackCloseButton
#endif
    }

    private var fallbackCloseButton: some View {
        Button {
            dismiss()
        } label: {
            self
                .closeButtonImage
                .frame(minWidth: 44, minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Close", bundle: .module))
        .accessibilityHint(Text("Tap to close the screen", bundle: .module))
#if !os(watchOS) && !os(tvOS)
        .keyboardShortcut(.cancelAction)
#endif
    }

    /// The card's title bar and scrollable content.
    public var body: some View {
        VStack(spacing: 0) {
            CardHeader(
                title: title,
                subtitle: subtitle,
                closeButton: closeButton
            )

            Divider()

            ScrollView {
                self.content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }
        .modifier(CardPresentationDragIndicator())
    }
}

private struct CardPresentationDragIndicator: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            content.presentationDragIndicator(.visible)
        } else {
            content
        }
    }
}

private struct CardHeader<CloseButton: View>: View {
    let title: String
    let subtitle: String?
    let closeButton: CloseButton

    var body: some View {
        HStack(spacing: 12) {
            Color // filler.
                .clear
                .frame(width: 30, height: 30)

            Spacer(minLength: 0)

            VStack(alignment: .center, spacing: 2) {
                Text(.init(title))
                    .font(.headline)
                    .lineLimit(1)

                if let subtitle {
                    Text(.init(subtitle))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)

            closeButton
        }
        .padding()
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Color
        .red
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            CardView(
                title: "This is a long title for testing",
                subtitle: "This is an ever longer subtitle for testing"
            ) {
                Text("Hello World!")
            }
            .presentationDetents([.medium, .large])
        }
}
#endif
#endif
