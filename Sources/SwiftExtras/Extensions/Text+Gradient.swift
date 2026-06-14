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
    /// Applies a linear gradient to the text foreground.
    ///
    /// - Parameters:
    ///   - colors: The colors in the gradient.
    ///   - startPoint: The gradient's starting point.
    ///   - endPoint: The gradient's ending point.
    ///   - always: Whether to apply the gradient while the text is disabled.
    /// - Returns: Text with a linear-gradient foreground when enabled or requested.
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
