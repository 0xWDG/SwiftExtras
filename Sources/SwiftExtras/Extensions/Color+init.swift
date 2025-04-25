//
//  Color+init.swift
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

extension Color {
    /// Creates a Color from a PlatformColor
    /// - Parameter color: The PlatformColor to create the Color from.
    /// - Returns: A Color that represents the given PlatformColor.
    public init(_ color: PlatformColor) {
#if canImport(UIKit)
        self.init(uiColor: color)
#elseif canImport(AppKit)
        self.init(nsColor: color)
#else
        self.init(color.description)
#endif
    }
}
#endif
