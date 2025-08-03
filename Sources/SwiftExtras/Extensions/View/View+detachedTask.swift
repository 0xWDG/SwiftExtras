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

public extension View {
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
    @ViewBuilder
    func detachedTask(_ task: @escaping () async -> Void) -> some View {
        self.task {
            Task.detached(priority: .userInitiated) {
                await task()
            }
        }
    }
}
#endif
