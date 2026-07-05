//
//  FloatingSafeAreaBar.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-05.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//
// Taken from:
//  https://codakuma.com/floating-safe-area-bar/

#if canImport(SwiftUI)
import SwiftUI

struct FloatingSafeAreaBar<InsetContent: View>: ViewModifier {
    @ViewBuilder let insetContent: () -> InsetContent

    @ViewBuilder
    func body(content: Content) -> some View {
        #if compiler(>=6.2)
        if #available(iOS 26, macOS 26, tvOS 26, watchOS 26, *) {
            content.safeAreaBar(edge: .bottom) {
                insetContent()
                    .modifier(CardStyle())
            }
        } else {
            content.safeAreaInset(edge: .bottom) {
                insetContent()
                    .modifier(CardStyle())
                    .background {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(
                                VStack(spacing: 0) {
                                    LinearGradient(
                                        colors: [.clear, .black],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .frame(height: 30)
                                    Color.black
                                }
                            )
                            .ignoresSafeArea()
                    }
            }
        }
        #else
        content.safeAreaInset(edge: .bottom) {
            insetContent()
                .modifier(CardStyle())
                .background {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .mask(
                            VStack(spacing: 0) {
                                LinearGradient(
                                    colors: [.clear, .black],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: 30)
                                Color.black
                            }
                        )
                        .ignoresSafeArea()
                }
        }
        #endif
    }
}

private struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(.background)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 5)
            .padding()
    }
}

extension View {
    /// Adds a floating safe area bar to the view.
    /// - Parameter insetContent: A closure that returns the content to be displayed in the floating safe area bar
    /// - Returns: A view with a floating safe area bar added to it
    public func floatingSafeAreaBar<InsetContent: View>(
        @ViewBuilder insetContent: @escaping () -> InsetContent
    ) -> some View {
        modifier(FloatingSafeAreaBar(insetContent: insetContent))
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    VStack {
        Spacer()
        Text("Hello, World!")
            .floatingSafeAreaBar {
                Text("Floating Safe Area Bar")
            }
    }
}
#endif
#endif
