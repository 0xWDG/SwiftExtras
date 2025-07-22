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

struct EnvironmentWrapperIsEnabled<Content: View>: View {
    @Environment(\.isEnabled) var isEnabled
    let content: (Bool) -> Content

    init(@ViewBuilder content: @escaping (Bool) -> Content) {
        self.content = content
    }

    var body: some View {
        content(isEnabled)
    }
}

extension Text {
    /// Make the foreground gradient
    ///
    /// Create a gradient for the foreground of the text.
    ///
    /// - Parameters:
    ///   - colors: Colors
    ///   - startPoint: Startpoint
    ///   - endPoint: End point
    ///   - always: Does it need to ignore an disabled state
    /// - Returns: self
    @ViewBuilder
    public func foregroundLinearGradient(
        colors: [Color] = [.red, .blue, .green, .yellow],
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing,
        always: Bool = false
    ) -> some View {
        EnvironmentWrapperIsEnabled { isEnabled in
            if isEnabled || always {
                if #available(iOS 17, *) {
                    self.foregroundStyle(
                        LinearGradient(
                            colors: colors,
                            startPoint: startPoint,
                            endPoint: endPoint
                        )
                    )
                } else {
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
                }
            } else {
                self
            }
        }
    }
}
#endif
