//
//  ConfettiView.swift
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

    // A view that displays confetti animation when activated.
    // The confetti is displayed in a container view that manages the animation and positioning of the confetti shapes.
    // The confetti shapes can be customized, and the colors can be set to a variety of vibrant colors.
    // The confetti animation can be triggered by setting a binding variable to true, \
    // and it will automatically fade out after a specified duration.
    // The confetti shapes can be any SwiftUI view, allowing for flexibility in design.
    // The view also supports sensory feedback on iOS 17 and later, \
    // providing a tactile response when the confetti is displayed.
    struct ConfettiView<ConfettiShape: View>: View {
        /// The number of confetti pieces to display.
        var count: Int = 50

        /// An array of colors for the confetti pieces.
        var colors: [Color]

        /// The shape of the confetti pieces, which can be any SwiftUI view.
        var shape: ConfettiShape

        /// The y-position of the confetti pieces.
        @State var yPosition: CGFloat = 0

        /// The size of the view, used to determine the bounds for positioning confetti pieces.
        /// This is initialized to a large size to ensure confetti can be positioned anywhere within the view.
        /// It is updated dynamically based on the view's actual size.
        @State var viewSize: CGSize = .init(width: 1000, height: 1000)

        /// Initializes a new `ConfettiView` with the specified colors and shape.
        /// - Parameters:
        ///   - colors: An array of colors for the confetti pieces. Defaults to a set of vibrant colors.
        ///   - shape: The shape of the confetti pieces, which can be any SwiftUI view. Defaults to a rectangle.
        /// - Note: The `count` of confetti pieces is set to 50 by default, \
        ///         but can be adjusted by modifying the `count` property directly.
        /// - Example:
        /// ```swift
        /// ConfettiView(colors: [Color.red, Color.blue], shape: Circle())
        /// ```
        init(
            colors: [Color] = [Color.orange, Color.green, Color.blue, Color.red, Color.yellow],
            shape: ConfettiShape = Rectangle()
        ) {
            self.colors = colors
            self.shape = shape
        }

        /// The body of the view that contains the confetti animation.
        /// It uses a `ZStack` to layer the confetti pieces on top of each other,
        /// and positions them randomly within the view's bounds.
        var body: some View {
            ZStack {
                Color
                    .clear
                    .saveSize(in: $viewSize)

                ForEach(0 ..< count, id: \.self) { _ in
                    Confetti(colors: colors, shape: shape)
                        .position(
                            x: CGFloat.random(in: 0 ... viewSize.width),
                            y: yPosition != 0 ? CGFloat.random(in: 0 ... viewSize.height) : yPosition
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear {
                yPosition = CGFloat.random(in: 0 ... viewSize.width)
            }
        }

        /// A view that represents a single confetti piece.
        /// It animates with a 3D rotation effect and falls down the screen.
        /// The confetti piece can be customized with different colors and shapes.
        /// - Parameters:
        ///   - colors: An array of colors for the confetti piece.
        ///   - shape: The shape of the confetti piece, which can be any SwiftUI view.
        /// - Returns: A view that represents the confetti piece with animation.
        struct Confetti: View {
            /// The state that controls the animation of the confetti piece.
            /// It starts as false and becomes true when the view appears, triggering the animation.
            @State private var animate = false

            /// The speed of the confetti piece's rotation around the x-axis.
            /// This is a random value between 0.7 and 2 seconds, which determines
            @State private var xSpeed = Double.random(in: 0.7 ... 2)

            /// The speed of the confetti piece's rotation around the z-axis.
            /// This is a random value between 1 and 2 seconds, which determines how fast
            /// the confetti rotates around the z-axis.
            @State private var zSpeed = Double.random(in: 1 ... 2)

            /// The anchor point for the z-axis rotation, which is a random value between 0 and 1.
            /// This value is rounded to ensure it is a valid anchor point.
            /// It determines the point around which the confetti rotates in 3D space.
            @State private var anchor = CGFloat.random(in: 0 ... 1).rounded()

            /// The colors of the confetti piece, which are randomly selected from the provided array.
            /// If the array is empty, it defaults to a blue color.
            var colors: [Color]

            /// The shape of the confetti piece, which can be any SwiftUI view.
            /// This allows for flexibility in the design of the confetti piece.
            /// Defaults to a rectangle shape.
            var shape: ConfettiShape

            /// Initializes a new `Confetti` view with the specified colors and shape.
            /// - Parameters:
            ///   - colors: An array of colors for the confetti piece.
            ///   - shape: The shape of the confetti piece, which can be any SwiftUI view.
            init(colors: [Color], shape: ConfettiShape) {
                self.colors = colors
                self.shape = shape
            }

            /// The body of the view that represents a single confetti piece.
            var body: some View {
                shape
                    .foregroundStyle(colors.randomElement() ?? Color.blue)
                    .frame(width: 20, height: 20)
                    .onAppear(perform: { animate = true })
                    .rotation3DEffect(
                        .degrees(animate ? 360 : 0),
                        axis: (x: 1, y: 0, z: 0)
                    )
                    .animation(
                        Animation
                            .linear(duration: xSpeed)
                            .repeatForever(autoreverses: false),
                        value: animate
                    )
                    .rotation3DEffect(
                        .degrees(animate ? 360 : 0),
                        axis: (x: 0, y: 0, z: 1),
                        anchor: UnitPoint(x: anchor, y: anchor)
                    )
                    .animation(
                        Animation
                            .linear(duration: zSpeed)
                            .repeatForever(autoreverses: false),
                        value: animate
                    )
            }
        }
    }

    // A view modifier that applies confetti animation to a view.
    // It manages the visibility of the confetti based on a binding variable,
    // and controls the animation duration and fade-out effect.
    struct ConfettiModifier<ConfettiShape: View>: ViewModifier {
        /// A binding that controls the visibility of the confetti.
        /// When set to true, the confetti animation is displayed.
        @Binding var isActive: Bool {
            didSet {
                if !isActive {
                    opacity = 1
                }
            }
        }

        /// An array of colors for the confetti pieces.
        var colors: [Color]

        /// A flag that determines whether the confetti animation should automatically end after a set duration.
        var automaticEnd: Bool = true

        /// The shape of the confetti pieces, which can be any SwiftUI view.
        var shape: ConfettiShape

        /// The opacity of the confetti animation, which starts at 1.0 and fades out to 0.
        /// When the opacity reaches 0, the `isActive` binding is set to false
        @State private var opacity = 1.0 {
            didSet {
                if opacity == 0 {
                    isActive = false
                }
            }
        }

        /// The duration of the confetti animation.
        var animationTime = 3.0

        /// The duration of the fade-out effect after the confetti animation ends.
        var fadeTime = 2.0

        func body(content: Content) -> some View {
            if #available(iOS 17.0, macOS 14.0, *) {
                content
                    .overlay(
                        isActive
                            ? ConfettiView(colors: colors, shape: shape).opacity(opacity)
                            : nil
                    )
                    .sensoryFeedback(.success, trigger: isActive)
                    .task {
                        await handleAnimationSequence()
                    }
            } else {
                content
                    .overlay(
                        isActive
                            ? ConfettiView(colors: colors, shape: shape).opacity(opacity)
                            : nil
                    )
                    .task {
                        await handleAnimationSequence()
                    }
            }
        }

        private func handleAnimationSequence() async {
            if !automaticEnd { return }
            do {
                try await Task.sleep(nanoseconds: UInt64(animationTime * 1_000_000_000))
                withAnimation(.easeOut(duration: fadeTime)) {
                    opacity = 0
                }
            } catch {}
        }
    }

    public extension View {
        /// Displays confetti on the view when `isActive` is true.
        /// This modifier can be used to celebrate events like achievements, \
        /// wins, or other significant moments in your app.
        ///
        /// - Parameters:
        ///   - isActive: A binding that controls the visibility of the confetti.
        ///   - colors: An array of colors for the confetti. Defaults to a set of vibrant colors.
        ///   - automaticEnd: A boolean that determines whether the confetti animation should \
        ///                   automatically end after a set duration. Defaults to true.
        ///   - shape: The shape of the confetti. Defaults to a rectangle.
        ///   - animationTime: The duration of the confetti animation in seconds.
        ///   - fadeTime: The duration of the fade-out effect after the confetti animation ends.
        func displayConfetti(
            isActive: Binding<Bool>,
            colors: [Color] = [Color.orange, Color.green, Color.blue, Color.red, Color.yellow],
            automaticEnd: Bool = true,
            shape: some View = Rectangle(),
            animationTime: Double = 3.0,
            fadeTime: Double = 2.0
        ) -> some View {
            modifier(
                ConfettiModifier(
                    isActive: isActive,
                    colors: colors,
                    automaticEnd: automaticEnd,
                    shape: shape,
                    animationTime: animationTime,
                    fadeTime: fadeTime
                )
            )
        }
    }

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            @Previewable @State var isActive = false

            VStack {
                Text("Hello world")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task {
                isActive.toggle()
            }
            .displayConfetti(isActive: $isActive, automaticEnd: false)
        }
    #endif
#endif
