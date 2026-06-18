//
//  MemoriesView.swift
//  TrueCam
//

import SwiftUI

struct MemoriesView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject private var profileVM = ProfileViewModel()
    @State private var showDeleteConfirm = false

    private let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]

    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    ZStack {
                        Text("Memories")
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

                            Image(systemName: "questionmark.circle")
                                .foregroundStyle(.white)
                                .font(.system(size: 18))
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }

                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Your memories are activated")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .padding(.leading)
                            Spacer()
                        }

                        Text("All your TrueCam are automatically added to your memories and only visible by you")
                            .foregroundStyle(.white)
                            .padding(.top, 5)
                            .padding(.horizontal)

                        // MARK: - Memories Grid
                        if profileVM.isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                        } else if profileVM.posts.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white.opacity(0.2))
                                Text("No memories yet")
                                    .foregroundStyle(.white.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        } else {
                            LazyVGrid(columns: columns, spacing: 4) {
                                ForEach(profileVM.posts) { post in
                                    AsyncImage(url: URL(string: post.backImageUrl)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Rectangle().foregroundStyle(.white.opacity(0.05))
                                    }
                                    .frame(height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 16)
                        }

                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(height: 210)
                                .foregroundStyle(Color(red: 22/255, green: 4/255, blue: 3/255))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.red, lineWidth: 1)
                                )

                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Deactivate and Delete Memories")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)

                                    Spacer()
                                }

                                VStack {
                                    HStack {
                                        Text("If you deactivate your memories, all your TrueCam will be deleted and unrecoverable")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 14))

                                        Spacer()
                                    }

                                    HStack {
                                        Text("All your future TrueCam wont be saved in Memories and will be automatically deleted as well")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 14))

                                        Spacer()
                                    }
                                }
                                .padding(.top, 4)

                                Button {
                                    showDeleteConfirm = true
                                } label: {
                                    RoundedRectangle(cornerRadius: 12)
                                        .containerRelativeFrame(.horizontal) { width, _ in
                                            width * 0.5
                                        }
                                        .frame(height: 40)
                                        .foregroundStyle(Color(red: 44/255, green: 44/255, blue: 46/255))
                                        .overlay(
                                            Text("Deactivate Memories")
                                                .foregroundStyle(.red)
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                        )
                                }
                                .padding(.top, 8)
                            }
                            .padding(.leading)
                        }
                        .padding(.top, 22)
                        .padding(.horizontal)
                    }
                    .padding(.top, 50)
                }
            }
        }
        .alert("Delete all memories?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete All", role: .destructive) {
                Task { await deleteAllMemories() }
            }
        } message: {
            Text("This will permanently delete all your TrueCam posts. This cannot be undone.")
        }
        .task {
            if let uid = viewModel.currentUser?.id {
                await profileVM.fetchPosts(uid: uid)
            }
        }
    }

    private func deleteAllMemories() async {
        for post in profileVM.posts {
            try? await PostService.deletePost(post)
        }
        if let uid = viewModel.currentUser?.id {
            await profileVM.fetchPosts(uid: uid)
        }
    }
}

#Preview {
    MemoriesView()
        .environmentObject(AuthenticationViewModel())
}
