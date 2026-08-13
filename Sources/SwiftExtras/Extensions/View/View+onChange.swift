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
                delay: delay,
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
                delay: .seconds(delay),
                action: action
            )
        )
    }

    /// Adds a onChange handler for multiple values
    /// - Parameters:
    ///   - values: The values to observe
    ///   - initial: Whether to call the action on the initial value (default false)
    ///   - action: Closure to execute when any of the values change
    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
    public func onChange<each T>(
        anyOf values: repeat each T,
        initial: Bool = false,
        _ action: @escaping (Equatables<repeat each T>, Equatables<repeat each T>) -> Void
    ) -> some View where repeat each T: Equatable {
        self.onChange(
            of: Equatables<repeat each T>(values: (repeat each values)),
            initial: initial
        ) { oldValue, newValue in
            action(oldValue, newValue)
        }
    }

    /// Adds a onChange handler for multiple values
    /// - Parameters:
    ///   - values: The values to observe
    ///   - initial: Whether to call the action on the initial value (default false)
    ///   - action: Closure to execute when any of the values change
    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
    public func onChange<each T>(
        anyOf values: repeat each T,
        initial: Bool = false,
        _ action: @escaping () -> Void
    ) -> some View where repeat each T: Equatable {
        onChange(
            of: Equatables<repeat each T>(values: (repeat each values)),
            initial: initial,
            action
        )
    }
}

// MARK: - Modifier
private struct DebouncedOnChangeModifier<Value: Equatable>: ViewModifier {
    let observedValue: Value
    let delay: Duration
    let action: (Value) -> Void

    func body(content: Content) -> some View {
        content
            .task(id: observedValue) {
                do {
                    try await Task.sleep(for: delay)
                    action(observedValue)
                } catch {
                    // A new value or disappearing view cancels the pending action.
                }
            }
    }
}

// MARK: - Equatables
// https://mattcomi.com/posts/onchange_anyof/

/// A wrapper for multiple Equatable values to allow for onChange detection of any of them.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
public struct Equatables<each T>: Equatable where repeat each T: Equatable {
    public static func == (lhs: Equatables<repeat each T>, rhs: Equatables<repeat each T>) -> Bool {
        var result = true
        repeat (result = result && (each lhs.values == each rhs.values))
        return result
    }

    public var values: (repeat each T)

    public init(values: (repeat each T)) {
        self.values = values
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
private struct DebouncedOnChangePreview: View {
    @State private var value = 25.0
    @State private var reportedValue = 25.0

    var body: some View {
        VStack {
            HStack {
                Button {
                    value = max(0, value - 25)
                } label: {
                    Image(systemName: "minus")
                }
                .accessibilityLabel("Decrease example value")

                Text(value, format: .number.precision(.fractionLength(0)))
                    .accessibilityLabel("Example value")

                Button {
                    value = min(100, value + 25)
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Increase example value")
            }

            Text("Reported value: \(reportedValue, format: .number.precision(.fractionLength(0)))")
        }
        .padding()
        .onChange(of: value, after: .milliseconds(250)) { reportedValue = $0 }
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Debounced Change") {
    DebouncedOnChangePreview()
}
#endif
#endif
