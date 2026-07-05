//
//  SpotlightOnboarding.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-05.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//
//  Based on https://livsycode.com/swiftui/a-reusable-spotlight-onboarding-component-in-swiftui/
//

// swiftlint:disable file_length

#if canImport(SwiftUI)
import SwiftUI

/// A type-erased shape used by spotlight onboarding targets.
public struct TutorialSpotlightShape: Shape {
    private let makePath: @Sendable (CGRect) -> Path

    /// Creates a spotlight shape from any SwiftUI shape.
    /// - Parameter shape: The shape used to draw the spotlight cutout.
    public init<S: Shape & Sendable>(_ shape: S) {
        self.makePath = { rect in
            shape.path(in: rect)
        }
    }

    /// Creates a rounded rectangle spotlight shape.
    /// - Parameters:
    ///   - cornerRadius: The rounded rectangle corner radius.
    ///   - style: The rounded corner style.
    /// - Returns: A rounded rectangle spotlight shape.
    public static func rect(
        cornerRadius: CGFloat,
        style: RoundedCornerStyle = .continuous
    ) -> TutorialSpotlightShape {
        TutorialSpotlightShape(
            RoundedRectangle(cornerRadius: cornerRadius, style: style)
        )
    }

    /// A rectangular spotlight shape.
    public static var rect: TutorialSpotlightShape {
        TutorialSpotlightShape(Rectangle())
    }

    /// A circular spotlight shape.
    public static var circle: TutorialSpotlightShape {
        TutorialSpotlightShape(Circle())
    }

    /// A capsule spotlight shape.
    public static var capsule: TutorialSpotlightShape {
        TutorialSpotlightShape(Capsule())
    }

    public func path(in rect: CGRect) -> Path {
        makePath(rect)
    }
}

/// Actions available to a spotlight onboarding overlay.
public struct TutorialSpotlightActions {
    /// Dismisses the spotlight flow.
    public let dismiss: () -> Void

    /// Moves to the previous registered spotlight target.
    public let previous: () -> Void

    /// Moves to the next registered spotlight target.
    public let advance: () -> Void
}

public extension View {
    /// Adds a spotlight onboarding overlay to a parent view.
    ///
    /// Attach this modifier to a common ancestor of all views marked with
    /// `tutorialSpotlightSource(id:)`.
    /// - Parameters:
    ///   - selection: The currently selected spotlight target ID.
    ///   - orderedIDs: The ordered spotlight target IDs used by previous and next actions.
    ///   - spotlightPadding: The padding applied around the highlighted view.
    ///   - cornerRadius: The default rounded rectangle corner radius.
    ///   - animationDuration: The duration used when changing spotlight targets.
    ///   - dimmingOpacity: The opacity of the dimming overlay.
    ///   - dismissOnBackgroundTap: Whether tapping the dimmed background dismisses the flow.
    ///   - overlay: The custom overlay card shown for the selected target.
    /// - Returns: A view with spotlight onboarding applied.
    func tutorialSpotlight<ID: Hashable, Overlay: View>(
        selection: Binding<ID?>,
        orderedIDs: [ID],
        spotlightPadding: CGFloat = 8,
        cornerRadius: CGFloat = 28,
        animationDuration: TimeInterval = 0.25,
        dimmingOpacity: CGFloat = 0.58,
        dismissOnBackgroundTap: Bool = true,
        @ViewBuilder overlay: @escaping (_ id: ID, _ actions: TutorialSpotlightActions) -> Overlay
    ) -> some View {
        tutorialSpotlight(
            selection: selection,
            orderedIDs: orderedIDs,
            spotlightPadding: spotlightPadding,
            spotlightShape: .rect(cornerRadius: cornerRadius),
            animationDuration: animationDuration,
            dimmingOpacity: dimmingOpacity,
            dismissOnBackgroundTap: dismissOnBackgroundTap,
            overlay: overlay
        )
    }

    /// Adds a spotlight onboarding overlay to a parent view.
    ///
    /// Attach this modifier to a common ancestor of all views marked with
    /// `tutorialSpotlightSource(id:)`.
    /// - Parameters:
    ///   - selection: The currently selected spotlight target ID.
    ///   - orderedIDs: The ordered spotlight target IDs used by previous and next actions.
    ///   - spotlightPadding: The padding applied around the highlighted view.
    ///   - spotlightShape: The default spotlight shape.
    ///   - animationDuration: The duration used when changing spotlight targets.
    ///   - dimmingOpacity: The opacity of the dimming overlay.
    ///   - dismissOnBackgroundTap: Whether tapping the dimmed background dismisses the flow.
    ///   - overlay: The custom overlay card shown for the selected target.
    /// - Returns: A view with spotlight onboarding applied.
    func tutorialSpotlight<ID: Hashable, Overlay: View>(
        selection: Binding<ID?>,
        orderedIDs: [ID],
        spotlightPadding: CGFloat = 8,
        spotlightShape: TutorialSpotlightShape = .rect(cornerRadius: 28),
        animationDuration: TimeInterval = 0.25,
        dimmingOpacity: CGFloat = 0.58,
        dismissOnBackgroundTap: Bool = true,
        @ViewBuilder overlay: @escaping (_ id: ID, _ actions: TutorialSpotlightActions) -> Overlay
    ) -> some View {
        modifier(
            TutorialSpotlightContainerModifier(
                selection: selection,
                orderedIDs: orderedIDs,
                spotlightPadding: spotlightPadding,
                spotlightShape: spotlightShape,
                animationDuration: animationDuration,
                dimmingOpacity: dimmingOpacity,
                dismissOnBackgroundTap: dismissOnBackgroundTap,
                overlay: overlay
            )
        )
    }

