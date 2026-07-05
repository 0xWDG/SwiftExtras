//
//  CustomBadge.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-02.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

struct CustomBadge: ViewModifier {
    let count: Int
    let maxCountAmount: Int

    private var displayValue: String {
        count > maxCountAmount ? "\(maxCountAmount)+" : count.formatted()
    }

    private var horizontalPadding: CGFloat {
        count > 9 ? 5 : 0
    }

    func body(content: Content) -> some View {
        if count >= 1 {
            content
                .overlay(alignment: .topTrailing) {
                    badge
                }
        } else {
            content
        }
    }

    private var badge: some View {
        Text(displayValue)
            .font(.footnote.bold())
            .monospacedDigit()
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .padding(.horizontal, horizontalPadding)
            .frame(minWidth: 16, minHeight: 16)
            .background(Color.red.opacity(0.92), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(.background, lineWidth: 1)
            }
            .offset(x: 8, y: -7)
            .accessibilityHidden(true)
    }
}

extension View {
    /// Adds a custom badge to the view, displaying a count.
    ///
    /// - Parameters:
    ///   - count: The count to display in the badge. If the count is less than 1, the badge will not be shown.
    ///   - maxCountAmount: The maximum count to display before showing a "+" sign. For example, if `maxCountAmount`
    public func customBadge(_ count: Int = 0, maxCountAmount: Int = 99) -> some View {
        modifier(CustomBadge(count: count, maxCountAmount: maxCountAmount))
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    VStack {
        Button("Long Press Me") { print("Short pressed") }
             .buttonStyle(
                LongPressButtonStyle(longPressAction: { print("Long pressed!") })
             )
    }
}
#endif
#endif
