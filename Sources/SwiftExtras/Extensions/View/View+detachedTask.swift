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
    /// - Parameter task: Task to run
    /// - Returns: self
    @ViewBuilder
    public func detachedTask(_ task: @escaping () async -> Void) -> some View {
        self.task {
            Task.detached(priority: .userInitiated) {
                await task()
            }
        }
    }
}
#endif
