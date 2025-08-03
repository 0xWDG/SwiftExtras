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
        ///   - task: Task to execute
        ///   - content: View to show if task is finished
        public init(
            task: @escaping () async -> Result,
            @ViewBuilder content: @escaping (Result) -> Content
        ) {
            self.task = task
            self.content = content
        }

        /// Body of AsyncView
        public var body: some View {
            if let result {
                content(result)
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            result = await task()
                        }
                    }

                Text("Loading", bundle: .module)
            }
        }
    }

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            AsyncView {
                try? await Task.sleep(for: .seconds(5))
                return "Loaded"
            } content: { result in
                Text("Hello World!")
                Text(result)
            }
        }
    #endif
#endif
