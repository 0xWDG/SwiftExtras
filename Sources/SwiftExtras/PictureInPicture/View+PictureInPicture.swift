//
//  View+PictureInPicture.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(AVKit) && !os(watchOS)
import SwiftUI

public extension View {
    /// Presents this view in the system Picture in Picture window.
    ///
    /// Start Picture in Picture from an explicit user action. The containing app must enable
    /// the Audio, AirPlay, and Picture in Picture background mode.
    ///
    /// - Parameter isPresented: A binding that starts and stops Picture in Picture.
    func pictureInPicture(isPresented: Binding<Bool>) -> some View {
        modifier(
            ViewPictureInPictureModifier(
                isPresented: isPresented,
                pictureInPictureContent: { self },
                usesSourceViewSize: true
            )
        )
    }

    /// Presents custom SwiftUI content in the system Picture in Picture window.
    ///
    /// Start Picture in Picture from an explicit user action. The containing app must enable
    /// the Audio, AirPlay, and Picture in Picture background mode.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that starts and stops Picture in Picture.
    ///   - content: The view to render in the Picture in Picture window.
    func pictureInPicture<PictureContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> PictureContent
    ) -> some View {
        modifier(
            ViewPictureInPictureModifier(
                isPresented: isPresented,
                pictureInPictureContent: content,
                usesSourceViewSize: false
            )
        )
    }
}

private struct ViewPictureInPictureModifier<PictureContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @StateObject private var controller = ViewPictureInPictureController()

    let pictureInPictureContent: () -> PictureContent
    let usesSourceViewSize: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if usesSourceViewSize {
                    GeometryReader { geometry in
                        renderingLayer(size: geometry.size)
                    }
                } else {
                    renderingLayer(size: nil)
                }
            }
            .onChange(of: isPresented) { newValue in
                updatePresentation(newValue)
            }
            .onChange(of: controller.isActive) { newValue in
                if isPresented != newValue {
                    isPresented = newValue
                }
            }
            .task {
                controller.setContent(pictureInPictureContent())
                updatePresentation(isPresented)
            }
            .onDisappear {
                controller.stop()
            }
    }

    private func renderingLayer(size: CGSize?) -> some View {
        PictureInPictureLayerView(
            displayLayer: controller.displayLayer,
            preferredSize: size
        )
        .opacity(0)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func updatePresentation(_ shouldPresent: Bool) {
        if shouldPresent {
            guard PictureInPicture.isSupported else {
                isPresented = false
                return
            }
            controller.start()
        } else {
            controller.stop()
        }
    }
}

#if DEBUG
@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
private struct PictureInPicturePreview: View {
    @State private var isPresented = false

    var body: some View {
        VStack(spacing: 16) {
            pictureContent
                .frame(width: 320, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Button {
                isPresented = true
            } label: {
                Label("Start Picture in Picture", systemImage: "pip.enter")
            }
            .disabled(PictureInPicture.isSupported == false)
            .accessibilityHint(
                PictureInPicture.isSupported
                    ? "Displays the example view in a system Picture in Picture window"
                    : "Picture in Picture is unavailable on this device"
            )
        }
        .padding()
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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
#Preview("Picture in Picture") {
    PictureInPicturePreview()
}
#endif
#endif
