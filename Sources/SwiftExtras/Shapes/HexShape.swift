//
//  HexShape.swift
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

/// Shape representing a single hexagon
///
/// This shape can be used in SwiftUI views to create hexagonal shapes.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct HexShape: Shape {
    /// Shape representing a single hexagon
    ///
    /// This shape can be used in SwiftUI views to create hexagonal shapes.
    public init() { }

    /// Draws the path of a single hexagon
    public func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let rotation = height * 0.25

        // Draw a 6-sided polygon (hexagon)
        return Path { path in
            path.move(to: CGPoint(x: width * 0.5, y: 0))
            path.addLine(to: CGPoint(x: width, y: rotation))
            path.addLine(to: CGPoint(x: width, y: height - rotation))
            path.addLine(to: CGPoint(x: width * 0.5, y: height))
            path.addLine(to: CGPoint(x: 0, y: height - rotation))
            path.addLine(to: CGPoint(x: 0, y: rotation))
            path.closeSubpath()
        }
    }
}
#endif
