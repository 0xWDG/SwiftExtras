//
//
//  View+onNotification.swift
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

extension View {
    /// Adds an action to perform when a notification is received.
    /// - Parameters:
    ///   - name: The name of the notification to observe.
    ///   - action: The action to perform when the notification is received.
    /// - Returns: A view that triggers the action when the notification is received.
    public func onNotification(
        name: Notification.Name,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: name)) { notification in
            action(notification)
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Notification Observer") {
    Label("Listening for preview notifications", systemImage: "bell")
        .onNotification(name: Notification.Name("SwiftExtrasPreviewNotification")) { _ in }
        .padding()
}
#endif
#endif
