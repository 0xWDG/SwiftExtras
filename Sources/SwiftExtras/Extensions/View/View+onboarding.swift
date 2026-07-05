//
//
//  View+onboarding.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-09-23.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && !os(watchOS) && !os(tvOS)
import SwiftUI

/// A view modifier that highlights a view and shows a popover with explanation text.
/// 
/// Example usage:
/// ```swift
/// @State private var currentStep = 0
/// let steps = [
///     OnboardingStep(text: "This is your title."),
///     OnboardingStep(text: "Tap this button to perform the main action."),
///     OnboardingStep(text: "Here’s another important option.")
/// ]
/// VStack {
///     Text("Title")
///         .onboarding(steps: steps, currentStep: $currentStep, index: 0, skipable: true)
///     Button("Main Action")
///         .onboarding(steps: steps, currentStep: $currentStep, index: 1)
///     Button("Another Option")
///         .onboarding(steps: steps, currentStep: $currentStep, index: 2)
/// }
/// ```
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
struct OnboardingModifier: ViewModifier {
    @Binding var currentStep: Int
    let stepIndex: Int
    let steps: [OnboardingStep]
    let skipable: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if currentStep == stepIndex {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.accentColor, lineWidth: 2)
                        .padding(-10)
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }
            }
            .matchedPopoverSource(id: stepIndex, anchor: .bottom)
            .matchedPopover(
                selection: popoverSelection,
                anchor: { _ in .bottom },
                dismissOnBackgroundTap: false,
                popover: { index in
                    if steps.indices.contains(index) {
                        popoverContent(for: index)
                    }
                }
            )
    }

    private var popoverSelection: Binding<Int?> {
        Binding {
            currentStep == stepIndex && steps.indices.contains(currentStep) ? stepIndex : nil
        } set: { newValue in
            if let newValue {
                currentStep = newValue
            }
        }
    }

    @ViewBuilder
    private func popoverContent(for index: Int) -> some View {
        VStack {
            Text(steps[index].text)

            Spacer(minLength: 20)

            HStack {
                Button("Previous") {
                    currentStep -= 1
                }
                .disabled(currentStep == 0)
                .accessibilityLabel("Previous onboarding step")

                Spacer(minLength: 40)

                if skipable {
                    Button("Skip") {
                        currentStep = steps.count
                    }
                    .accessibilityLabel("Skip onboarding")

                    Spacer(minLength: 40)
                }

                Button((currentStep + 1) == steps.count ? "Finish" : "Next") {
                    currentStep += 1
                }
                .accessibilityLabel(
                    (currentStep + 1) == steps.count ? "Finish onboarding" : "Next onboarding step"
                )
            }
        }
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 12))
        .shadow(radius: 12)
        .padding()
        .accessibilityElement(children: .contain)
    }
}

extension View {
    /// A view modifier that highlights a view and shows a popover with explanation text.
    /// - Parameters:
    ///   - steps: An array of `OnboardingStep` representing the steps of the onboarding process.
    ///   - currentStep: A binding to the current step index.
    ///   - index: The index of this particular step in the onboarding process.
    ///   - skipable: A boolean indicating whether the onboarding can be skipped.
    /// - Returns: A view modified with the onboarding step.
    @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
    public func onboarding(
        steps: [OnboardingStep],
        currentStep: Binding<Int>,
        index: Int,
        skipable: Bool = false
    ) -> some View {
        self.modifier(
            OnboardingModifier(
                currentStep: currentStep,
                stepIndex: index,
                steps: steps,
                skipable: skipable
            )
        )
    }
}

/// A struct representing a single step in the onboarding process.
public struct OnboardingStep: Identifiable {
    /// Identifier
    public let id = UUID()
    /// Text
    public let text: String

    /// Initializes a new `OnboardingStep` with the provided text.
    /// - Parameter text: The explanation text for this onboarding step.
    public init(text: String) {
        self.text = text
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    @Previewable @State var step = 0

    let steps = [
        OnboardingStep(text: "This is your title."),
        OnboardingStep(text: "Tap this button to perform the main action."),
        OnboardingStep(text: "Here’s another important option.")
    ]

    VStack {
        Text("Test")
            .onboarding(steps: steps, currentStep: $step, index: 0, skipable: true)
        Text("Test")
            .onboarding(steps: steps, currentStep: $step, index: 1)

        Text("Test")
            .onboarding(steps: steps, currentStep: $step, index: 2)

        Button("RESET") {
            step = 0
        }
    }
}
#endif
#endif
