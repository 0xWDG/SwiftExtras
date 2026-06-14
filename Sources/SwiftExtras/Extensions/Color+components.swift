//
//  Color+components.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-04-24.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// Applies the WCAG piecewise gamma expansion to a sRGB channel value.
///
/// Used internally by `Color.luminance` and `Color.Resolved.luminance`.
/// - Parameter value: A linearised sRGB component (0–1 scale).
/// - Returns: The gamma-expanded linear light value.
private func wcagLinearize(_ value: Double) -> Double {
    value <= 0.03928 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
}

extension Color {
    /// Get the red value of a color
    /// - Returns: The normalized red component.
    public var redValue: CGFloat {
        components.red
    }

    /// Get the green value of a color
    /// - Returns: The normalized green component.
    public var greenValue: CGFloat {
        components.green
    }

    /// Get the blue value of a color
    /// - Returns: The normalized blue component.
    public var blueValue: CGFloat {
        components.blue
    }

    /// Get the alpha value of a color
    /// - Returns: The normalized alpha component.
    public var alphaValue: CGFloat {
        components.opacity
    }

    /// Get the hex value of a color
    /// - Returns: The normalized red, green, blue, and opacity components.
    public var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        // swiftlint:disable:previous large_tuple
        var redValue: CGFloat = 0
        var greenValue: CGFloat = 0
        var blueValue: CGFloat = 0
        var alphaValue: CGFloat = 0

