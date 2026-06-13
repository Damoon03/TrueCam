//
//  CameraManager.swift
//  TrueCam
//
//  Created by Damoon saber on 3/21/1405 AP.
//

import SwiftUI
import AVFoundation
import UIKit
import Combine

final class CameraManager: NSObject, ObservableObject {

    @Published var isSessionRunning = false
    @Published var permissionDenied = false
    @Published var capturedImage: UIImage?

    let session = AVCaptureSession()

    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private let photoOutput = AVCapturePhotoOutput()

    private var currentInput: AVCaptureDeviceInput?
    private var currentPosition: AVCaptureDevice.Position = .back

    override init() {
        super.init()
        checkPermissions()
    }

    // MARK: - Permissions

    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                DispatchQueue.main.async {
                    if granted {
                        self.configureSession()
                    } else {
                        self.permissionDenied = true
                    }
                }
            }

        case .denied, .restricted:
            DispatchQueue.main.async { self.permissionDenied = true }

        @unknown default:
            DispatchQueue.main.async { self.permissionDenied = true }
        }
    }

    // MARK: - Session setup

    func configureSession() {
        sessionQueue.async { [weak self] in
            guard let self else { return }

            // Already configured — just (re)start
            guard self.currentInput == nil else {
                self.startSession()
                return
            }

            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            defer {
                self.session.commitConfiguration()
                self.startSession()
            }

            guard let device = self.getCamera(for: self.currentPosition) else {
                print("DEBUG: No camera found for position \(self.currentPosition)")
                return
            }

            do {
                let input = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                    self.currentInput = input
                }
                if self.session.canAddOutput(self.photoOutput) {
                    self.session.addOutput(self.photoOutput)
                }
            } catch {
                print("DEBUG: Failed to configure camera input: \(error.localizedDescription)")
            }
        }
    }

    func startSession() {
        sessionQueue.async { [weak self] in
            guard let self, !self.session.isRunning else { return }
            self.session.startRunning()
            DispatchQueue.main.async { self.isSessionRunning = true }
        }
    }

    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
            DispatchQueue.main.async { self.isSessionRunning = false }
        }
    }

    // MARK: - Camera switching

    func switchCamera() {
        sessionQueue.async { [weak self] in
            guard let self, let currentInput = self.currentInput else { return }

            self.session.beginConfiguration()
            self.session.removeInput(currentInput)

            self.currentPosition = self.currentPosition == .back ? .front : .back

            guard let newDevice = self.getCamera(for: self.currentPosition) else {
                self.session.addInput(currentInput)
                self.session.commitConfiguration()
                return
            }

            do {
                let newInput = try AVCaptureDeviceInput(device: newDevice)
                if self.session.canAddInput(newInput) {
                    self.session.addInput(newInput)
                    self.currentInput = newInput
                } else {
                    self.session.addInput(currentInput)
                    self.currentInput = currentInput
                }
            } catch {
                print("DEBUG: Failed to switch camera: \(error.localizedDescription)")
                self.session.addInput(currentInput)
                self.currentInput = currentInput
            }

            self.session.commitConfiguration()
        }
    }

    // MARK: - Capture
    func capturePhoto() {
        sessionQueue.async { [weak self] in
            guard let self else { return }

            // Use JPEG when available, fall back to the default format otherwise
            let settings: AVCapturePhotoSettings
            if self.photoOutput.availablePhotoCodecTypes.contains(.jpeg) {
                settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            } else {
                settings = AVCapturePhotoSettings()
            }
            settings.flashMode = .off
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    // MARK: - Helpers

    private func getCamera(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error {
            print("DEBUG: Error capturing photo: \(error.localizedDescription)")
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("DEBUG: Failed to get image data from captured photo")
            return
        }

        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}
