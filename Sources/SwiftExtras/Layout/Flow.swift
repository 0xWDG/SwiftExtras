//
//  Flow.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A layout that arranges its subviews in horizontal lines and wraps them as needed.
public struct Flow: Layout {
    public typealias Cache = [[CGRect]]

    private struct PartialRect {
        let offsetX: CGFloat
        let size: CGSize
    }

    /// The alignment applied to the subviews on each line.
    public let lineAlignment: Alignment

    /// The horizontal and vertical spacing between subviews and lines.
    public let spacing: CGSize

    /// Creates a flow layout.
    ///
    /// - Parameters:
    ///   - alignment: The alignment applied to the subviews on each line.
    ///   - spacing: The horizontal and vertical spacing between subviews and lines.
    public init(
        lineAlignment alignment: Alignment = .topLeading,
        spacing: CGSize
    ) {
        lineAlignment = alignment
        self.spacing = spacing
    }

    /// Creates an empty layout cache.
    public func makeCache(subviews: Subviews) -> Cache {
        Cache()
    }

    /// Returns the size needed to arrange all subviews in flowing lines.
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize {
        cache = []

        guard subviews.isEmpty == false else {
            return .zero
        }

        let measuredSizes = subviews.map { $0.sizeThatFits(proposal) }
        let availableWidth = proposal.width ?? measuredSizes.reduce(0) {
            max($0, $1.width)
        }

        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        var currentLine: [PartialRect] = []

        for measuredSize in measuredSizes {
            let size = CGSize(
                width: min(availableWidth, measuredSize.width),
                height: measuredSize.height
            )

            if currentLine.isEmpty == false,
               offsetX + size.width > availableWidth {
                offsetY += commit(
                    line: currentLine,
                    offsetY: offsetY,
                    width: availableWidth,
                    cache: &cache
                )
                offsetX = 0
                currentLine = []
            }

            currentLine.append(
                PartialRect(
                    offsetX: offsetX,
                    size: size
                )
            )
            offsetX += size.width + spacing.width
        }

        if currentLine.isEmpty == false {
            commit(
                line: currentLine,
                offsetY: offsetY,
                width: availableWidth,
                cache: &cache
            )
        }

        let frames = cache.flatMap { $0 }

        return CGSize(
            width: frames.reduce(0) { max($0, $1.maxX) },
            height: frames.reduce(0) { max($0, $1.maxY) }
        )
    }

    /// Places each subview using the frames calculated during measurement.
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        let frames = cache.flatMap { $0 }

        for (subview, frame) in zip(subviews, frames) {
            subview.place(
                at: CGPoint(
                    x: bounds.minX + frame.minX,
                    y: bounds.minY + frame.minY
                ),
                proposal: ProposedViewSize(frame.size)
            )
        }
    }

    @discardableResult
    private func commit(
        line: [PartialRect],
        offsetY: CGFloat,
        width: CGFloat,
        cache: inout Cache
    ) -> CGFloat {
        let height = line.reduce(0) { max($0, $1.size.height) }
        let contentWidth = line.reduce(0) { max($0, $1.offsetX + $1.size.width) }
        let remainingWidth = width - contentWidth

        let lineOffsetX: CGFloat
        switch lineAlignment.horizontal {
        case .trailing:
            lineOffsetX = remainingWidth
        case .center:
            lineOffsetX = remainingWidth / 2
        default:
            lineOffsetX = 0
        }

        let frames = line.map { partialRect in
            let remainingHeight = height - partialRect.size.height
            let lineOffsetY: CGFloat

            switch lineAlignment.vertical {
            case .bottom:
                lineOffsetY = remainingHeight
            case .center:
                lineOffsetY = remainingHeight / 2
            default:
                lineOffsetY = 0
            }

            return CGRect(
                x: partialRect.offsetX + lineOffsetX,
                y: offsetY + lineOffsetY,
                width: partialRect.size.width,
                height: partialRect.size.height
            )
        }

        cache.append(frames)
        return height + spacing.height
    }
}

public extension Flow {
    /// Creates a flow layout with independent horizontal and vertical spacing.
    init(
        lineAlignment alignment: Alignment = .topLeading,
        spacingHorizontal: CGFloat = 0,
        spacingVertical: CGFloat = 0
    ) {
        self.init(
            lineAlignment: alignment,
            spacing: CGSize(
                width: spacingHorizontal,
                height: spacingVertical
            )
        )
    }

    /// Creates a flow layout with equal horizontal and vertical spacing.
    init(
        lineAlignment alignment: Alignment = .topLeading,
        spacing: CGFloat
    ) {
        self.init(
            lineAlignment: alignment,
            spacing: CGSize(width: spacing, height: spacing)
        )
    }
}

#if DEBUG
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Wrapping Tags") {
    Flow(lineAlignment: .center, spacing: 8) {
        ForEach(["Swift", "SwiftUI", "Layout", "Accessibility"], id: \.self) { tag in
            Text(tag)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.blue.opacity(0.15), in: Capsule())
        }
    }
    .padding()
}
#endif
#endif