        #if canImport(UIKit)
        guard UIColor(self).getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }
        #elseif canImport(AppKit)
        guard let color = NSColor(self).usingColorSpace(.sRGB) else {
            return (0, 0, 0, 0)
        }
        color.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue)
        #endif

        return (
            redValue,
            greenValue,
            blueValue,
            alphaValue
        )
    }

    /// Get HEX string
    /// - Returns: A six-digit hexadecimal RGB string.
    public var hex: String {
        String(
            format: "#%02x%02x%02x",
            Int(components.red * 255),
            Int(components.green * 255),
            Int(components.blue * 255)
        )
    }

    /// Get HEX string
    /// - Returns: An eight-digit hexadecimal RGBA string.
    public var hex8: String {
        String(
            format: "#%02x%02x%02x%02x",
            Int(components.red * 255),
            Int(components.green * 255),
            Int(components.blue * 255),
            Int(components.opacity * 255)
        )
    }

    /// Get RGB string
    /// - Returns: An RGB functional-notation string.
    public func rgbString() -> String {
        let components = self.components
        return "rgb(\(Int(components.red)), \(Int(components.green)), \(Int(components.blue)))"
    }

    /// Get HSB string
    /// - Returns: An HSB functional-notation string.
    public func hsbString() -> String {
        // RGB to HSB
        let components = self.components
        let max = Swift.max(components.red, components.green, components.blue)
        let min = Swift.min(components.red, components.green, components.blue)

        let delta = max - min
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        let brightness = max

        if delta != 0 {
            if max == components.red {
                hue = (components.green - components.blue) / delta
            } else if max == components.green {
                hue = 2 + (components.blue - components.red) / delta
            } else {
                hue = 4 + (components.red - components.green) / delta
            }

            hue *= 60

            if hue < 0 {
                hue += 360
            }

        }

        saturation = max == 0 ? 0 : delta / max

        return "hsb(\(Int(hue)), \(Int(saturation * 100)), \(Int(brightness * 100)))"
    }

    /// Get HSL string
    /// - Returns: An HSL functional-notation string.
    public func hslString() -> String {
        let components = self.components

        // RGB to HSL
        let max = Swift.max(components.red, components.green, components.blue)
        let min = Swift.min(components.red, components.green, components.blue)

        let delta = max - min
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var lightness: CGFloat = 0

        if delta != 0 {
            if max == components.red {
                hue = (components.green - components.blue) / delta
            } else if max == components.green {
                hue = 2 + (components.blue - components.red) / delta
            } else {
                hue = 4 + (components.red - components.green) / delta
            }

            hue *= 60

            if hue < 0 {
                hue += 360
            }

            lightness = (max + min) / 2

            saturation = lightness > 0.5 ? delta / (2 - max - min) : delta / (max + min)
        }

        return "hsl(\(Int(hue)), \(Int(saturation * 100)), \(Int(lightness * 100)))"
    }

    /// Get XYZ string
    /// - Returns: An XYZ functional-notation string.
    public func xyzString() -> String {
        let components = self.components

        // RGB to XYZ
        let rValue = components.red / 255
        let gValue = components.green / 255
        let bValue = components.blue / 255

        let rLinear = rValue > 0.04045 ? pow((rValue + 0.055) / 1.055, 2.4) : rValue / 12.92
        let gLinear = gValue > 0.04045 ? pow((gValue + 0.055) / 1.055, 2.4) : gValue / 12.92
        let bLinear = bValue > 0.04045 ? pow((bValue + 0.055) / 1.055, 2.4) : bValue / 12.92

        let xValue = rLinear * 0.4124564 + gLinear * 0.3575761 + bLinear * 0.1804375
        let yValue = rLinear * 0.2126729 + gLinear * 0.7151522 + bLinear * 0.0721750
        let zValue = rLinear * 0.0193339 + gLinear * 0.1191920 + bLinear * 0.9503041

        let xRounded = Double(round(1000 * xValue) / 1000)
        let yRounded = Double(round(1000 * yValue) / 1000)
        let zRounded = Double(round(1000 * zValue) / 1000)

        return "xyz(\(xRounded), \(yRounded), \(zRounded))"
    }

    /// Get LAB string
    /// - Returns: A LAB functional-notation string.
    public func labString() -> String {
        let components = self.components

        let xValue = components.red / 95.047
        let yValue = components.green / 100
        let zValue = components.blue / 108.883

        let x3Value = xValue > 0.008856 ? pow(xValue, 1 / 3) : (903.3 * xValue + 16) / 116
        let y3Value = yValue > 0.008856 ? pow(yValue, 1 / 3) : (903.3 * yValue + 16) / 116
        let z3Value = zValue > 0.008856 ? pow(zValue, 1 / 3) : (903.3 * zValue + 16) / 116

        let lValue = 116 * y3Value - 16
        let aValue = 500 * (x3Value - y3Value)
        let bValue = 200 * (y3Value - z3Value)

        let lRounded = Double(round(1000 * lValue) / 1000)
        let aRounded = Double(round(1000 * aValue) / 1000)
        let bRounded = Double(round(1000 * bValue) / 1000)

        return "lab(\(lRounded), \(aRounded), \(bRounded))"
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

    /// Luminance per WCAG using rgb components
    public var luminance: Double {
        let redLumiance = wcagLinearize(self.redValue)
        let greenLumiance = wcagLinearize(self.greenValue)
        let blueLumiance = wcagLinearize(self.blueValue)

        // Rec. 709 luminance formula
        return 0.2126 * redLumiance + 0.7152 * greenLumiance + 0.0722 * blueLumiance
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Color.Resolved {
    /// Get the hex value of a color
    /// - Returns: A hexadecimal representation of the resolved color.
    public var hex: String {
        let description = String(describing: self.description)
        return String(description.dropLast(2))
    }

    /// Get the red value of a color
    /// - Returns: The normalized red component.
    public var redValue: CGFloat {
        return CGFloat(red)
    }

    /// Get the green value of a color
    /// - Returns: The normalized green component.
    public var greenValue: CGFloat {
        return CGFloat(green)
    }

    /// Get the blue value of a color
    /// - Returns: The normalized blue component.
    public var blueValue: CGFloat {
        return CGFloat(blue)
    }

    /// Get the alpha value of a color
    /// - Returns: The normalized alpha component.
    public var alphaValue: CGFloat {
        CGFloat(opacity)
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

    /// Luminance per WCAG using sRGB components (0-1).
    public var luminance: Double {
        let redLumiance = wcagLinearize(Double(self.red))
        let greenLumiance = wcagLinearize(Double(self.green))
        let blueLumiance = wcagLinearize(Double(self.blue))

        // Rec. 709 luminance formula
        return 0.2126 * redLumiance + 0.7152 * greenLumiance + 0.0722 * blueLumiance
    }
}
#endif
