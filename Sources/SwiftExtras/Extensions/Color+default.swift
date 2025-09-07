//
//  Color+default.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && (canImport(AppKit) || canImport(UIKit))
import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension Color {
    /// The color for text labels that contain primary content.
    public static var label: Color {
#if os(macOS)
        return Color(NSColor.labelColor)
#else
#if os(watchOS)
        return Color(UIColor.white)
#else
        return Color(UIColor.label)
#endif
#endif
    }

    /// The color for text labels that contain secondary content.
    public static var secondaryLabel: Color {
#if os(macOS)
        return Color(NSColor.secondaryLabelColor)
#else
#if os(watchOS)
        return Color(UIColor.gray)
#else
        return Color(UIColor.secondaryLabel)
#endif
#endif
    }

    /// The color for text labels that contain tertiary content.
    public static var tertiaryLabel: Color {
#if os(macOS)
        return Color(NSColor.tertiaryLabelColor)
#else
#if os(watchOS)
        return Color(UIColor.gray)
#else
        return Color(UIColor.tertiaryLabel)
#endif
#endif
    }

    /// The color for text labels that contain quaternary content.
    public static var quaternaryLabel: Color {
#if os(macOS)
        return Color(NSColor.quaternaryLabelColor)
#else
#if os(watchOS)
        return Color(UIColor.gray)
#else
        return Color(UIColor.quaternaryLabel)
#endif
#endif
    }

    // MARK: Fill Colors
    /// An overlay fill color for thin and small shapes.
    public static var systemFill: Color {
#if os(macOS)
        return Color(NSColor.windowFrameTextColor)
#else
#if os(iOS)
        return Color(UIColor.systemFill)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    /// An overlay fill color for medium-size shapes.
    public static var secondarySystemFill: Color {
#if os(macOS)
        return Color(NSColor.windowFrameTextColor)
#else
#if os(iOS)
        return Color(UIColor.secondarySystemFill)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    /// An overlay fill color for large shapes.
    public static var tertiarySystemFill: Color {
#if os(macOS)
        return Color(NSColor.windowFrameTextColor)
#else
#if os(iOS)
        return Color(UIColor.tertiarySystemFill)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    /// An overlay fill color for large areas that contain complex content.
    public static var quaternarySystemFill: Color {
#if os(macOS)
        return Color(NSColor.windowFrameTextColor)
#else
#if os(iOS)
        return Color(UIColor.quaternarySystemFill)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    // MARK: Text Colors
    /// The color for placeholder text in controls or text views.
    public static var placeholderText: Color {
#if os(macOS)
        return Color(NSColor.placeholderTextColor)
#else
#if os(watchOS)
        return Color(UIColor.gray)
#else
        return Color(UIColor.placeholderText)
#endif
#endif
    }

    // MARK: Standard Content Background Colors
    /// The color for the main background of your interface.
    public static var systemBackground: Color {
#if os(macOS)
        return Color(NSColor.windowBackgroundColor)
#else
#if os(iOS)
        return Color(UIColor.systemBackground)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    /// The color for content layered on top of the main background.
    public static var secondarySystemBackground: Color {
#if os(macOS)
        return Color(NSColor.windowBackgroundColor)
#else
#if os(iOS)
        return Color(UIColor.secondarySystemBackground)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    /// The color for content layered on top of secondary backgrounds.
    public static var tertiarySystemBackground: Color {
#if os(macOS)
        return Color(NSColor.windowBackgroundColor)
#else
#if os(iOS)
        return Color(UIColor.tertiarySystemBackground)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    /// The color for the main background of your grouped interface.
    public static var systemGroupedBackground: Color {
#if os(macOS)
        return Color(NSColor.windowBackgroundColor)
#else
#if os(iOS)
        return Color(UIColor.systemGroupedBackground)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    /// The color for content layered on top of the main background of your grouped interface.
    public static var secondarySystemGroupedBackground: Color {
#if os(macOS)
        return Color(NSColor.windowBackgroundColor)
#else
#if os(iOS)
        return Color(UIColor.secondarySystemGroupedBackground)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    /// The color for content layered on top of secondary backgrounds of your grouped interface.
    public static var tertiarySystemGroupedBackground: Color {
#if os(macOS)
        return Color(NSColor.windowBackgroundColor)
#else
#if os(iOS)
        return Color(UIColor.tertiarySystemGroupedBackground)
#else
        return Color(UIColor.black)
#endif
#endif
    }

    /// The color for thin borders or divider lines that allows some underlying content to be visible.
    public static var separator: Color {
#if os(macOS)
        return Color(NSColor.separatorColor)
#else
#if os(watchOS)
        return Color(UIColor.white)
#else
        return Color(UIColor.separator)
#endif
#endif
    }

    /// The color for borders or divider lines that hides any underlying content.
    public static var opaqueSeparator: Color {
#if os(macOS)
        return Color(NSColor.separatorColor).opacity(1)
#else
#if os(watchOS)
        return Color(UIColor.clear)
#else
        return Color(UIColor.opaqueSeparator)
#endif
#endif
    }

    /// The color for links.
    public static var link: Color {
#if os(macOS)
        return Color(NSColor.linkColor)
#else
#if os(watchOS)
        return Color(UIColor.blue)
#else
        return Color(UIColor.link)
#endif
#endif
    }

    /// A blue color that automatically adapts to the current trait environment.
    public static var systemBlue: Color {
#if os(macOS)
        return Color(NSColor.systemBlue)
#else
#if os(watchOS)
        return Color(UIColor.blue)
#else
        return Color(UIColor.systemBlue)
#endif
#endif
    }

    /// A green color that automatically adapts to the current trait environment.
    public static var systemGreen: Color {
#if os(macOS)
        return Color(NSColor.systemGreen)
#else
#if os(watchOS)
        return Color(UIColor.green)
#else
        return Color(UIColor.systemGreen)
#endif
#endif
    }

    /// An indigo color that automatically adapts to the current trait environment.
    public static var systemIndigo: Color {
#if os(macOS)
        return Color(NSColor.systemIndigo)
#else
#if os(watchOS)
        return Color(UIColor.blue)
#else
        return Color(UIColor.systemIndigo)
#endif
#endif
    }

    /// An orange color that automatically adapts to the current trait environment.
    public static var systemOrange: Color {
#if os(macOS)
        return Color(NSColor.systemOrange)
#else
#if os(watchOS)
        return Color(UIColor.orange)
#else
        return Color(UIColor.systemOrange)
#endif
#endif
    }

    /// A pink color that automatically adapts to the current trait environment.
    public static var systemPink: Color {
#if os(macOS)
        return Color(NSColor.systemPink)
#else
#if os(watchOS)
        return Color(UIColor.blue)
#else
        return Color(UIColor.systemPink)
#endif
#endif
    }

    /// A purple color that automatically adapts to the current trait environment.
    public static var systemPurple: Color {
#if os(macOS)
        return Color(NSColor.systemPurple)
#else
#if os(watchOS)
        return Color(UIColor.purple)
#else
        return Color(UIColor.systemPurple)
#endif
#endif
    }

    /// A red color that automatically adapts to the current trait environment.
    public static var systemRed: Color {
#if os(macOS)
        return Color(NSColor.systemRed)
#else
#if os(watchOS)
        return Color(UIColor.red)
#else
        return Color(UIColor.systemRed)
#endif
#endif
    }

    /// A teal color that automatically adapts to the current trait environment.
    public static var systemTeal: Color {
#if os(macOS)
        return Color(NSColor.systemTeal)
#else
#if os(watchOS)
        return Color(UIColor.green)
#else
        return Color(UIColor.systemTeal)
#endif
#endif
    }

    /// A yellow color that automatically adapts to the current trait environment.
    public static var systemYellow: Color {
#if os(macOS)
        return Color(NSColor.systemYellow)
#else
#if os(iOS)
        return Color(UIColor.systemYellow)
#else
        return Color(UIColor.yellow)
#endif
#endif
    }

    /// The standard base gray color that adapts to the environment.
    public static var systemGray: Color {
#if os(macOS)
        return Color(NSColor.systemGray)
#else
#if os(iOS)
        return Color(UIColor.systemGray)
#else
        return Color(UIColor.gray)
#endif
#endif
    }

    /// A second-level shade of gray that adapts to the environment.
    public static var systemGray2: Color {
#if os(macOS)
        return Color(NSColor.systemGray)
#else
#if os(iOS)
        return Color(UIColor.systemGray2)
#else
        return Color(UIColor.gray)
#endif
#endif
    }

    /// A third-level shade of gray that adapts to the environment.
    public static var systemGray3: Color {
#if os(macOS)
        return Color(NSColor.systemGray)
#else
#if os(iOS)
        return Color(UIColor.systemGray3)
#else
        return Color(UIColor.gray)
#endif
#endif
    }

    /// A fourth-level shade of gray that adapts to the environment.
    public static var systemGray4: Color {
#if os(macOS)
        return Color(NSColor.systemGray)
#else
#if os(iOS)
        return Color(UIColor.systemGray4)
#else
        return Color(UIColor.gray)
#endif
#endif
    }

    /// A fifth-level shade of gray that adapts to the environment.
    public static var systemGray5: Color {
#if os(macOS)
        return Color(NSColor.systemGray)
#else
#if os(iOS)
        return Color(UIColor.systemGray5)
#else
        return Color(UIColor.gray)
#endif
#endif
    }

    /// A sixth-level shade of gray that adapts to the environment.
    public static var systemGray6: Color {
#if os(macOS)
        return Color(NSColor.systemGray)
#else
#if os(iOS)
        return Color(UIColor.systemGray6)
#else
        return Color(UIColor.gray)
#endif
#endif
    }
}
#endif
// swiftlint:disable:this file_length
