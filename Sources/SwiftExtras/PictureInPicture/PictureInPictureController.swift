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

    func setContent(_ content: some View) {
        let renderer = PictureInPictureRenderer(content: content)
        renderFrame = {
            try renderer.makeSampleBuffer()
        }
        renderOnce()
    }

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

    func stop() {
        possibleObservation = nil
        renderingTask?.cancel()
        renderingTask = nil
        controller?.stopPictureInPicture()
        deactivateAudioSession()
    }

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

            DispatchQueue.main.async {
                controller.startPictureInPicture()
                self?.possibleObservation = nil
            }
        }
    }

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

    private func deactivateAudioSession() {
        #if canImport(UIKit)
        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
        #endif
    }
}

extension ViewPictureInPictureController: @preconcurrency AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerDidStartPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
        isActive = true
    }

    func pictureInPictureControllerDidStopPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
        renderingTask?.cancel()
        renderingTask = nil
        isActive = false
        deactivateAudioSession()
    }

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

    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
    ) {
        isActive = false
        completionHandler(true)
    }

    func pictureInPictureControllerShouldProhibitBackgroundAudioPlayback(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> Bool {
        false
    }
}

extension ViewPictureInPictureController: @preconcurrency AVPictureInPictureSampleBufferPlaybackDelegate {
    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        setPlaying playing: Bool
    ) {
        isPlaying = playing
        pictureInPictureController.invalidatePlaybackState()
    }

    func pictureInPictureControllerIsPlaybackPaused(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> Bool {
        isPlaying == false
    }

    func pictureInPictureControllerTimeRangeForPlayback(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> CMTimeRange {
        CMTimeRange(
            start: CMTime(value: 1, timescale: 1),
            end: CMTime(value: 2, timescale: 1)
        )
    }

    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        didTransitionToRenderSize newRenderSize: CMVideoDimensions
    ) {}

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
