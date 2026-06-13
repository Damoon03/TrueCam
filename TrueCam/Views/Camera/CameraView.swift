//
//  CameraView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/21/1405 AP.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var camera = CameraManager()
    @Environment(\.dismiss) private var dismiss

    @State private var isSwitchingCamera = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let image = camera.capturedImage {
                CapturedPhotoPreview(
                    image: image,
                    onRetake: { camera.capturedImage = nil },
                    onUsePhoto: {
                        print("DEBUG: Use photo tapped — \(image)")
                    }
                )
                .transition(.opacity)
            } else {
                CameraPreview(session: camera.session)
                    .ignoresSafeArea()

                overlayUI
            }
        }
        .animation(.easeInOut(duration: 0.25), value: camera.capturedImage)
        .onAppear { camera.startSession() }
        .onDisappear { camera.stopSession() }
        .alert("Camera Access Needed", isPresented: $camera.permissionDenied) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please allow camera access in Settings to use TrueCam.")
        }
    }

    // MARK: - Overlay

    private var overlayUI: some View {
        VStack {
            topBar
            Spacer()
            bottomBar
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 32)
    }

    private var topBar: some View {
        HStack {
            Spacer()
            
            Text("TrueCam.")
                .foregroundStyle(.white)
                .font(.system(size: 22))
                .font(.caption.bold())
                .kerning(2)
            
            Spacer()
        }
        .padding(.top, 8)
    }

    private var bottomBar: some View {
        VStack(spacing: 24) {
            Text("Capture your moment")
                .foregroundStyle(.white.opacity(0.85))
                .font(.footnote.weight(.medium))

            HStack {
                Color.clear
                    .frame(width: 52, height: 52)

                Spacer()

                Button {
                    camera.capturePhoto()
                } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.9), lineWidth: 5)
                            .frame(width: 84, height: 84)
                        Circle()
                            .fill(.white)
                            .frame(width: 68, height: 68)
                    }
                }

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSwitchingCamera = true
                    }
                    camera.switchCamera()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isSwitchingCamera = false
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 52, height: 52)
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                            .rotationEffect(.degrees(isSwitchingCamera ? 180 : 0))
                    }
                }
            }
        }
    }
}


#Preview {
    CameraView()
}