    /// Registers this view as a spotlight onboarding target.
    /// - Parameter id: The stable target ID.
    /// - Returns: A view that reports its bounds to a parent `tutorialSpotlight` container.
    func tutorialSpotlightSource<ID: Hashable>(id: ID) -> some View {
        tutorialSpotlightSource(id: id, spotlightShape: nil)
    }

    /// Registers this view as a spotlight onboarding target with a custom shape.
    /// - Parameters:
    ///   - id: The stable target ID.
    ///   - spotlightShape: The spotlight shape used for this target.
    /// - Returns: A view that reports its bounds to a parent `tutorialSpotlight` container.
    func tutorialSpotlightSource<ID: Hashable>(
        id: ID,
        spotlightShape: TutorialSpotlightShape
    ) -> some View {
        tutorialSpotlightSource(id: id, spotlightShape: spotlightShape as TutorialSpotlightShape?)
    }

    private func tutorialSpotlightSource<ID: Hashable>(
        id: ID,
        spotlightShape: TutorialSpotlightShape?
    ) -> some View {
        modifier(
            TutorialSpotlightSourceModifier(
                id: id,
                spotlightShape: spotlightShape
            )
        )
    }
}

private struct TutorialSpotlightTarget {
    let bounds: Anchor<CGRect>
    let spotlightShape: TutorialSpotlightShape?
}

private struct TutorialSpotlightPreferenceKey<ID: Hashable>: PreferenceKey {
    static var defaultValue: [ID: TutorialSpotlightTarget] {
        [:]
    }

    static func reduce(
        value: inout [ID: TutorialSpotlightTarget],
        nextValue: () -> [ID: TutorialSpotlightTarget]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}

private struct TutorialSpotlightSourceModifier<ID: Hashable>: ViewModifier {
    let id: ID
    let spotlightShape: TutorialSpotlightShape?

    func body(content: Content) -> some View {
        content.anchorPreference(
            key: TutorialSpotlightPreferenceKey<ID>.self,
            value: .bounds
        ) { anchor in
            [
                id: TutorialSpotlightTarget(
                    bounds: anchor,
                    spotlightShape: spotlightShape
                )
            ]
        }
    }
}

private struct TutorialSpotlightContainerModifier<ID: Hashable, Overlay: View>: ViewModifier {
    @Binding var selection: ID?

    let orderedIDs: [ID]
    let spotlightPadding: CGFloat
    let spotlightShape: TutorialSpotlightShape
    let animationDuration: TimeInterval
    let dimmingOpacity: CGFloat
    let dismissOnBackgroundTap: Bool
    let overlay: (_ id: ID, _ actions: TutorialSpotlightActions) -> Overlay

    @State private var overlaySize: CGSize = .zero

    func body(content: Content) -> some View {
        content.overlayPreferenceValue(TutorialSpotlightPreferenceKey<ID>.self) { preferences in
            GeometryReader { proxy in
                let containerBounds = proxy.frame(in: .local)

                TutorialSpotlightOverlay(
                    selection: $selection,
                    orderedIDs: orderedIDs,
                    preferences: preferences,
                    containerBounds: containerBounds,
                    proxy: proxy,
                    spotlightPadding: spotlightPadding,
                    defaultSpotlightShape: spotlightShape,
                    animationDuration: animationDuration,
                    dimmingOpacity: dimmingOpacity,
                    dismissOnBackgroundTap: dismissOnBackgroundTap,
                    overlaySize: $overlaySize,
                    overlay: overlay
                )
            }
            .allowsHitTesting(selection.map { preferences[$0] != nil } ?? false)
        }
    }
}

private struct TutorialSpotlightOverlay<ID: Hashable, Overlay: View>: View {
    @Binding var selection: ID?

    let orderedIDs: [ID]
    let preferences: [ID: TutorialSpotlightTarget]
    let containerBounds: CGRect
    let proxy: GeometryProxy
    let spotlightPadding: CGFloat
    let defaultSpotlightShape: TutorialSpotlightShape
    let animationDuration: TimeInterval
    let dimmingOpacity: CGFloat
    let dismissOnBackgroundTap: Bool
    @Binding var overlaySize: CGSize
    let overlay: (_ id: ID, _ actions: TutorialSpotlightActions) -> Overlay

