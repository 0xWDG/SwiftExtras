//
//  View+horizontallyCentered.swift
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

@available(macOS 10.15, iOS 13, watchOS 6.0, tvOS 13.0, *)
extension View {
    /// Horizontally centers the view by embedding it
    /// in a HStack bookended by Spacers.
    public func horizontallyCentered() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Horizontally Centered") {
    Text("Centered content")
        .padding(8)
        .background(.blue.opacity(0.15), in: Capsule())
        .horizontallyCentered()
        .padding()
}
#endif
#endif
