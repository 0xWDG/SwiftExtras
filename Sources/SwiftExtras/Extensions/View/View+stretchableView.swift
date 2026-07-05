//
//  View+stretchy.swift
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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Stretch when the scroll view is pulled past its start edge (top/leading).
    /// - Parameters:
    ///   - axis: .vertical for vertical ScrollView, .horizontal for horizontal ScrollView
    ///   - uniform: if true, scales both axes. If false, scales only along `axis`.
    @available(iOS 17.0, *)
    @ViewBuilder
    public func stretchableView(
        axis: Axis = .vertical,
        uniform: Bool = true
    ) -> some View {
        visualEffect { effect, geometry in
            let frame = geometry.frame(in: .scrollView)

            let offset: CGFloat
            let currentLength: CGFloat

            switch axis {
            case .vertical:
                offset = frame.minY
                currentLength = geometry.size.height
            case .horizontal:
                offset = frame.minX
                currentLength = geometry.size.width
            }

            let positiveOffset = max(0, offset)
            let scale = (currentLength + positiveOffset) / max(currentLength, 0.0001)

            let resolvedAnchor: UnitPoint = axis == .vertical ? .bottom : .trailing

            if uniform {
                return effect.scaleEffect(
                    x: scale,
                    y: scale,
                    anchor: resolvedAnchor
                )
            } else {
                return effect.scaleEffect(
                    x: axis == .horizontal ? scale : 1,
                    y: axis == .vertical ? scale : 1,
                    anchor: resolvedAnchor
                )
            }
        }
    }
}
#endif
