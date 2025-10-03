//
//
//  View+onFirstAppear.swift
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
        ZStack {
            content
                .overlay {
                    if currentStep == stepIndex {
                        Color
                            .accentColor
                            .padding(10)
                            .border(Color.accentColor, width: 2)
                            .popover(isPresented: .constant(true)) {
                                VStack {
//                                    Text("\(currentStep+1)/\(steps.count)")
//                                        .font(.caption2)
//                                        .frame(maxWidth: .infinity, alignment: .trailing)

                                    Text(steps[currentStep].text)

                                    Spacer(minLength: 20)
                                    HStack {
                                        Button("Previous") {
                                            currentStep -= 1
                                        }
                                        .disabled(currentStep == 0)
                                        Spacer(minLength: 40)

                                        if skipable {
                                            Button("Skip") {
                                                currentStep = steps.count
                                            }
                                            Spacer(minLength: 40)
                                        }

                                        if (currentStep + 1) == steps.count {
                                            Button("Finish") {
                                                currentStep += 1
                                            }
                                        } else {
                                            Button("Next") {
                                                currentStep += 1
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .presentationCompactAdaptation(.popover)
                                .interactiveDismissDisabled()
                            }
                    }
                }
        }
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
