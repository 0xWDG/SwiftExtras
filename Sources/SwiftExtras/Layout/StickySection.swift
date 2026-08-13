//
//  StickySection.swift
//  SwiftExtras
//
//  Created by Balaji Venkatesh on 2026-06-20.
//  https://github.com/0xWDG/SwiftExtras
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A scroll-aware section whose header remains visible while its content collapses.
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
public struct StickySection<Content: View, Header: View, MinimizedHeader: View>: View {
    /// Visual and scrolling behavior for a sticky section.
    public struct Configuration {
        /// The padding inside the section.
        public var sectionPadding: CGFloat
        /// The section's corner radius.
        public var cornerRadius: CGFloat
        /// The fallback background style.
        public var background: AnyShapeStyle
        /// Whether to use Liquid Glass when it is available.
        public var usesGlassBackground: Bool
        /// The vertical adjustment applied to the minimized header.
        public var minimizedHeaderOffset: CGFloat
        /// The distance over which the full header fades.
        public var headerFadeDistance: CGFloat
        /// The distance over which the entire section fades near its end.
        public var fadeDistance: CGFloat
        /// The maximum scale reduction applied while fading.
        public var fadeScale: CGFloat

        /// Creates sticky-section configuration.
        public init(
            sectionPadding: CGFloat = 15,
            cornerRadius: CGFloat = 20,
            background: AnyShapeStyle = AnyShapeStyle(.fill.tertiary),
            usesGlassBackground: Bool = false,
            minimizedHeaderOffset: CGFloat = -10,
            headerFadeDistance: CGFloat = 15,
            fadeDistance: CGFloat = 45,
            fadeScale: CGFloat = 0.05
        ) {
            self.sectionPadding = sectionPadding
            self.cornerRadius = cornerRadius
            self.background = background
            self.usesGlassBackground = usesGlassBackground
            self.minimizedHeaderOffset = minimizedHeaderOffset
            self.headerFadeDistance = headerFadeDistance
            self.fadeDistance = fadeDistance
            self.fadeScale = fadeScale
        }
    }

    private let configuration: Configuration
    private let spacing: CGFloat
    private let content: Content
    private let header: Header
    private let minimizedHeader: MinimizedHeader
    @State private var headerSize = CGSize.zero

    /// Creates a sticky section.
    ///
    /// Place the section inside a vertical `ScrollView`. The regular header fades
    /// into the minimized header as the section reaches the top edge.
    /// - Parameters:
    ///   - configuration: Visual and scrolling behavior for the section.
    ///   - spacing: Spacing between the header and content.
    ///   - content: The section's scrolling content.
    ///   - header: The section's full header.
    ///   - minimizedHeader: The compact header displayed while pinned.
    public init(
        configuration: Configuration = Configuration(),
        spacing: CGFloat = 10,
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header,
        @ViewBuilder minimizedHeader: () -> MinimizedHeader
    ) {
        self.configuration = configuration
        self.spacing = spacing
        self.content = content()
        self.header = header()
        self.minimizedHeader = minimizedHeader()
    }

    /// The scroll-aware section content.
    public var body: some View {
        let sectionPadding = configuration.sectionPadding
        let minimizedHeaderOffset = configuration.minimizedHeaderOffset
        let fadeDistance = configuration.fadeDistance
        let fadeScale = configuration.fadeScale

        VStack(alignment: .leading, spacing: spacing) {
            headerView
            contentView
        }
        .mask(sectionMask)
        .background(sectionBackground)
        .compositingGroup()
        .visualEffect { [headerSize] content, proxy in
            let minimumY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let headerHeight = headerSize.height
                + sectionPadding
                + minimizedHeaderOffset
            let cutoffHeight = proxy.size.height - headerHeight
            let distance = abs(min(cutoffHeight + minimumY, 0))
            let progress = stickySectionProgress(distance, over: fadeDistance)
            let scale = 1 - (progress * fadeScale)

            return content
                .scaleEffect(scale, anchor: .top)
                .opacity(1 - progress)
                .offset(y: minimumY < 0 ? -minimumY : 0)
        }
        .coordinateSpace(.named(stickySectionCoordinateSpaceName))
    }

    private var headerView: some View {
        let sectionPadding = configuration.sectionPadding
        let minimizedHeaderOffset = configuration.minimizedHeaderOffset
        let headerFadeDistance = configuration.headerFadeDistance

        return header
            .visualEffect { content, proxy in
                let minimumY = max(
                    proxy.frame(in: .named(stickySectionCoordinateSpaceName)).minY
                        - sectionPadding,
                    0
                )
                let progress = stickySectionProgress(minimumY, over: headerFadeDistance)
                return content.opacity(1 - progress)
            }
            .background {
                minimizedHeader
                    .frame(maxHeight: .infinity)
                    .offset(y: minimizedHeaderOffset / 2)
                    .visualEffect { content, proxy in
                        let minimumY = max(
                            proxy.frame(in: .named(stickySectionCoordinateSpaceName)).minY
                                - sectionPadding
                                - headerFadeDistance,
                            0
                        )
                        let progress = stickySectionProgress(
                            minimumY,
                            over: headerFadeDistance
                        )
                        return content.opacity(progress)
                    }
            }
            .padding([.horizontal, .top], sectionPadding)
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newSize in
                headerSize = newSize
            }
    }

    private var contentView: some View {
        let sectionPadding = configuration.sectionPadding

        return content
            .padding([.horizontal, .bottom], sectionPadding)
            .visualEffect { content, proxy in
                let namedMinimumY = proxy.frame(
                    in: .named(stickySectionCoordinateSpaceName)
                ).minY
                let scrollMinimumY = proxy.frame(in: .scrollView(axis: .vertical)).minY
                let offset = max(namedMinimumY - scrollMinimumY, 0)
                return content.offset(y: -offset)
            }
            .clipped()
    }

    private var sectionMask: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .padding(.bottom, bottomPadding(for: proxy))
        }
    }

    @ViewBuilder
    private var sectionBackground: some View {
        GeometryReader { proxy in
            backgroundShape
                .padding(.bottom, bottomPadding(for: proxy))
        }
    }

    @ViewBuilder
    private var backgroundShape: some View {
        #if compiler(>=6.2)
        if #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *),
           configuration.usesGlassBackground {
            Rectangle()
                .fill(.clear)
                .glassEffect(.regular, in: .rect(cornerRadius: configuration.cornerRadius))
        } else {
            fallbackBackground
        }
        #else
        fallbackBackground
        #endif
    }

    private var fallbackBackground: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius)
            .fill(configuration.background)
    }

    private func bottomPadding(for proxy: GeometryProxy) -> CGFloat {
        let minimumY = proxy.frame(in: .named(stickySectionCoordinateSpaceName)).minY
        let headerHeight = headerSize.height
            + configuration.sectionPadding
            + configuration.minimizedHeaderOffset
        return min(max(minimumY, 0), max(proxy.size.height - headerHeight, 0))
    }

}

private let stickySectionCoordinateSpaceName = "SwiftExtras.StickySection"

private func stickySectionProgress(_ distance: CGFloat, over totalDistance: CGFloat) -> CGFloat {
    guard totalDistance > 0 else { return distance > 0 ? 1 : 0 }
    return max(min(distance / totalDistance, 1), 0)
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    ScrollView {
        StickySection {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(1...8, id: \.self) { item in
                    Text("Section item \(item)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } header: {
            Text("Recent activity")
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
        } minimizedHeader: {
            Text("Activity")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
        }
    }
    .padding()
}
#endif
#endif
