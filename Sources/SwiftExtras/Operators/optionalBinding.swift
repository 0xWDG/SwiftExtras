//
//  OptionalBinding.swift
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

/// Optional binding
///
/// This operator allows you to use the nil-coalescing operator `??` with `Binding`.
/// This is useful when you want to provide a default value for a `Binding` that wraps an optional value.
///
/// - Parameters:
///   - lhs: A binding whose wrapped value is optional.
///   - rhs: The fallback value to use while the wrapped value is `nil`.
/// - Returns: A nonoptional binding that writes changes back to `lhs`.
public func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
#endif
