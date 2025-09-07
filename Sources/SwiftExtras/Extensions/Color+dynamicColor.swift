//
//  Color+dynamicColor.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

#if canImport(AppKit)
extension Color {
    static func dynamicColor(light: NSColor, dark: NSColor, named: String = "DynamicColor") -> Color {
        return Color(
            NSColor(
                name: named,
                dynamicProvider: { traits in
                    if traits.name == .darkAqua || traits.name == .vibrantDark {
                        return light
                    } else {
                        return dark
                    }
                }
            )
        )
    }
}
#endif

#if canImport(UIKit)
extension Color {
    static func dynamicColor(light: UIColor, dark: UIColor, named: String = "DynamicColor") -> Color {
#if os(watchOS)
        return Color(dark)
#else
        return Color(
            UIColor(
                dynamicProvider: { trait in
                    return trait.userInterfaceStyle == .dark ? dark : light
                }
            )
        )
#endif
    }
}
#endif
#endif
