//
//  HorizontalStepper.swift
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

    /// Horizontal stepper
    ///
    /// This is a simple horizontal stepper, you can use it to show the progress of a process.
    /// It will show a line with steps, and the current step will be colored.
    public struct HorizontalStepper: View {
        private let step: Int
        private let total: Int
        private let spacing: CGFloat
        private let primaryColor: Color
        private let secondaryColor: Color

        /// Horizontal stepper
        ///
        /// This is a simple horizontal stepper, you can use it to show the progress of a process.
        /// It will show a line with steps, and the current step will be colored.
        ///
        /// - Parameters:
        ///   - step: The current step
        ///   - total: The total amount of steps
        ///   - spacing: The spacing between the steps
        ///   - primaryColor: The color of the current step
        ///   - secondaryColor: The color of the other steps
        public init(
            step: Int,
            total: Int,
            spacing: CGFloat = 8,
            primaryColor: Color = .blue,
            secondaryColor: Color = .gray.opacity(0.3)
        ) {
            self.step = step
            self.total = total
            self.spacing = spacing
            self.primaryColor = primaryColor
            self.secondaryColor = secondaryColor
        }

        /// The color of the step
        ///
        /// - Parameter index: The index of the step
        /// - Returns: The color of the step
        func fillColor(for index: Int) -> Color {
            index <= step ? primaryColor : secondaryColor
        }

        /// The body of the view
        public var body: some View {
            HStack(spacing: spacing) {
                ForEach(
                    1 ..< total + 1,
                    id: \.self,
                    content: stepView
                )
            }
        }

        /// The view for the step
        private func stepView(for index: Int) -> some View {
            RoundedRectangle(cornerRadius: 2)
                .fill(fillColor(for: index))
                .frame(maxWidth: .infinity)
                .frame(height: 6)
        }
    }

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            Group {
                HorizontalStepper(step: 2, total: 10)
            }
            .padding()
        }
    #endif
#endif
