//
//  MatchedPopover.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-05.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && !os(watchOS) && !os(tvOS)
import SwiftUI

public extension View {
    /// Apply this once on a common parent to enable matched popovers.
    /// - Parameters:
    ///   - selection: The selected source identifier.
    ///   - anchor: The source anchor for each identifier.
    ///   - dismissOnBackgroundTap: Whether tapping outside the popover clears the selection.
    ///   - popover: The popover content for the selected identifier.
    /// - Returns: A view with a matched popover overlay.
    @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
    func matchedPopover<ID: Hashable, Popover: View>(
        selection: Binding<ID?>,
        anchor: @escaping (ID) -> UnitPoint = { _ in .top },
        dismissOnBackgroundTap: Bool = true,
        @ViewBuilder popover: @escaping (ID) -> Popover
    ) -> some View {
        modifier(
            MatchedPopoverContainerModifier(
                selection: selection,
                sourceAnchor: anchor,
                dismissOnBackgroundTap: dismissOnBackgroundTap,
                popover: popover
            )
        )
    }

    /// Apply this to any view that should act as a matched popover target.
    /// - Parameters:
    ///   - id: The source identifier.
    ///   - anchor: The point on the source to match against the popover.
    /// - Returns: A view registered as a matched popover source.
    @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
    func matchedPopoverSource<ID: Hashable>(
        id: ID,
        anchor: UnitPoint = .bottom
    ) -> some View {
        modifier(
            MatchedPopoverSourceModifier(
                id: id,
                sourceAnchor: anchor
            )
        )
    }
}

/// Source modifier that attaches a view to the shared namespace.
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
private struct MatchedPopoverSourceModifier<ID: Hashable>: ViewModifier {
    let id: ID
    let sourceAnchor: UnitPoint

    @Environment(\.matchedPopoverNamespace) private var namespace
    @Namespace private var fallbackNamespace

    func body(content: Content) -> some View {
        content
            .matchedGeometryEffect(
                id: id,
                in: namespace ?? fallbackNamespace,
                anchor: sourceAnchor
            )
    }
}

/// Container modifier that creates a shared namespace and draws the popover overlay.
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
private struct MatchedPopoverContainerModifier<ID: Hashable, Popover: View>: ViewModifier {
    /// External source of truth for the displayed popover.
    @Binding var selection: ID?

    /// Anchor used by the source view for matched-geometry positioning.
    let sourceAnchor: (ID) -> UnitPoint

    /// Whether a background tap clears the selection.
    let dismissOnBackgroundTap: Bool

    /// Builds the popover content.
    @ViewBuilder var popover: (ID) -> Popover

    /// Internally presented id, kept briefly separate for transitions.
    @State private var presented: ID?

    @Namespace private var namespace

    func body(content: Content) -> some View {
        ZStack {
            content
                .overlay {
                    if presented != nil && dismissOnBackgroundTap {
                        Color.clear
                            .ignoresSafeArea()
                            .contentShape(.rect)
                            .onTapGesture {
                                withAnimation {
                                    selection = nil
                                }
                            }
                            .accessibilityHidden(true)
                    }
                }

            if let id = presented {
                popover(id)
                    .matchedGeometryEffect(
                        id: id,
                        in: namespace,
                        properties: .position,
                        anchor: sourceAnchor(id).opposite,
                        isSource: false
                    )
                    .transition(
                        .opacity.combined(with: .scale)
                            .animation(.bouncy(duration: 0.3))
                    )
            }
        }
        .environment(\.matchedPopoverNamespace, namespace)
        .onAppear {
            presented = selection
        }
        .onChange(of: selection) { _, newValue in
            applySelection(newValue)
        }
    }

    private func applySelection(_ newValue: ID?) {
        guard let newValue else {
            withAnimation {
                presented = nil
            }
            return
        }

        guard let current = presented else {
            withAnimation {
                presented = newValue
            }
            return
        }

        if current == newValue {
            return
        }

        withAnimation {
            presented = nil
        } completion: {
            withAnimation {
                presented = newValue
            }
        }
    }
}

private extension UnitPoint {
    /// Returns the paired popover anchor for a source anchor.
    var opposite: UnitPoint {
        switch self {
        case .top: .bottom
        case .bottom: .top
        case .leading: .trailing
        case .trailing: .leading
        case .topLeading: .bottomTrailing
        case .topTrailing: .bottomLeading
        case .bottomLeading: .topTrailing
        case .bottomTrailing: .topLeading
        case .center: .center
        default: .center
        }
    }
}

private struct MatchedPopoverNamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID? = nil
}

private extension EnvironmentValues {
    /// Shared namespace for `matchedGeometryEffect` between sources and the overlay popover.
    var matchedPopoverNamespace: Namespace.ID? {
        get { self[MatchedPopoverNamespaceKey.self] }
        set { self[MatchedPopoverNamespaceKey.self] = newValue }
    }
}
#endif
