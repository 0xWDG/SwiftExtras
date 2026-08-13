//
//  ModifierExamples.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(AppKit) || (os(iOS) && canImport(UIKit))
#if canImport(AppKit)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import SwiftExtras
import SwiftUI

@available(macOS 14, iOS 17, *)
struct ScrollTrackingExample: View {
    @State private var position = UnitPoint.zero

    var body: some View {
        ExampleFrame(title: "Scroll tracking on iOS") {
            Text("Vertical progress: \(position.y, format: .percent.precision(.fractionLength(0)))")
                .font(.headline)
                .accessibilityLabel("Vertical scroll progress")
                .accessibilityValue(
                    Text(position.y, format: .percent.precision(.fractionLength(0)))
                )

            ScrollViewReader { _ in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(1...8, id: \.self) { item in
                            Label("Documentation section \(item)", systemImage: "doc.text")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.trailing, 8)
                }
                .trackScrolling()
            }
            .onScrolled { position = $0 }
            .frame(height: 440)
        }
    }
}

@available(macOS 14, iOS 17, *)
struct StretchyHeaderExample: View {
    var body: some View {
        ScrollView {
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .accessibilityHidden(true)

                Text("Pull to stretch")
                    .font(.title.bold())
                    .foregroundStyle(.white)
            }
            .asStretchyHeader(startingHeight: 260)

            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(1...6, id: \.self) { item in
                    Label("Example item \(item)", systemImage: "sparkles")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .background(screenshotBackgroundColor)
    }
}

@available(macOS 14, iOS 17, *)
struct IslandToastExample: View {
    @State private var toast: String? = "saved"

    @ViewBuilder
    var body: some View {
        #if os(iOS)
        exampleContent
            .overlay(alignment: .bottom) {
                documentationToast
                    .padding(.horizontal)
                    .padding(.bottom, 40)
            }
        #else
        exampleContent
            .islandToast(item: $toast) { _ in
                IslandToastCard(
                    title: "Changes saved",
                    subtitle: "Your project is up to date.",
                    role: .success,
                    duration: nil
                )
            }
        #endif
    }

    private var exampleContent: some View {
        ExampleFrame(title: "Island toast on iOS") {
            VStack(alignment: .leading) {
                Text("Edit your project, then show a non-blocking confirmation.")
                    .foregroundStyle(.secondary)

                Button("Show saved notification") {
                    toast = "saved"
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.blue, in: Capsule())
                .accessibilityHint("Shows a confirmation at the bottom of the example")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private var documentationToast: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.green)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Changes saved")
                    .font(.headline)
                Text("Your project is up to date.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.primary.opacity(0.08), in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Changes saved. Your project is up to date.")
    }
}

@available(macOS 14, iOS 17, *)
struct PictureInPictureExample: View {
    @State private var isPresented = false

    var body: some View {
        ExampleFrame(title: "Picture in Picture on iOS") {
            pictureContent
                .frame(height: 190)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Button {
                isPresented = true
            } label: {
                Label("Start Picture in Picture", systemImage: "pip.enter")
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.blue, in: Capsule())
            .accessibilityHint("Displays the example view in a system Picture in Picture window")
        }
        .pictureInPicture(isPresented: $isPresented) {
            pictureContent
        }
    }

    private var pictureContent: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .accessibilityHidden(true)

            Label("SwiftUI Picture in Picture", systemImage: "pip.fill")
                .font(.headline)
                .foregroundStyle(.white)
        }
    }
}

@available(macOS 14, iOS 17, *)
struct ShimmerExample: View {
    var body: some View {
        ExampleFrame(title: "Shimmer on iOS") {
            VStack(alignment: .leading, spacing: 14) {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 110)

                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 22)

                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 220, height: 22)
            }
            .foregroundStyle(.gray.opacity(0.45))
            .shimmering(
                animation: .easeInOut(duration: 1).repeatForever(autoreverses: true),
                gradient: Gradient(colors: [.clear, .white.opacity(0.9), .clear]),
                mode: .overlay(blendMode: .screen)
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Loading profile placeholder")
        }
    }
}

@available(macOS 14, iOS 17, *)
struct BorderBeamExample: View {
    var body: some View {
        ExampleFrame(title: "Border beam on iOS") {
            VStack(alignment: .leading, spacing: 18) {
                Label("Ready to publish", systemImage: "checkmark.seal.fill")
                    .font(.headline)

                Text("The animated gradient highlights the edge without obscuring content.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.black, in: RoundedRectangle(cornerRadius: 20))
            .foregroundStyle(.white)
            .borderBeam(
                border: .purple,
                hidesFadedBorder: false,
                beam: [.cyan, .blue, .purple, .pink],
                beamBlur: 10
            )
            .accessibilityElement(children: .combine)
        }
    }
}

@available(macOS 14, iOS 17, *)
struct StickySectionExample: View {
    var body: some View {
        ExampleFrame(title: "Sticky section on iOS") {
            ScrollView {
                StickySection {
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(1...5, id: \.self) { item in
                            Label("Recent activity \(item)", systemImage: "clock.arrow.circlepath")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                } header: {
                    Text("Project activity")
                        .font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)
                } minimizedHeader: {
                    Text("Activity")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)
                }
            }
        }
    }
}

#if os(iOS)
@available(iOS 17, *)
struct VerificationFieldExample: View {
    @State private var code = "284"

    var body: some View {
        ExampleFrame(title: "Verification field on iOS") {
            Text("Enter the six-digit code")
                .font(.headline)

            VerificationField(type: .six, value: $code) { value in
                value.count == 6 ? .valid : .typing
            }

            Text("Codes can be entered automatically or pasted from the clipboard.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
#endif
#endif
