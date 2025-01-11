//
//  Text+foregroundLinearGradient.swift
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

extension Text {
    /// Make the foreground gradient
    /// - Parameters:
    ///   - colors: Colors
    ///   - startPoint: Startpoint
    ///   - endPoint: End point
    ///   - if: If condition has met
    /// - Returns: self
    @ViewBuilder
    public func foregroundLinearGradient(
        colors: [Color] = [.red, .blue, .green, .yellow],
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing,
        if condition: Bool = true
    ) -> some View {
        if condition {
            self.overlay {
                LinearGradient(
                    colors: colors,
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .mask(
                    self
                )
            }
        } else {
            self
        }
    }
}
#endif