    var body: some View {
        ZStack {
            if let selected = selection,
               let target = preferences[selected] {
                let targetFrame = proxy[target.bounds]
                let focusFrame = targetFrame.insetBy(
                    dx: -spotlightPadding,
                    dy: -spotlightPadding
                )
                let shape = target.spotlightShape ?? defaultSpotlightShape
                let actions = spotlightActions(for: preferences)

                TutorialSpotlightCutoutShape(
                    focusFrame: focusFrame,
                    spotlightShape: shape
                )
                .fill(
                    Color.black.opacity(dimmingOpacity),
                    style: FillStyle(eoFill: true)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    guard dismissOnBackgroundTap else { return }
                    actions.dismiss()
                }
                .accessibilityHidden(true)

                overlay(selected, actions)
                    .frame(maxWidth: maxOverlayWidth(in: containerBounds))
                    .background {
                        GeometryReader { overlayProxy in
                            Color.clear.preference(
                                key: TutorialSizeKey.self,
                                value: overlayProxy.size
                            )
                        }
                    }
                    .position(
                        overlayPosition(
                            for: focusFrame,
                            overlaySize: overlaySize,
                            in: containerBounds
                        )
                    )
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: animationDuration), value: selection)
        .onPreferenceChange(TutorialSizeKey.self) { size in
            overlaySize = size
        }
    }

    private func spotlightActions(for preferences: [ID: TutorialSpotlightTarget]) -> TutorialSpotlightActions {
        TutorialSpotlightActions(
            dismiss: {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    selection = nil
                }
            },
            previous: {
                moveSelection(by: -1, registeredIDs: preferences.keys)
            },
            advance: {
                moveSelection(by: 1, registeredIDs: preferences.keys)
            }
        )
    }

    private func moveSelection(by offset: Int, registeredIDs: Dictionary<ID, TutorialSpotlightTarget>.Keys) {
        guard let currentSelection = selection,
              let currentIndex = orderedIDs.firstIndex(of: currentSelection) else {
            withAnimation(.easeInOut(duration: animationDuration)) {
                selection = nil
            }
            return
        }

        let nextID = nextRegisteredID(
            from: currentIndex,
            offset: offset,
            registeredIDs: registeredIDs
        )

        withAnimation(.easeInOut(duration: animationDuration)) {
            selection = nextID
        }
    }

    private func nextRegisteredID(
        from currentIndex: Array<ID>.Index,
        offset: Int,
        registeredIDs: Dictionary<ID, TutorialSpotlightTarget>.Keys
    ) -> ID? {
        var index = currentIndex + offset

        while orderedIDs.indices.contains(index) {
            let candidate = orderedIDs[index]
            if registeredIDs.contains(candidate) {
                return candidate
            }
            index += offset
        }

        return nil
    }

    private func maxOverlayWidth(in container: CGRect) -> CGFloat {
        max(0, min(320, container.width - 32))
    }

    private func overlayPosition(
        for focusFrame: CGRect,
        overlaySize: CGSize,
        in container: CGRect
    ) -> CGPoint {
        let horizontalPadding: CGFloat = 16
        let verticalSpacing: CGFloat = 24
        let verticalPadding: CGFloat = 24

        let maxOverlayWidth = maxOverlayWidth(in: container)
        let measuredWidth = overlaySize.width > 0 ? overlaySize.width : maxOverlayWidth
        let measuredHeight = overlaySize.height > 0 ? overlaySize.height : 180
        let overlayWidth = min(measuredWidth, maxOverlayWidth)

        let centeredX = min(
            max(focusFrame.midX, container.minX + horizontalPadding + overlayWidth / 2),
            container.maxX - horizontalPadding - overlayWidth / 2
        )

        let preferredBelowY = focusFrame.maxY + verticalSpacing + measuredHeight / 2
        if preferredBelowY + measuredHeight / 2 <= container.maxY - verticalPadding {
            return CGPoint(x: centeredX, y: preferredBelowY)
        }

        let preferredAboveY = focusFrame.minY - verticalSpacing - measuredHeight / 2
        let clampedY = min(
            max(preferredAboveY, container.minY + verticalPadding + measuredHeight / 2),
            container.maxY - verticalPadding - measuredHeight / 2
        )

        return CGPoint(x: centeredX, y: clampedY)
    }
}

private struct TutorialSpotlightCutoutShape: Shape {
    let focusFrame: CGRect
    let spotlightShape: TutorialSpotlightShape

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        path.addPath(spotlightShape.path(in: focusFrame))
        return path
    }
}

private struct TutorialSizeKey: PreferenceKey {
    static var defaultValue: CGSize {
        .zero
    }

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
#endif
