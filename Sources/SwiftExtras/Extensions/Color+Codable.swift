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

/// This extension makes Color conform to Codable.
/// It encodes the color as a string in the format "red;green;blue;alpha".
/// It decodes the color from a string in the same format.
extension Color: @retroactive Codable {
    /// Initializes a Color from a decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let colorString = try container.decode(String.self)
        let components = colorString.split(separator: ";").map { CGFloat(Double($0) ?? 0) }

        self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }

    /// Encodes the Color to an encoder.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let color = "\(redValue);\(greenValue);\(blueValue);\(alphaValue)"
        try container.encode(color)
    }
}

/// This extension makes Color conform to RawRepresentable.
/// It encodes the color as a base64 string of its archived PlatformColor representation.
/// It decodes the color from a base64 string of its archived PlatformColor representation.
extension Color: @retroactive RawRepresentable {
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
