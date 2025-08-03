//
//
//  View+colorScheme.swift
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

    public extension View {
        /// Sets the color scheme of the view.
        ///
        ///  ```swift
        ///  SomeSwiftUIView()
        ///     .colorScheme(.dark)
        ///  ```
        ///
        /// - Parameter closure: Code need to run
        /// - Returns: self
        func colorScheme(colorSheme: ColorScheme) -> some View {
            environment(\.colorScheme, colorSheme)
        }
    }

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            VStack {
                Spacer()

                Text("Light mode")
                    .colorScheme(.light)

                Spacer()

                Text("Light mode")
                    .colorScheme(.dark)

                Spacer()
            }
            .frame(maxSize: .infinity)
            .background(.gray)
        }
    #endif
#endif
