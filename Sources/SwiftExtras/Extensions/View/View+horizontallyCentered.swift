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
public extension View {
    /// Horizontally centers the view by embedding it
    /// in a HStack bookended by Spacers.
    func horizontallyCentered() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}
#endif
