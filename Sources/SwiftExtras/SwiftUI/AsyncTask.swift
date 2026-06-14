//
//  AsyncTask.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-01-07.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A view that runs an asynchronous task without displaying content.
///
/// Example:
/// ```swift
/// AsyncTask {
///     await myAsynchronousTask()
/// }
/// ```
/// 
public struct AsyncTask: View {
    private let task: () async -> Void

    /// Creates a view that runs an asynchronous task without displaying content.
    ///
    /// Example:
    /// ```swift
    /// AsyncTask {
    ///     await myAsynchronousTask()
    /// }
    /// ```
    /// 
    /// - Parameter task: The asynchronous task to run.
    public init(perform task: @escaping () async -> Void) {
        self.task = task
    }

    /// An empty view that starts the task when it appears.
    public var body: some View {
        EmptyView()
            .task {
                await task()
            }
    }
}
#endif
