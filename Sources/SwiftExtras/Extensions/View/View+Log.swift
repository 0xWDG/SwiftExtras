//
//  View+Log.swift
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
    /// Log
    /// This enables:
    ///
    ///  ```swift
    ///  SomeSwiftUIView()
    ///     .log {
    ///         // Code you need to run
    ///     }
    ///  ```
    ///
    /// - Parameter closure: Code need to run
    /// - Returns: self
    public func log(_ closure: () -> Void) -> some View {
        closure()
        return self
    }

    /// Debug print
    ///
    /// This enables:
    ///  ```swift
    ///  SomeSwiftUIView()
    ///     .debugPrint("Some debug info")
    ///  ```
    ///  - Parameter item: Item to print
    /// - Returns: self
    public func debugPrint(_ item: Any) -> some View {
        print(item)
        return self
    }

    /// Debug print with closure
    ///
    /// This enables:
    ///  ```swift
    ///  SomeSwiftUIView()
    ///     .printValues { "My debug info: \(someVariable)" }
    ///  ```
    ///  - Parameter closure: Code need to run, the result will be printed
    /// - Returns: self
    public func printValues(_ closure: () -> Any) -> some View {
        print(closure())
        return self
    }
}
#endif
