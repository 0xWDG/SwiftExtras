//
//  PlatformColor+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-07-19.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

extension PlatformColor {
    /// Get the hex value of a color
    /// - Returns a string representation of the color in hex format.
    public var hex: String {
        let description = String(describing: self.description)
        return String(description.dropLast(2))
    }

    /// RGB Hex value of a color
    /// - Returns a string representation of the color in hex format.
    public var rgbHex: String {
        return String(
            format: "#%02x%02x%02x",
            Int(self.redValue * 255),
            Int(self.greenValue * 255),
            Int(self.blueValue * 255)
        )
    }

    /// Get the red value of a color
    /// - Returns the red value of the color as a CGFloat.
    public var redValue: CGFloat {
#if os(macOS)
        return self.redComponent
#else
        var red: CGFloat = .zero
        return getRed(&red, green: nil, blue: nil, alpha: nil) ? red : 0
#endif
    }

    /// Get the green value of a color
    /// - Returns the green value of the color as a CGFloat.
    public var greenValue: CGFloat {
#if os(macOS)
        return self.greenComponent
#else
        var green: CGFloat = .zero
        return getRed(nil, green: &green, blue: nil, alpha: nil) ? green : 0
#endif
    }

    /// Get the blue value of a color
    /// - Returns the blue value of the color as a CGFloat.
    public var blueValue: CGFloat {
#if os(macOS)
        return self.blueComponent
#else
        var blue: CGFloat = .zero
        return getRed(nil, green: nil, blue: &blue, alpha: nil) ? blue : 0
#endif
    }

    /// Get the alpha value of a color
    /// - Returns the alpha value of the color as a CGFloat.
    public var alphaValue: CGFloat {
#if os(macOS)
        return self.alphaComponent
#else
        var alpha: CGFloat = .zero
        return getRed(nil, green: nil, blue: nil, alpha: &alpha) ? alpha : 0
#endif
    }

    /// Get the (6) hex color from the current
    public var hex6: String {
        return String(
            format: "#%02x%02x%02x",
            Int(self.redValue * 255),
            Int(self.greenValue * 255),
            Int(self.blueValue * 255)
        )
    }
}
#endif
