//
//  AsyncView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// AsyncView
///
/// AsyncView accepts a async task and renders the result
/// of the task in the body.
///
/// Example:
/// ```swift
/// AsyncView {
///     return await myAsynchronusTask()
/// } content: { response in
///     Text("Response: \(response)")
/// }
/// ```
public struct AsyncView<Content: View, Result>: View {
    /// Task to execute
    let task: () async -> Result

    /// View to show if task is finished
    let content: (Result) -> Content

    /// Show progress
    let showProgress: Bool

    /// Result of the task
    @State private var result: Result?

    /// AsyncView
    ///
    /// AsyncView accepts a async task and renders the result
    /// of the task in the body.
    ///
    /// Example:
    /// ```swift
    /// AsyncView {
    ///     return await myAsynchronusTask()
    /// } content: { response in
    ///     Text("Response: \(response)")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - showProgress: Should show progress indicator
    ///   - task: Task to execute
    ///   - content: View to show if task is finished
    public init(
        showProgress: Bool = true,
        task: @escaping () async -> Result,
        @ViewBuilder content: @escaping (Result) -> Content
    ) {
        self.task = task
        self.content = content
        self.showProgress = showProgress
    }

    /// Body of AsyncView
    public var body: some View {
        if let result = result {
            content(result)
        } else {
            if showProgress {
                HStack {
                    ProgressView()
                    Text("Loading", bundle: .module)
                }
            } else {
                EmptyView()
            }

            AsyncTask {
                result = await task()
            }
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Form {
        Section("No Progress") {
            AsyncView(showProgress: false) {
                try? await Task.sleep(for: .seconds(5))
                return "Loaded"
            } content: { result in
                Text("Hello World!")
                Text(result)
            }
        }

        Section("With Progress") {
            AsyncView {
                try? await Task.sleep(for: .seconds(5))
                return "Loaded"
            } content: { result in
                Text("Hello World!")
                Text(result)
            }
        }
    }
}
#endif
#endif
