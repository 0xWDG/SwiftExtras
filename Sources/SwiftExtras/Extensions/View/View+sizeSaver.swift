//
//  View+saveSize.swift
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

extension View {
    /// Save the size of the view
    /// - Parameter size: size of view
    /// - Returns: self
    public func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SaveSizeModifier(size: size))
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
private struct SaveSizePreview: View {
    @State private var size = CGSize.zero

    var body: some View {
        VStack {
            Text("Measure this view")
                .padding()
                .background(.orange.opacity(0.2), in: Capsule())
                .saveSize(in: $size)

            (
                Text("\(size.width, format: .number.precision(.fractionLength(0))) × ")
                    + Text("\(size.height, format: .number.precision(.fractionLength(0))) points")
            )
            .accessibilityLabel("Measured size")
        }
        .padding()
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Saved Size") {
    SaveSizePreview()
}
#endif
#endif
