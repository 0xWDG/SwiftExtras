//
//  CaptureScrollingOffset.swift
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

public extension ScrollView {
    /// Configures the scroll view so a surrounding `ScrollViewReader` can report its progress.
    ///
    /// Apply this modifier before calling ``SwiftUI/ScrollViewReader/onScrolled(_:)``.
    /// The modifier doesn't change the accessibility hierarchy of the scroll view.
    @MainActor
    func trackScrolling() -> some View {
        let coordinateSpace = UUID()
        let state = ScrollingOffsetState(coordinateSpace: coordinateSpace)

        return self.coordinateSpace(name: coordinateSpace)
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            state.bounds = geometry.frame(in: .local)
                        }
                        .onChange(of: geometry.size) { _ in
                            state.bounds = geometry.frame(in: .local)
                        }
                }
            }
            .environment(\.scrollingOffsetState, state)
    }
}

public extension ScrollViewReader {
    /// Calls `perform` when the scroll position changes.
    ///
    /// Each component of the supplied point is normalized to `0...1`, where zero is the
    /// leading or top edge and one is the trailing or bottom edge. An axis that doesn't
    /// scroll reports zero.
    ///
    /// - Parameter perform: A closure receiving the normalized scroll position.
    @MainActor
    func onScrolled(_ perform: @escaping (UnitPoint) -> Void) -> some View {
        modifier(CaptureScrollingOffsetModifier())
            .onPreferenceChange(ScrollingOffsetPreferenceKey.self) { value in
                perform(value.normalizedPosition)
            }
    }
}

private final class ScrollingOffsetState {
    let coordinateSpace: AnyHashable
    var bounds: CGRect

    init(coordinateSpace: some Hashable, bounds: CGRect = .zero) {
        self.coordinateSpace = AnyHashable(coordinateSpace)
        self.bounds = bounds
    }
}

private struct ScrollingOffsetData: Equatable {
    let bounds: CGRect
    let content: CGRect

    var normalizedPosition: UnitPoint {
        UnitPoint(
            x: normalizedOffset(
                viewportOrigin: bounds.minX,
                contentOrigin: content.minX,
                scrollableLength: content.width - bounds.width
            ),
            y: normalizedOffset(
                viewportOrigin: bounds.minY,
                contentOrigin: content.minY,
                scrollableLength: content.height - bounds.height
            )
        )
    }

    private func normalizedOffset(
        viewportOrigin: CGFloat,
        contentOrigin: CGFloat,
        scrollableLength: CGFloat
    ) -> CGFloat {
        guard scrollableLength > 0 else {
            return 0
        }

        let offset = (viewportOrigin - contentOrigin) / scrollableLength
        return min(max((offset * 10_000).rounded() / 10_000, 0), 1)
    }
}

private struct ScrollingOffsetPreferenceKey: PreferenceKey {
    static let defaultValue = ScrollingOffsetData(bounds: .zero, content: .zero)

    static func reduce(
        value: inout ScrollingOffsetData,
        nextValue: () -> ScrollingOffsetData
    ) {
        value = nextValue()
    }
}

private struct ScrollingOffsetEnvironmentKey: EnvironmentKey {
    static let defaultValue: ScrollingOffsetState? = nil
}

private extension EnvironmentValues {
    var scrollingOffsetState: ScrollingOffsetState? {
        get { self[ScrollingOffsetEnvironmentKey.self] }
        set { self[ScrollingOffsetEnvironmentKey.self] = newValue }
    }
}

private struct CaptureScrollingOffsetModifier: ViewModifier {
    @Environment(\.scrollingOffsetState) private var state

    func body(content: Content) -> some View {
        content.background {
            if let state {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollingOffsetPreferenceKey.self,
                        value: ScrollingOffsetData(
                            bounds: state.bounds,
                            content: geometry.frame(in: .named(state.coordinateSpace))
                        )
                    )
                }
            }
        }
    }
}

#if DEBUG
private struct CaptureScrollingOffsetPreview: View {
    @State private var position = UnitPoint.zero

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Vertical progress: \(position.y, format: .percent.precision(.fractionLength(0)))")
                .font(.headline)
                .accessibilityLabel("Vertical scroll progress")
                .accessibilityValue(
                    Text(position.y, format: .percent.precision(.fractionLength(0)))
                )

            ScrollViewReader { _ in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(1...20, id: \.self) { item in
                            Text("Example row \(item)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding()
                }
                .trackScrolling()
            }
            .onScrolled { position = $0 }
        }
        .padding()
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Scroll Progress") {
    CaptureScrollingOffsetPreview()
}
#endif
#endif
