//
//  IslandToastCard.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// The content and behavior displayed by an island toast.
public struct IslandToastCard {
    /// The semantic role used to style the toast.
    public enum Role: Sendable {
        /// Informational content.
        case info

        /// Confirmation that an operation succeeded.
        case success

        /// A warning that may require attention.
        case warning

        /// An error that may require attention.
        case error

        fileprivate var color: Color {
            switch self {
            case .info: .blue
            case .success: .green
            case .warning: .orange
            case .error: .red
            }
        }

        fileprivate var systemImage: String {
            switch self {
            case .info: "info.circle.fill"
            case .success: "checkmark.circle.fill"
            case .warning: "exclamationmark.triangle.fill"
            case .error: "xmark.octagon.fill"
            }
        }
    }

    /// The toast's primary text.
    public let title: String

    /// Optional supporting text.
    public let subtitle: String?

    /// The semantic style of the toast.
    public let role: Role

    /// The time before automatic dismissal, or `nil` to keep the toast visible.
    public let duration: Duration?

    /// An optional action performed when the toast is selected.
    public let action: (() -> Void)?

    /// Creates an island toast card.
    ///
    /// - Parameters:
    ///   - title: The toast's primary text.
    ///   - subtitle: Optional supporting text.
    ///   - role: The semantic style of the toast.
    ///   - duration: The time before automatic dismissal, or `nil` for no timeout.
    ///   - action: An optional action performed when the toast is selected.
    public init(
        title: String,
        subtitle: String? = nil,
        role: Role = .info,
        duration: Duration? = .seconds(3),
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.role = role
        self.duration = duration
        self.action = action
    }

    var compact: some View {
        Image(systemName: role.systemImage)
            .font(.headline)
            .foregroundStyle(role.color)
            .frame(minWidth: 44, minHeight: 44)
            .accessibilityHidden(true)
    }

    var expanded: some View {
        HStack {
            Image(systemName: role.systemImage)
                .font(.title2)
                .foregroundStyle(role.color)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: 420)
    }
}

#if DEBUG
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Toast Roles") {
    VStack(spacing: 12) {
        IslandToastCard(
            title: "Information",
            subtitle: "A useful update",
            role: .info)
        .expanded

        IslandToastCard(
            title: "Success",
            subtitle: "The operation completed",
            role: .success
        ).expanded

        IslandToastCard(
            title: "Warning",
            subtitle: "Review this item",
            role: .warning
        ).expanded

        IslandToastCard(
            title: "Error",
            subtitle: "The operation failed",
            role: .error
        ).expanded
    }
    .padding()
}
#endif
#endif
