//
//  WStack.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-04-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// Wrapping Stack
///
/// A layout that arranges its children in a horizontal stack, wrapping to the next line when the width is exceeded.
public struct WStack: Layout {
    /// Spacing inbetween items
    var spacing: CGFloat

    /// Wrapping Stack
    ///
    /// A layout that arranges its children in a horizontal stack, wrapping to the next line when the width is exceeded.
    /// 
    /// - Parameter spacing: The spacing between the items in the stack.
    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    /// Returns the size of the composite view, given a proposed size
    /// and the view's subviews.
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        return .init(
            width: proposal.width ?? 0,
            height: maxHeight(
                proposal: proposal,
                subviews: subviews
            )
        )
    }

    /// Assigns positions to each of the layout's subviews.
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var origin = bounds.origin

        for subview in subviews {
            let fitSize = subview.sizeThatFits(proposal)

            if (origin.x + fitSize.width) > bounds.maxX {
                origin.x = bounds.minX
                origin.y += fitSize.height + spacing
                subview.place(at: origin, proposal: proposal)
                origin.x += fitSize.width + spacing
            } else {
                subview.place(at: origin, proposal: proposal)
                origin.x += fitSize.width + spacing
            }
        }
    }

    func maxHeight(
        proposal: ProposedViewSize,
        subviews: Subviews
    ) -> CGFloat {
        var origin: CGPoint = .zero

        for subview in subviews {
            let fitSize = subview.sizeThatFits(proposal)

            if (origin.x + fitSize.width) > (proposal.width ?? 0) {
                origin.x = 0
                origin.y += fitSize.height + spacing
                origin.x += fitSize.width

                if subview == subviews.last {
                    // On last row, add the y one more time
                    origin.y += fitSize.height
                }
            } else {
                origin.x += fitSize.width + spacing
                if subview == subviews.last {
                    origin.y += fitSize.height
                }
            }
        }

        return origin.y
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    List {
        WStack {
            ForEach(0..<49) { count in
                Text("Test \(count).")
                    .border(.blue)
            }
        }

        WStack {
            ForEach(0..<25) { count in
                // Edge case which previously failed
                Capsule()
                    .foregroundStyle(.blue)
                    .frame(width: 150, height: 50)
                    .border(.red)
                    .overlay {
                        Text("Test \(count).")
                    }
            }
        }
    }
}
#endif
