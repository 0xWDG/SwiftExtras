//
//  Color+colorBlind.swift
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

extension Color {
    /// A color that simulates the appearance of the color for a person with protanopia.
    /// Protanopia is a type of red-green color blindness that affects the perception of red light.
    /// - Returns: A color that simulates the appearance of the color for a person with protanopia.
    /// - Note: This is a simulation and may not accurately represent the experience of individuals with protanopia.
    /// - SeeAlso: [Color blindness](https://en.wikipedia.org/wiki/Color_blindness)
    /// - SeeAlso: [Protanopia](https://en.wikipedia.org/wiki/Protanopia)
    public var protanopia: Color {
        let newRed = (
            // [0.567, 0.433, 0]
            self.redValue * 0.567 +
            self.greenValue * 0.433 +
            self.blueValue * 0
        ) / 255

        let newGreen = (
            // [0.558, 0.442, 0]
            self.redValue * 0.558 +
            self.greenValue * 0.442 +
            self.blueValue * 0
        ) / 255

        let newBlue = (
            // [0, 0.242, 0.768]
            self.redValue * 0 +
            self.greenValue * 0.242 +
            self.blueValue * 0.758
        ) / 255

        return Color(
            red: newRed,
            green: newGreen,
            blue: newBlue
        )
    }

    /// A color that simulates the appearance of the color for a person with deuteranopia.
    /// Deuteranopia is a type of red-green color blindness that affects the perception of green light.
    /// - Returns: A color that simulates the appearance of the color for a person with deuteranopia.
    /// - Note: This is a simulation and may not accurately represent the experience of individuals with deuteranopia.
    /// - SeeAlso: [Color blindness](https://en.wikipedia.org/wiki/Color_blindness)
    /// - SeeAlso: [Deuteranopia](https://en.wikipedia.org/wiki/Deuteranopia)
    public var deuteranopia: Color {
        let newRed = (
            // [0.625, 0.375, 0]
            self.redValue * 0.625 +
            self.greenValue * 0.375 +
            self.blueValue * 0
        ) / 255

        let newGreen = (
            // [0.7, 0.3, 0]
            self.redValue * 0.7 +
            self.greenValue * 0.3 +
            self.blueValue * 0
        ) / 255

        let newBlue = (
            // [0, 0.3, 0.7]
            self.redValue * 0 +
            self.greenValue * 0.3 +
            self.blueValue * 0.7
        ) / 255

        return Color(
            red: newRed,
            green: newGreen,
            blue: newBlue
        )
    }

    /// A color that simulates the appearance of the color for a person with tritanopia.
    /// Tritanopia is a type of blue-yellow color blindness that affects the perception of blue light.
    /// - Returns: A color that simulates the appearance of the color for a person with tritanopia.
    /// - Note: This is a simulation and may not accurately represent the experience of individuals with tritanopia.
    /// - SeeAlso: [Color blindness](https://en.wikipedia.org/wiki/Color_blindness)
    /// - SeeAlso: [Tritanopia](https://en.wikipedia.org/wiki/Tritanopia)
    public var tritanopia: Color {
        let newRed = (
            // [0.95, 0.05, 0]
            self.redValue * 0.95 +
            self.greenValue * 0.05 +
            self.blueValue * 0
        ) / 255

        let newGreen = (
            // [0, 0.433, 0.567]
            self.redValue * 0 +
            self.greenValue * 0.433 +
            self.blueValue * 0.567
        ) / 255

        let newBlue = (
            // [0, 0.475, 0.525]
            self.redValue * 0 +
            self.greenValue * 0.475 +
            self.blueValue * 0.525
        ) / 255

        return Color(
            red: newRed,
            green: newGreen,
            blue: newBlue
        )
    }

    /// Invert the color
    /// - Returns: The inverted color
    public var inverted: Color {
        let components = self.cgColor?.components ?? [0, 0, 0]
        return Color(
            red: (1.0 - components[0]),
            green: (1.0 - components[1]),
            blue: (1.0 - components[2])
        )
    }
}
#endif
