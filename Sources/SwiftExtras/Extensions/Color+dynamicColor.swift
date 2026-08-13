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

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
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

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Dynamic Color") {
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    let color = Color.dynamicColor(light: .systemYellow, dark: .systemBlue)
#elseif os(watchOS)
    let color = Color.dynamicColor(
        light: UIColor(red: 1, green: 0.8, blue: 0, alpha: 1),
        dark: UIColor(red: 0, green: 0.4, blue: 1, alpha: 1)
    )
#else
    let color = Color.dynamicColor(light: .systemYellow, dark: .systemBlue)
#endif

    HStack {
        Text("Light")
            .padding()
            .background(color, in: Capsule())
            .environment(\.colorScheme, .light)

        Text("Dark")
            .padding()
            .background(color, in: Capsule())
            .environment(\.colorScheme, .dark)
    }
    .padding()
}
#endif
#endif
