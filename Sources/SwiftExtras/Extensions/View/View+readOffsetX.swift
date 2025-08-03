//
//  View+readOffsetX.swift
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

public extension View {
    /// Read the offset of the view
    /// - Parameter offsetX: offset of view
    /// - Returns: self
    func read(offsetX: Binding<CGFloat>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: ViewOffsetXKey.self,
                        value: proxy.frame(in: .global).minX
                    )
            }
            .onPreferenceChange(ViewOffsetXKey.self) { minX in
                let diff = abs(offsetX.wrappedValue - minX)
                if diff > 1.0 {
                    offsetX.wrappedValue = minX
                }
            }
        )
    }
}

struct ViewOffsetXKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// Save the frame of the view
struct ReadFrameModifier: ViewModifier {
    @Binding var frame: CGRect

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    if #available(
                        iOS 17.0,
                        macOS 14.0,
                        tvOS 17.0,
                        watchOS 10.0,
                        *
                    ) {
                        Color.clear
                            .onAppear {
                                frame = proxy.frame(in: .global)
                            }
                            .onChange(of: proxy.size) {
                                frame = proxy.frame(in: .global)
                            }
                    } else {
                        Color.clear
                            .onAppear {
                                frame = proxy.frame(in: .global)
                            }
                            .onChange(of: proxy.size) { _ in
                                frame = proxy.frame(in: .global)
                            }
                    }
                }
            )
    }
}

public extension View {
    /// Save the frame of the view
    /// - Parameter frame: frame of view
    /// - Returns: self
    func read(frame: Binding<CGRect>) -> some View {
        modifier(ReadFrameModifier(frame: frame))
    }
}
#endif
