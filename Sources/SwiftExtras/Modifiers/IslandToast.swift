//
//  IslandToast.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A value that can drive an island toast presentation.
public typealias IslandToastItem = Hashable

/// A bottom-anchored, non-blocking toast presentation.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct IslandToast<Item: IslandToastItem>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding private var item: Item?
    @State private var displayedCard: IslandToastCard?
    @State private var isExpanded = false
    @State private var presentationTask: Task<Void, Never>?
    @Namespace private var glassNamespace

    private let contentBuilder: (Item) -> IslandToastCard
    private let morphAnimation: Animation = .spring(response: 0.32, dampingFraction: 0.78)
    private let compactHoldDuration: Duration = .milliseconds(140)

    /// Creates an island toast presentation.
    ///
    /// - Parameters:
    ///   - item: The optional value controlling presentation.
    ///   - contentBuilder: A closure that creates a card for the presented value.
    public init(
        item: Binding<Item?>,
        contentBuilder: @escaping (Item) -> IslandToastCard
    ) {
        _item = item
        self.contentBuilder = contentBuilder
    }

    /// Adds the toast presentation to `content`.
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                overlayHost
            }
            .onAppear {
                handleItemChange(item)
            }
            .onChange(of: item) { newItem in
                handleItemChange(newItem)
            }
            .onDisappear {
                presentationTask?.cancel()
            }
    }

    @ViewBuilder
    private var overlayHost: some View {
        if let card = displayedCard {
            styledToast(card: card)
        }
    }

    private func styledToast(card: IslandToastCard) -> AnyView {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            return AnyView(
                GlassEffectContainer {
                    toastContent(card: card)
                        .glassEffect(
                            isExpanded ? .regular.interactive() : .regular,
                            in: .rect(cornerRadius: 20)
                        )
                        .glassEffectID(Self.glassID, in: glassNamespace)
                }
                .transition(toastTransition)
            )
        }

        return AnyView(
            toastContent(card: card)
                .background(
                    Color.primary.opacity(0.12),
                    in: RoundedRectangle(cornerRadius: 20)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.secondary.opacity(0.35))
                }
                .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                .transition(toastTransition)
        )
    }

    private func toastContent(card: IslandToastCard) -> some View {
        Button {
            handleTap()
        } label: {
            Group {
                if isExpanded {
                    card.expanded
                } else {
                    card.compact
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isExpanded == false)
        .accessibilityLabel(Text(card.title))
        .accessibilityHint(Text(accessibilityHint(for: card)))
        .padding(.bottom, 8)
        .padding(.horizontal)
        .animation(reduceMotion ? nil : morphAnimation, value: isExpanded)
    }

    private var toastTransition: AnyTransition {
        reduceMotion
            ? .opacity
            : .opacity.combined(with: .scale(scale: 0.9, anchor: .bottom))
    }

    private static var glassID: String { "islandToast" }

    private func accessibilityHint(for card: IslandToastCard) -> String {
        if card.action == nil {
            return "Dismisses the notification"
        }

        return "Performs the action and dismisses the notification"
    }

    private func handleItemChange(_ newItem: Item?) {
        presentationTask?.cancel()

        guard let newItem else {
            guard displayedCard != nil else {
                return
            }

            presentationTask = Task { @MainActor in
                await dismissPresentedCard()
            }
            return
        }

        let card = contentBuilder(newItem)
        presentationTask = Task { @MainActor in
            await present(card)
        }
    }

    @MainActor
    private func present(_ card: IslandToastCard) async {
        displayedCard = card
        isExpanded = horizontalSizeClass != .compact || reduceMotion

        if isExpanded == false {
            try? await Task.sleep(for: compactHoldDuration)
            guard Task.isCancelled == false else {
                return
            }
            withAnimation(morphAnimation) {
                isExpanded = true
            }
        }

        guard let duration = card.duration else {
            return
        }

        try? await Task.sleep(for: duration)
        guard Task.isCancelled == false else {
            return
        }
        item = nil
    }

    @MainActor
    private func dismissPresentedCard() async {
        if horizontalSizeClass == .compact && reduceMotion == false {
            withAnimation(morphAnimation) {
                isExpanded = false
            }
            try? await Task.sleep(for: compactHoldDuration)
            guard Task.isCancelled == false else {
                return
            }
        }

        withAnimation(reduceMotion ? nil : morphAnimation) {
            displayedCard = nil
            isExpanded = false
        }
    }

    private func handleTap() {
        displayedCard?.action?()
        item = nil
    }
}

public extension View {
    /// Presents a bottom-anchored toast while `item` is non-nil.
    ///
    /// - Parameters:
    ///   - item: The source of truth controlling presentation.
    ///   - content: A closure that creates a card for the presented value.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func islandToast<Item: IslandToastItem>(
        item: Binding<Item?>,
        content: @escaping (Item) -> IslandToastCard
    ) -> some View {
        modifier(IslandToast(item: item, contentBuilder: content))
    }
}

#if DEBUG
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
private struct IslandToastPreview: View {
    private enum Toast: Hashable {
        case saved
    }

    @State private var toast: Toast? = .saved

    var body: some View {
        VStack(spacing: 16) {
            Text("Island Toast")
                .font(.title)

            Button("Show saved notification") {
                toast = .saved
            }
            .accessibilityHint("Shows a confirmation at the bottom of the preview")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .islandToast(item: $toast) { _ in
            IslandToastCard(
                title: "Changes saved",
                subtitle: "The preview uses deterministic local content.",
                role: .success,
                duration: nil
            )
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Island Toast") {
    IslandToastPreview()
}
#endif
#endif
