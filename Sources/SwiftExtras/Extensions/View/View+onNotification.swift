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

    /// Adds an action to perform when a notification is received.
    /// - Parameters:
    ///   - name: The name of the notification to observe.
    ///   - action: The action to perform when the notification is received.
    /// - Returns: A view that triggers the action when the notification is received.
    public func onNotification(
        name: String,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: Notification.Name(name))) { notification in
            action(notification)
        }
    }
}
#endif
