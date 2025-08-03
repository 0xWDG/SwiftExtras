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
    var count: Int = 50
    var colors: [Color]
    var shape: ConfettiShape
    @State var yPosition: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { _ in
                Confetti(colors: colors, shape: shape)
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: yPosition != 0 ? CGFloat.random(in: 0...UIScreen.main.bounds.height) : yPosition
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            yPosition = CGFloat.random(in: 0...UIScreen.main.bounds.height)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    /// A view that represents a single confetti piece.
    /// It animates with a 3D rotation effect and falls down the screen.
    /// The confetti piece can be customized with different colors and shapes.
    /// - Parameters:
    ///   - colors: An array of colors for the confetti piece.
    ///   - shape: The shape of the confetti piece, which can be any SwiftUI view.
    /// - Returns: A view that represents the confetti piece with animation.
    struct Confetti: View {
        @State private var animate = false
        @State private var xSpeed = Double.random(in: 0.7...2)
        @State private var zSpeed = Double.random(in: 1...2)
        @State private var anchor = CGFloat.random(in: 0...1).rounded()
        var colors: [Color]
        var shape: ConfettiShape

        var body: some View {
            shape
                .foregroundStyle(colors.randomElement() ?? Color.green)
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

struct ConfettiModifier<ConfettiShape: View>: ViewModifier {
    @Binding var isActive: Bool {
        didSet {
            if !isActive {
                opacity = 1
            }
        }
    }

    var colors: [Color]
    var automaticEnd: Bool = true
    var shape: ConfettiShape

    @State private var opacity = 1.0 {
        didSet {
            if opacity == 0 {
                isActive = false
            }
        }
    }

    private let animationTime = 3.0
    private let fadeTime = 2.0

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
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

extension View {
    /// Displays confetti on the view when `isActive` is true.
    /// This modifier can be used to celebrate events like achievements, wins, or other significant moments in your app.
    /// 
    /// - Parameters:
    ///   - isActive: A binding that controls the visibility of the confetti.
    ///   - colors: An array of colors for the confetti. Defaults to a set of vibrant colors.
    ///   - shape: The shape of the confetti. Defaults to a rectangle.
    public func displayConfetti<ConfettiShape: View>(
        isActive: Binding<Bool>,
        colors: [Color] = [Color.orange, Color.green, Color.blue, Color.red, Color.yellow],
        automaticEnd: Bool = true,
        shape: ConfettiShape = Rectangle()
    ) -> some View {
        self.modifier(
            ConfettiModifier(
                isActive: isActive,
                colors: colors,
                automaticEnd: automaticEnd,
                shape: shape
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
    .task {
        isActive.toggle()
    }
    .displayConfetti(isActive: $isActive, automaticEnd: false)
}
#endif
#endif
