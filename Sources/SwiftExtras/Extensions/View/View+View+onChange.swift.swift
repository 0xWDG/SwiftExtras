//
//  View+onChange.swift
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
    /// Adds a debounced onChange handler
    /// - Parameters:
    ///   - value: The value to observe
    ///   - delay: Time in seconds to wait before executing (default 1 second)
    ///   - action: Closure to execute after the delay
    public func onChange<Value: Equatable>(
        of value: Value,
        after delay: Duration = .seconds(1),
        perform action: @escaping (Value) -> Void
    ) -> some View {
        modifier(
            DebouncedOnChangeModifier(
                observedValue: value,
                delay: Double(delay.components.seconds),
                action: action
            )
        )
    }

    /// Adds a debounced onChange handler
    /// - Parameters:
    ///   - value: The value to observe
    ///   - delay: Time in seconds to wait before executing (default 1 second)
    ///   - action: Closure to execute after the delay
    public func onChange<Value: Equatable>(
        of value: Value,
        after delay: TimeInterval = 1.0,
        perform action: @escaping (Value) -> Void
    ) -> some View {
        modifier(
            DebouncedOnChangeModifier(
                observedValue: value,
                delay: delay,
                action: action
            )
        )
    }
}

// MARK: - Modifier
private struct DebouncedOnChangeModifier<Value: Equatable>: ViewModifier {
    let observedValue: Value
    let delay: TimeInterval
    let action: (Value) -> Void

    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        content
            .onChange(of: observedValue) { newValue in
                workItem?.cancel()

                let task = DispatchWorkItem {
                    action(newValue)
                }

                workItem = task

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + delay,
                    execute: task
                )
            }
    }
}
#endif
