//
//  SensoryFeedback.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(UIKit)
import Foundation
import UIKit

/// Generate sensory feedback
public class SensoryFeedback {
    /// Sensory feedback type
    public enum SensoryFeedbackType {
        /// Error feedback
        case error
        /// Success feedback
        case success
        /// Warning feedback
        case warning

        /// Light feedback
        case light
        /// Medium feedback
        case medium
        /// Heavy feedback
        case heavy
    }

    /// Fire sensory feedback
    /// - Parameter type: Feedback type
    @discardableResult
    public init(type: SensoryFeedbackType) {
        switch type {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)

        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)

        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
}
#endif
