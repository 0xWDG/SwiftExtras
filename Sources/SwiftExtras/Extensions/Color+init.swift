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

public extension Color {
    /// Creates a Color from a PlatformColor
    /// - Parameter color: The PlatformColor to create the Color from.
    /// - Returns: A Color that represents the given PlatformColor.
    init(_ color: PlatformColor) {
        #if canImport(UIKit)
        self.init(uiColor: color)
        #elseif canImport(AppKit)
        self.init(nsColor: color)
        #else
        self.init(color.description)
        #endif
    }

    /// Creates a Color that adapts to the current user interface style.
    /// - Parameters:
    ///   - light: The color to use in light mode.
    ///   - dark: The color to use in dark mode.
    /// - Returns: A Color that adapts to the current user interface style.
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        #if os(watchOS)
        // watchOS does not support light mode / dark mode
        self.init(uiColor: UIColor(dark))
        #else
        self.init(uiColor: UIColor(dynamicProvider: { traits in
            switch traits.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(light)

            case .dark:
                return UIColor(dark)

            @unknown default:
                return UIColor(light)
            }
        }))
        #endif
        #else
        self.init(nsColor: NSColor(name: nil, dynamicProvider: { appearance in
            switch appearance.name {
            case .aqua,
                 .vibrantLight,
                 .accessibilityHighContrastAqua,
                 .accessibilityHighContrastVibrantLight:
                NSColor(light)

            case .darkAqua,
                 .vibrantDark,
                 .accessibilityHighContrastDarkAqua,
                 .accessibilityHighContrastVibrantDark:
                NSColor(dark)

            default:
                NSColor(light)
            }
        }))
        #endif
    }
}
#endif
