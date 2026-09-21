//
//  Color+Codable.swift
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

/// Adds a semicolon-delimited `Codable` representation to `Color`.
///
/// New values use normalized red, green, blue, and alpha components. Decoding
/// also accepts legacy component values in the `0...255` range.
extension Color: @retroactive Codable {
    /// Initializes a Color from a decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let colorString = try container.decode(String.self)
        let rawComponents = colorString.split(separator: ";", omittingEmptySubsequences: false)

        let components = rawComponents.compactMap { Double($0) }
        guard rawComponents.count == 4,
              components.count == 4,
              components.allSatisfy({ $0.isFinite && (0...255).contains($0) }) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Expected four finite color components separated by semicolons."
            )
        }

        // Values produced before normalized component encoding were in the 0...255 range.
        let divisor = components.contains(where: { $0 > 1 }) ? 255.0 : 1.0
        self.init(
            red: components[0] / divisor,
            green: components[1] / divisor,
            blue: components[2] / divisor,
            alpha: components[3] / divisor
        )
    }

    /// Encodes the Color to an encoder.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let color = "\(redValue);\(greenValue);\(blueValue);\(alphaValue)"
        try container.encode(color)
    }
}

/// Adds a Base64-encoded archived platform-color representation to `Color`.
extension Color: @retroactive RawRepresentable {
    /// Creates a color from a Base64-encoded archived platform color.
    ///
    /// Invalid or unsupported values produce `.black`.
    /// - Parameter rawValue: The Base64-encoded archived platform color.
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .black
            return
        }

        do {
            if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: PlatformColor.self, from: data) {
                self = Color(color)
            } else {
                self = .black
            }
        } catch {
            self = .black
        }
    }

    /// A Base64-encoded archive of the platform color, or an empty string if archiving fails.
    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: PlatformColor(self),
                requiringSecureCoding: false
            ) as Data
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}
#endif
