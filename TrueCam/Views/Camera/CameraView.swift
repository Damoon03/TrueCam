//
//  CameraView.swift
//  TrueCam
//

import SwiftUI
internal import AVFoundation

struct CameraView: View {
    @StateObject private var frontCamera = CameraManager(position: .front)
    @StateObject private var backCamera  = CameraManager(position: .back)
    @EnvironmentObject var authVM: AuthenticationViewModel

    @State private var frontImage: UIImage?
    @State private var backImage: UIImage?
    @State private var isSwitchingCamera = false
    @State private var showPostSheet = false
    @State private var isCapturing = false
    @Environment(\.dismiss) private var dismiss

    // Which camera is "active" for the big preview
    @State private var showingFront = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let front = frontImage, let back = backImage {
                // Both captured — show post preview
                PostPreviewView(
                    frontImage: front,
                    backImage: back,
                    currentUser: authVM.currentUser,
                    onRetake: {
                        frontImage = nil
                        backImage  = nil
                    },
                    onPosted: {
                        frontImage = nil
                        backImage  = nil
                        dismiss()
                    }
                )
                .transition(.opacity)
            } else {
                CameraPreview(session: showingFront ? frontCamera.session : backCamera.session)
                    .ignoresSafeArea()

                overlayUI
            }
        }
        .animation(.easeInOut(duration: 0.25), value: frontImage)
        .onAppear {
            backCamera.startSession()
            frontCamera.startSession()
        }
        .onDisappear {
            backCamera.stopSession()
            frontCamera.stopSession()
        }
        .onChange(of: backCamera.capturedImage) { _, image in
            if let image { backImage = image }
        }
        .onChange(of: frontCamera.capturedImage) { _, image in
            if let image { frontImage = image }
        }
        .alert("Camera Access Needed", isPresented: $backCamera.permissionDenied) {
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

    // MARK: - Capture both cameras simultaneously

    private func captureBoth() {
        guard !isCapturing else { return }
        isCapturing = true
        backCamera.capturePhoto()
        frontCamera.capturePhoto()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isCapturing = false
        }
    }

    // MARK: - Overlay UI

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
                Color.clear.frame(width: 52, height: 52)

                Spacer()

                Button { captureBoth() } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.9), lineWidth: 5)
                            .frame(width: 84, height: 84)
                        Circle()
                            .fill(isCapturing ? Color.gray : Color.white)
                            .frame(width: 68, height: 68)
                    }
                }
                .disabled(isCapturing)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.3)) { isSwitchingCamera = true }
                    showingFront.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { isSwitchingCamera = false }
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
