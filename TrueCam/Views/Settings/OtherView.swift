//
//  OtherView.swift
//  TrueCam
//

import SwiftUI
import FirebaseAuth

struct OtherView: View {

    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var fastCamera = false
    @State private var showDeleteConfirm = false
    @State private var showClearCacheConfirm = false
    @State private var cacheCleared = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {

                    ZStack {
                        Text("Other")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)

                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }

                            Spacer()

                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }

                VStack {
                    VStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))

                            HStack {
                                Image(systemName: "camera.viewfinder")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))

                                Text("Fast Camera (reduce quality)")
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .font(.system(size: 14))
                                Spacer()

                                Toggle("", isOn: $fastCamera)
                                    .frame(width: 60)
                            }
                            .padding(.horizontal)
                        }

                        Button {
                            showClearCacheConfirm = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 45)
                                    .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))

                                HStack {
                                    Image(systemName: "xmark.app")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 18))

                                    Text(cacheCleared ? "Cache cleared" : "Clear cache")
                                        .foregroundStyle(.white)
                                        .fontWeight(.medium)
                                        .font(.system(size: 14))
                                    Spacer()

                                    if cacheCleared {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.green)
                                            .padding(.trailing, 20)
                                    } else {
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.white)
                                            .fixedSize()
                                            .padding(.trailing, 20)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        Button {
                            showDeleteConfirm = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 45)
                                    .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))

                                HStack {

                                    Spacer()

                                    Text("Delete Account")
                                        .foregroundStyle(.red)

                                    Spacer()

                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)

                    Spacer()
                }
            }
        }
        .alert("Clear Cache", isPresented: $showClearCacheConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Clear") {
                clearURLCache()
            }
        } message: {
            Text("This will clear cached images and data. Your TrueCam content stays safe.")
        }
        .alert("Delete Account", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task { await deleteAccount() }
            }
        } message: {
            Text("This will permanently delete your account and all your TrueCam content. This cannot be undone.")
        }
    }

    private func clearURLCache() {
        URLCache.shared.removeAllCachedResponses()
        withAnimation { cacheCleared = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { cacheCleared = false }
        }
    }

    private func deleteAccount() async {
        guard let uid = viewModel.userSession?.uid else { return }
        do {
            // Delete all of the user's posts first
            let posts = try await PostService.fetchUserPosts(uid: uid)
            for post in posts {
                try? await PostService.deletePost(post)
            }
            try await UserService.deleteAccount(uid: uid)
            viewModel.signOut()
        } catch {
            print("Delete account error:", error.localizedDescription)
        }
    }
}

#Preview {
    OtherView()
        .environmentObject(AuthenticationViewModel())
}
