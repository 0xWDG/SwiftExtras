//
//  View+sizeSaver.swift
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

    /// Save the size of the view
    struct SaveSizeModifier: ViewModifier {
        @Binding var size: CGSize

        func body(content: Content) -> some View {
            content
                .background(
                    GeometryReader { proxy in
                        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                            Color.clear
                                .onAppear {
                                    size = proxy.size
                                }
                                .onChange(of: proxy.size) {
                                    size = proxy.size
                                }
                        } else {
                            Color.clear
                                .onAppear {
                                    size = proxy.size
                                }
                                .onChange(of: proxy.size) { _ in
                                    size = proxy.size
                                }
                        }
                    }
                )
        }
    }

    public extension View {
        /// Save the size of the view
        /// - Parameter size: size of view
        /// - Returns: self
        func saveSize(in size: Binding<CGSize>) -> some View {
            modifier(SaveSizeModifier(size: size))
        }
    }
#endif
