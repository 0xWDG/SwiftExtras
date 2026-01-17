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

/// View for running an async task, and display no content
///
/// Example:
/// ```swift
/// AsyncTask {
///     await myAsynchronusTask()
/// }
/// ```
/// 
public struct AsyncTask: View {
    /// View for running an async task, and display no content
    ///
    /// Example:
    /// ```swift
    /// AsyncTask {
    ///     await myAsynchronusTask()
    /// }
    /// ```
    /// 
    /// - Parameter perform: The async task to run
    public init(perform task: @escaping () async -> Void) {
        Task {
            await task()
        }
    }

    public var body: some View {
        EmptyView()
    }
}
#endif
