//
//  PostPreviewView.swift
//  TrueCam
//

import SwiftUI

struct PostPreviewView: View {
    let frontImage: UIImage
    let backImage: UIImage
    let currentUser: User?
    let onRetake: () -> Void
    let onPosted: () -> Void

    @State private var caption: String = ""
    @State private var location: String = ""
    @State private var isPosting = false
    @State private var postError: String?
    @FocusState private var captionFocused: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    // MARK: - Dual photo preview
                    ZStack(alignment: .topLeading) {
                        Image(uiImage: backImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)

                        Image(uiImage: frontImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 130)
                            .cornerRadius(8)
                            .border(.black, width: 2)
                            .padding(12)
                    }

                    // MARK: - Caption
                    TextField("Add a caption...", text: $caption, axis: .vertical)
                        .foregroundStyle(.white)
                        .focused($captionFocused)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)

                    // MARK: - Location
                    HStack {
                        Image(systemName: "location")
                            .foregroundStyle(.gray)
                        TextField("Add location...", text: $location)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    if let error = postError {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }

                    // MARK: - Buttons
                    HStack(spacing: 16) {
                        Button(action: onRetake) {
                            Text("Retake")
                                .font(.caption.bold())
                                .kerning(2)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color.white.opacity(0.1))
                                .foregroundStyle(.white)
                                .cornerRadius(5)
                        }

                        Button {
                            Task { await postNow() }
                        } label: {
                            if isPosting {
                                ProgressView().tint(.black)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(Color.white)
                                    .cornerRadius(5)
                            } else {
                                Text("POST")
                                    .font(.caption.bold())
                                    .kerning(2)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(Color.white)
                                    .foregroundStyle(.black)
                                    .cornerRadius(5)
                            }
                        }
                        .disabled(isPosting)
                    }
                }
                .padding(.top, 20)
            }
        }
    }

    private func postNow() async {
        guard let user = currentUser else { return }
        isPosting = true
        defer { isPosting = false }
        do {
            try await PostService.uploadPost(
                frontImage: frontImage,
                backImage: backImage,
                caption: caption.isEmpty ? nil : caption,
                location: location.isEmpty ? nil : location,
                owner: user
            )
            onPosted()
        } catch {
            postError = error.localizedDescription
        }
    }
}
