//
//  FeedView.swift
//  TrueCam
//

import SwiftUI
import FirebaseAuth

struct FeedView: View {
    @Binding var selection: Int
    @EnvironmentObject var authVM: AuthenticationViewModel
    @StateObject private var feedVM = FeedViewModel()
    @State private var selectedPost: Post?
    @State private var showComments = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ZStack {
                if feedVM.isLoading {
                    ProgressView()
                        .tint(.white)
                } else if feedVM.posts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.3))
                        Text("No posts yet")
                            .foregroundStyle(.white.opacity(0.4))
                        Text("Add friends to see their TrueCams")
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(feedVM.posts) { post in
                                FeedCell(
                                    post: post,
                                    currentUID: authVM.userSession?.uid ?? "",
                                    onLike: {
                                        Task {
                                            await feedVM.toggleLike(
                                                post: post,
                                                currentUID: authVM.userSession?.uid ?? ""
                                            )
                                        }
                                    },
                                    onComment: {
                                        selectedPost = post
                                        showComments = true
                                    }
                                )
                            }
                        }
                        .padding(.top, 80)
                    }
                }

                // MARK: - Top bar
                VStack {
                    VStack {
                        HStack {
                            Button {
                                withAnimation(.spring()) { selection = 0 }
                            } label: {
                                Image(systemName: "person.2.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }

                            Spacer()

                            Text("TrueCam.")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                                .kerning(2)

                            Spacer()

                            Button {
                                withAnimation(.spring()) { selection = 2 }
                            } label: {
                                if let url = authVM.currentUser?.profileImageUrl.flatMap({ URL(string: $0) }) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Circle().foregroundStyle(.gray.opacity(0.1))
                                    }
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                } else {
                                    Circle()
                                        .frame(width: 35, height: 35)
                                        .foregroundStyle(.gray.opacity(0.1))
                                        .overlay(
                                            Text(authVM.currentUser?.name.prefix(1).uppercased() ?? "")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14, weight: .semibold))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)

                        HStack {
                            Text("My Friends")
                                .foregroundStyle(.white)
                            Text("Discovery")
                                .foregroundStyle(.gray)
                        }
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showComments) {
            if let post = selectedPost {
                CommentsView(post: post)
                    .environmentObject(authVM)
            }
        }
        .task {
            if let user = authVM.currentUser {
                await feedVM.fetchFeed(currentUser: user)
            }
        }
        .onChange(of: authVM.currentUser?.id) { _, _ in
            if let user = authVM.currentUser {
                Task { await feedVM.fetchFeed(currentUser: user) }
            }
        }
    }
}
