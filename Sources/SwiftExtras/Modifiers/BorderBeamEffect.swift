//
//  BorderBeamEffect.swift
//  SwiftExtras
//
//  Created by Balaji Venkatesh on 2026-04-30.
//  https://github.com/0xWDG/SwiftExtras
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A rotating gradient beam drawn around a rounded view border.
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
public struct BorderBeamEffect: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let border: Color
    private let hidesFadedBorder: Bool
    private let beam: [Color]
    private let beamBlur: CGFloat
    private let cornerRadius: CGFloat
    private let isEnabled: Bool

    /// Creates a border beam effect.
    ///
    /// - Parameters:
    ///   - border: The color of the narrow animated border.
    ///   - hidesFadedBorder: Whether to hide the subtle stationary border.
    ///   - beam: The colors used for the diffused beam.
    ///   - beamBlur: The blur radius applied to the beam.
    ///   - cornerRadius: The corner radius of the effect.
    ///   - isEnabled: Whether to display the effect.
    public init(
        border: Color = .white,
        hidesFadedBorder: Bool = true,
        beam: [Color] = [.green, .blue, .pink, .orange, .indigo],
        beamBlur: CGFloat = 15,
        cornerRadius: CGFloat = 20,
        isEnabled: Bool = true
    ) {
        self.border = border
        self.hidesFadedBorder = hidesFadedBorder
        self.beam = beam
        self.beamBlur = beamBlur
        self.cornerRadius = cornerRadius
        self.isEnabled = isEnabled
    }

    /// Adds the configured beam over the edge of the modified content.
    public func body(content: Content) -> some View {
        content.overlay {
            if isEnabled {
                borderBeam
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
        }
    }

    @ViewBuilder
    private var borderBeam: some View {
        ZStack {
            if !hidesFadedBorder {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(border.opacity(0.3), lineWidth: 0.6)
            }

            if reduceMotion {
                beamLayers(rotation: 0)
            } else {
                KeyframeAnimator(initialValue: 0.0, repeating: true) { value in
                    beamLayers(rotation: value * 360)
                } keyframes: { _ in
                    LinearKeyframe(1, duration: 2.5)
                }
            }
        }
        .padding(0.5)
    }

    private func beamLayers(rotation: Double) -> some View {
        let borderGradient = AngularGradient(
            colors: [.clear, border, .clear],
            center: .center,
            startAngle: .degrees(140 + rotation),
            endAngle: .degrees(270 + rotation)
        )
        let beamGradient = LinearGradient(
            colors: beam,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        return ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(beamGradient)
                .mask {
                    Rectangle()
                        .overlay {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .blur(radius: beamBlur)
                                .blendMode(.destinationOut)
                        }
                        .compositingGroup()
                }
                .mask {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(borderGradient)
                        .blur(radius: beamBlur / 1.5)
                        .padding(-beamBlur * 2)
                }

            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderGradient, lineWidth: 0.6)
        }
    }
}

public extension View {
    /// Draws a rotating gradient beam around the view's rounded border.
    ///
    /// Reduce Motion displays a stationary beam.
    /// - Parameters:
    ///   - border: The color of the narrow animated border.
    ///   - hidesFadedBorder: Whether to hide the subtle stationary border.
    ///   - beam: The colors used for the diffused beam.
    ///   - beamBlur: The blur radius applied to the beam.
    ///   - cornerRadius: The corner radius of the effect.
    ///   - isEnabled: Whether to display the effect.
    @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
    func borderBeam(
        border: Color = .white,
        hidesFadedBorder: Bool = true,
        beam: [Color] = [.green, .blue, .pink, .orange, .indigo],
        beamBlur: CGFloat = 15,
        cornerRadius: CGFloat = 20,
        isEnabled: Bool = true
    ) -> some View {
        modifier(BorderBeamEffect(
            border: border,
            hidesFadedBorder: hidesFadedBorder,
            beam: beam,
            beamBlur: beamBlur,
            cornerRadius: cornerRadius,
            isEnabled: isEnabled
        ))
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Text("Border beam")
        .font(.headline)
        .padding(.horizontal, 28)
        .padding(.vertical, 18)
        .background(.black, in: RoundedRectangle(cornerRadius: 20))
        .foregroundStyle(.white)
        .borderBeam(hidesFadedBorder: false)
        .padding(40)
}
#endif
#endif
