//
//  ModifiersDemo.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import SwiftExtras
import SwiftUI

private extension Notification.Name {
    static let demoPing = Notification.Name("SwiftExtrasDemo.ping")
}

@available(macOS 14, *)
struct ModifiersDemo: View {
    var body: some View {
        DemoPage(
            "Modifiers & Effects",
            summary: "Animated effects, transient presentation, observation, tasks, geometry, and onboarding."
        ) {
            EffectsDemo()
            PresentationModifiersDemo()
            ScrollTrackingModifierDemo()
            ObservationModifiersDemo()
            MatchedPopoverDemo()
            OnboardingModifierDemo()
            SpotlightModifierDemo()
            FloatingBarDemo()
        }
    }
}

@available(macOS 14, *)
struct ScrollTrackingModifierDemo: View {
    @State private var position = UnitPoint.zero

    var body: some View {
        DemoPanel("Scroll tracking", systemImage: "scroll") {
            DemoValueRow(
                label: "Vertical progress",
                value: Double(position.y).formatted(
                    .percent.precision(.fractionLength(0))
                )
            )

            ScrollViewReader { _ in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(1...10, id: \.self) { index in
                            Text("Tracked row \(index)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(10)
                                .background(.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .trackScrolling()
            }
            .onScrolled { position = $0 }
            .frame(height: 180)
            .accessibilityLabel("Scroll view with normalized position tracking")
        }
    }
}

@available(macOS 14, *)
struct EffectsDemo: View {
    @State private var shakeCount: CGFloat = 0
    @State private var isShimmering = true
    @State private var longPressMessage = "Try a short or long press"

    var body: some View {
        DemoPanel("Visual effects", systemImage: "wand.and.stars") {
            Toggle("Shimmer", isOn: $isShimmering)

            HStack(spacing: 28) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(.gray.opacity(0.4))
                    .frame(width: 150, height: 90)
                    .shimmering(active: isShimmering)
                    .accessibilityLabel("Shimmer effect")

                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.pink)
                    .pulsating()
                    .accessibilityLabel("Pulsating heart")

                Button("Shake") {
                    withAnimation(.linear(duration: 0.5)) {
                        shakeCount += 1
                    }
                }
                .shake(shakeCount)
                .accessibilityHint("Animates the button horizontally")
            }

            Text("Animated border beam")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(.black, in: RoundedRectangle(cornerRadius: 20))
                .borderBeam(border: .purple, hidesFadedBorder: false)

            Button("Long-press capable button") {
                longPressMessage = "Short press detected"
            }
            .longPress {
                longPressMessage = "Long press detected"
            }
            .customBadge(12)
            .accessibilityValue(longPressMessage)

            Text(longPressMessage)
                .foregroundStyle(.secondary)
        }
    }
}

@available(macOS 14, *)
struct PresentationModifiersDemo: View {
    @State private var showsToast = false
    @State private var islandItem: String?
    @State private var error: Error?
    @State private var showsConfetti = false

    var body: some View {
        DemoPanel("Presentation", systemImage: "rectangle.on.rectangle") {
            HStack {
                Button("Toast") {
                    showsToast = true
                }
                Button("Island toast") {
                    islandItem = "Saved"
                }
                Button("Error alert") {
                    error = CustomError(message: "This is a SwiftExtras error alert.")
                }
                Button("Confetti") {
                    showsConfetti = true
                }
            }
            .buttonStyle(.bordered)

            Text("Presentation target")
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 14))
                .toast(
                    isPresented: $showsToast,
                    systemImageName: "checkmark.circle.fill",
                    message: "Toast presented",
                    tint: .green
                )
                .islandToast(item: $islandItem) { value in
                    IslandToastCard(title: value, subtitle: "IslandToast is live", role: .success)
                }
                .showError(error: $error)
                .displayConfetti(isActive: $showsConfetti, shape: Text("✨"))
        }
    }
}

@available(macOS 14, *)
struct ObservationModifiersDemo: View {
    @State private var sliderValue = 25.0
    @State private var debouncedValue = 25.0
    @State private var notificationCount = 0
    @State private var appeared = false
    @State private var delayedTaskFinished = false

