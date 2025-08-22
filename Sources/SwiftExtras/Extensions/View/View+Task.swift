//
//  View+detachedTask.swift
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
    /// Run a task detached from the current task
    ///
    /// Use this modifier to run a task detached from the current task.
    ///
    /// Usage:
    /// ```swift
    /// .detachedTask {
    ///     print("Hello World!")
    /// }
    /// ```
    ///
    /// - Parameter task: Task to run
    /// - Returns: self
    public func detachedTask(_ task: @escaping () async -> Void) -> some View {
        self.task {
            Task.detached(priority: .userInitiated) {
                await task()
            }
        }
    }

    /// Executes the given action after the specified delay unless
    /// the task is cancelled.
    ///
    /// - Parameters:
    ///   - delay: The duration to wait before executing the task.
    ///   - action: The asynchronous action to execute.
    public func task(
        delay: ContinuousClock.Duration,
        action: @Sendable @escaping () async -> Void
    ) -> some View {
        self.task {
            do {
                try await Task.sleep(for: delay)
                await action()
            } catch {
                // do nothing
            }
        }
    }
}
#endif
