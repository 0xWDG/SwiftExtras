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

    public extension Color {
        /// A color that simulates the appearance of the color for a person with protanopia.
        /// Protanopia is a type of red-green color blindness that affects the perception of red light.
        /// - Returns: A color that simulates the appearance of the color for a person with protanopia.
        /// - Note: This is a simulation and may not accurately represent the experience of individuals with protanopia.
        /// - SeeAlso: [Color blindness](https://en.wikipedia.org/wiki/Color_blindness)
        /// - SeeAlso: [Protanopia](https://en.wikipedia.org/wiki/Protanopia)
        var protanopia: Color {
            let newRed = (
                // [0.567, 0.433, 0]
                redValue * 0.567 +
                    greenValue * 0.433 +
                    blueValue * 0
            ) / 255

            let newGreen = (
                // [0.558, 0.442, 0]
                redValue * 0.558 +
                    greenValue * 0.442 +
                    blueValue * 0
            ) / 255

            let newBlue = (
                // [0, 0.242, 0.768]
                redValue * 0 +
                    greenValue * 0.242 +
                    blueValue * 0.758
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
        var deuteranopia: Color {
            let newRed = (
                // [0.625, 0.375, 0]
                redValue * 0.625 +
                    greenValue * 0.375 +
                    blueValue * 0
            ) / 255

            let newGreen = (
                // [0.7, 0.3, 0]
                redValue * 0.7 +
                    greenValue * 0.3 +
                    blueValue * 0
            ) / 255

            let newBlue = (
                // [0, 0.3, 0.7]
                redValue * 0 +
                    greenValue * 0.3 +
                    blueValue * 0.7
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
        var tritanopia: Color {
            let newRed = (
                // [0.95, 0.05, 0]
                redValue * 0.95 +
                    greenValue * 0.05 +
                    blueValue * 0
            ) / 255

            let newGreen = (
                // [0, 0.433, 0.567]
                redValue * 0 +
                    greenValue * 0.433 +
                    blueValue * 0.567
            ) / 255

            let newBlue = (
                // [0, 0.475, 0.525]
                redValue * 0 +
                    greenValue * 0.475 +
                    blueValue * 0.525
            ) / 255

            return Color(
                red: newRed,
                green: newGreen,
                blue: newBlue
            )
        }

        /// Invert the color
        /// - Returns: The inverted color
        var inverted: Color {
            let components = cgColor?.components ?? [0, 0, 0]
            return Color(
                red: 1.0 - components[0],
                green: 1.0 - components[1],
                blue: 1.0 - components[2]
            )
        }
    }
#endif