    var body: some View {
        DemoPanel("Observation and tasks", systemImage: "waveform.path.ecg") {
            Slider(value: $sliderValue, in: 0...100)
                .accessibilityLabel("Debounced value")
                .onChange(of: sliderValue, after: .milliseconds(400)) { value in
                    debouncedValue = value
                }

            DemoValueRow(label: "Live", value: sliderValue.formatted(.number.precision(.fractionLength(1))))
            DemoValueRow(
                label: "Debounced",
                value: debouncedValue.formatted(.number.precision(.fractionLength(1)))
            )

            Button("Post Notification.Name") {
                Notification.Name.demoPing.post()
            }
            .accessibilityHint("Posts through the SwiftExtras notification helper")

            DemoValueRow(label: "Notifications received", value: notificationCount.formatted())
            DemoValueRow(label: "onFirstAppear", value: appeared ? "Triggered" : "Waiting")
            DemoValueRow(label: "Delayed task", value: delayedTaskFinished ? "Finished" : "Waiting")
        }
        .onNotification(name: .demoPing) { _ in
            notificationCount += 1
        }
        .onFirstAppear {
            appeared = true
        }
        .task(delay: .milliseconds(500)) {
            delayedTaskFinished = true
        }
    }
}

@available(macOS 14, *)
struct MatchedPopoverDemo: View {
    @State private var selection: String?

    var body: some View {
        DemoPanel("Matched popover", systemImage: "rectangle.inset.filled.and.person.filled") {
            HStack {
                Button("Account") {
                    withAnimation { selection = "Account" }
                }
                .matchedPopoverSource(id: "Account")

                Button("Settings") {
                    withAnimation { selection = "Settings" }
                }
                .matchedPopoverSource(id: "Settings")
            }
            .buttonStyle(.bordered)
        }
        .matchedPopover(selection: $selection) { selected in
            Label(selected, systemImage: selected == "Account" ? "person.circle" : "gear")
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel("Popover for \(selected)")
        }
    }
}

@available(macOS 14, *)
struct OnboardingModifierDemo: View {
    @State private var currentStep = 3

    private let steps = [
        OnboardingStep(text: "This is the title."),
        OnboardingStep(text: "This button performs the main action."),
        OnboardingStep(text: "This is the final option.")
    ]

    var body: some View {
        DemoPanel("Onboarding modifier", systemImage: "lightbulb") {
            HStack(spacing: 20) {
                Text("Title")
                    .onboarding(steps: steps, currentStep: $currentStep, index: 0, skipable: true)
                Button("Main action") { }
                    .onboarding(steps: steps, currentStep: $currentStep, index: 1)
                Button("Final option") { }
                    .onboarding(steps: steps, currentStep: $currentStep, index: 2)
                Button("Start tour") {
                    currentStep = 0
                }
                .accessibilityHint("Starts the three-step onboarding demonstration")
            }
        }
    }
}

@available(macOS 14, *)
struct SpotlightModifierDemo: View {
    private enum Step: String, CaseIterable {
        case profile
        case favorites
    }

    @State private var selection: Step?

    var body: some View {
        DemoPanel("Spotlight onboarding", systemImage: "spotlight") {
            HStack {
                Label("Profile", systemImage: "person.crop.circle")
                    .padding()
                    .tutorialSpotlightSource(id: Step.profile, spotlightShape: .capsule)

                Spacer()

                Label("Favorites", systemImage: "heart.fill")
                    .padding()
                    .tutorialSpotlightSource(id: Step.favorites, spotlightShape: .capsule)
            }

            Button("Start spotlight tour") {
                selection = .profile
            }
            .accessibilityHint("Highlights the profile and favorites controls in sequence")
        }
        .tutorialSpotlight(
            selection: $selection,
            orderedIDs: Step.allCases,
            cornerRadius: 20
        ) { step, actions in
            VStack(alignment: .leading, spacing: 12) {
                Text(step == .profile ? "Your profile" : "Your favorites")
                    .font(.headline)
                Text("SwiftExtras positions this card around the highlighted source.")
                HStack {
                    Button("Dismiss", action: actions.dismiss)
                    Spacer()
                    Button("Previous", action: actions.previous)
                    Button("Next", action: actions.advance)
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

@available(macOS 14, *)
struct FloatingBarDemo: View {
    var body: some View {
        DemoPanel("Floating safe-area bar", systemImage: "dock.rectangle") {
            ScrollView {
                ForEach(1...6, id: \.self) { index in
                    Text("Scrollable row \(index)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
            .floatingSafeAreaBar {
                Label("Floating bar", systemImage: "sparkles")
            }
            .frame(height: 260)
        }
    }
}

@available(macOS 14, *)
#Preview("Modifiers") {
    ModifiersDemo()
        .frame(width: 900, height: 700)
}
