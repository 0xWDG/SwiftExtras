//
//  PictureInPictureController.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(AVKit) && !os(watchOS)
import AVKit
import OSLog
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@MainActor
final class ViewPictureInPictureController: NSObject, ObservableObject {
    @Published private(set) var isActive = false

    let displayLayer = AVSampleBufferDisplayLayer()

    private var controller: AVPictureInPictureController?
    private var possibleObservation: NSKeyValueObservation?
    private var renderingTask: Task<Void, Never>?
    private var renderFrame: (() throws -> CMSampleBuffer)?
    private var isPlaying = true

    override init() {
        super.init()
        configureAudioSession()
        configureController()
    }

    /// Performs the `setContent` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func setContent(_ content: some View) {
        let renderer = PictureInPictureRenderer(content: content)
        renderFrame = {
            try renderer.makeSampleBuffer()
        }
        renderOnce()
    }

    /// Performs the `start` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func start() {
        guard let controller else {
            isActive = false
            return
        }

        guard controller.isPictureInPictureActive == false else {
            return
        }

        activateAudioSession()
        startRendering()
        controller.invalidatePlaybackState()

        if controller.isPictureInPicturePossible {
            controller.startPictureInPicture()
        } else {
            observePictureInPicturePossibility(controller)
        }
    }

    /// Performs the `stop` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func stop() {
        possibleObservation = nil
        renderingTask?.cancel()
        renderingTask = nil
        controller?.stopPictureInPicture()
        deactivateAudioSession()
    }

    /// Performs the `configureController` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    private func configureController() {
        guard PictureInPicture.isSupported else {
            return
        }

        displayLayer.frame.size = CGSize(width: 320, height: 180)
        displayLayer.videoGravity = .resizeAspect

        let source = AVPictureInPictureController.ContentSource(
            sampleBufferDisplayLayer: displayLayer,
            playbackDelegate: self
        )
        let controller = AVPictureInPictureController(contentSource: source)
        controller.delegate = self
        controller.requiresLinearPlayback = true
        self.controller = controller
    }

    /// Performs the `observePictureInPicturePossibility` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    private func observePictureInPicturePossibility(
        _ controller: AVPictureInPictureController
    ) {
        possibleObservation = controller.observe(
            \.isPictureInPicturePossible,
            options: [.new]
        ) { [weak self] controller, change in
            guard change.newValue == true else {
                return
            }

            Task { @MainActor [weak self, weak controller] in
                controller?.startPictureInPicture()
                self?.possibleObservation = nil
            }
        }
    }

    /// Performs the `startRendering` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    private func startRendering() {
        renderingTask?.cancel()
        renderingTask = Task { @MainActor [weak self] in
            while Task.isCancelled == false {
                if self?.isPlaying == true {
                    self?.renderOnce()
                }

                try? await Task.sleep(for: .milliseconds(33))
            }
        }
    }

    /// Performs the `renderOnce` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    private func renderOnce() {
        guard let renderFrame else {
            return
        }

        do {
            let sampleBuffer = try renderFrame()
            if displayLayer.status == .failed {
                displayLayer.flush()
            }
            displayLayer.enqueue(sampleBuffer)
        } catch {
            pictureInPictureLogger.error(
                "Unable to render Picture in Picture content: \(error.localizedDescription)"
            )
        }
    }

    /// Performs the `configureAudioSession` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    private func configureAudioSession() {
        #if canImport(UIKit)
        let session = AVAudioSession.sharedInstance()
        guard session.category == .soloAmbient || session.mode == .default else {
            return
        }

        do {
            try session.setCategory(.playback, mode: .moviePlayback, options: .mixWithOthers)
        } catch {
            pictureInPictureLogger.error(
                "Unable to configure the audio session: \(error.localizedDescription)"
            )
        }
        #endif
    }

    /// Performs the `activateAudioSession` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    private func activateAudioSession() {
        #if canImport(UIKit)
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            pictureInPictureLogger.error(
                "Unable to activate the audio session: \(error.localizedDescription)"
            )
        }
        #endif
    }

    /// Performs the `deactivateAudioSession` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    private func deactivateAudioSession() {
        #if canImport(UIKit)
        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
        #endif
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
/// Declares the `AVPictureInPictureControllerDelegate` conformance for
/// `ViewPictureInPictureController`.
///
/// The conformance supplies the protocol behavior implemented by the declarations in this scope.
extension ViewPictureInPictureController: @preconcurrency AVPictureInPictureControllerDelegate {
    /// Performs the `pictureInPictureControllerDidStartPictureInPicture` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureControllerDidStartPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
        isActive = true
    }

    /// Performs the `pictureInPictureControllerDidStopPictureInPicture` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureControllerDidStopPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
        renderingTask?.cancel()
        renderingTask = nil
        isActive = false
        deactivateAudioSession()
    }

    /// Performs the `pictureInPictureController` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        failedToStartPictureInPictureWithError error: Error
    ) {
        renderingTask?.cancel()
        renderingTask = nil
        isActive = false
        deactivateAudioSession()
        pictureInPictureLogger.error(
            "Unable to start Picture in Picture: \(error.localizedDescription)"
        )
    }

    /// Performs the `pictureInPictureController` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
    ) {
        isActive = false
        completionHandler(true)
    }

    /// Performs the `pictureInPictureControllerShouldProhibitBackgroundAudioPlayback` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureControllerShouldProhibitBackgroundAudioPlayback(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> Bool {
        false
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
/// Declares the `AVPictureInPictureSampleBufferPlaybackDelegate` conformance for
/// `ViewPictureInPictureController`.
///
/// The conformance supplies the protocol behavior implemented by the declarations in this scope.
extension ViewPictureInPictureController: @preconcurrency AVPictureInPictureSampleBufferPlaybackDelegate {
    /// Performs the `pictureInPictureController` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        setPlaying playing: Bool
    ) {
        isPlaying = playing
        pictureInPictureController.invalidatePlaybackState()
    }

    /// Performs the `pictureInPictureControllerIsPlaybackPaused` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureControllerIsPlaybackPaused(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> Bool {
        isPlaying == false
    }

    /// Performs the `pictureInPictureControllerTimeRangeForPlayback` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureControllerTimeRangeForPlayback(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> CMTimeRange {
        CMTimeRange(
            start: CMTime(value: 1, timescale: 1),
            end: CMTime(value: 2, timescale: 1)
        )
    }

    /// Performs the `pictureInPictureController` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        didTransitionToRenderSize newRenderSize: CMVideoDimensions
    ) {}

    /// Performs the `pictureInPictureController` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        skipByInterval skipInterval: CMTime
    ) async {}
}

private let pictureInPictureLogger = Logger(
    subsystem: "nl.wesleydegroot.SwiftExtras",
    category: "PictureInPicture"
)
#endif
