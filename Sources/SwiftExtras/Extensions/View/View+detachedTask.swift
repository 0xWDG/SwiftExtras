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

import SwiftUI

extension View {
    /// <#Description#>
    /// - Parameter task: <#task description#>
    /// - Returns: <#description#>
    @available(iOS 15.0, *)
    @ViewBuilder
    public func detachedTask(_ task: @escaping () async -> Void) -> some View {
        self.task {
            Task.detached(priority: .userInitiated) {
                await task()
            }
        }
    }
}
