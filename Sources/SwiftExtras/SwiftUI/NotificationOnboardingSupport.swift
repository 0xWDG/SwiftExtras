//
//  NotificationOnboardingSupport.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-11-12.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

/// Checks whether the current process can safely access notification permissions.
enum NotificationOnboardingSupport {
    /// Command-line executables do not have the application bundle required by macOS UserNotifications.
    static var canRequestNotifications: Bool {
#if os(macOS)
        Bundle.main.bundleURL.pathExtension == "app"
#else
        true
#endif
    }
}
