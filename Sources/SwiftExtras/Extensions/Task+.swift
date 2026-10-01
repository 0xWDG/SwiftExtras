//
//  Task+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-07-19.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

/// Adds `Task ` functionality to `Task where Failure == Error`.
///
/// The declarations in this scope provide focused utilities while preserving the type’s standard behavior.
extension Task where Failure == Error {
    /// Performs an async task in a synchronous context.
    ///
    /// - Note: This function blocks the thread until the given operation is finished. \
    ///         The caller is responsible for managing multithreading.
    public static func synchronous(
        priority: TaskPriority? = nil,
        operation: @escaping @Sendable () async throws -> Success
    ) {
        let semaphore = DispatchSemaphore(value: 0)

        _ = Task(priority: priority) {
            defer { semaphore.signal() }
            return try await operation()
        }

        semaphore.wait()
    }
}
