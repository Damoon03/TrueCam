//
//  CommentsView.swift
//  TrueCam
//

import SwiftUI

struct CommentsView: View {
    let post: Post
    @EnvironmentObject var authVM: AuthenticationViewModel
    @StateObject private var vm = CommentsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                ZStack {
                    Text("Comments")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)

                Divider().background(.white.opacity(0.1))

                // Comments list
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        if vm.isLoading {
                            ProgressView().tint(.white).frame(maxWidth: .infinity)
                        } else if vm.comments.isEmpty {
                            Text("No comments yet. Be the first!")
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                        } else {
                            ForEach(vm.comments) { comment in
                                HStack(alignment: .top, spacing: 10) {
                                    if let url = comment.ownerProfileImageUrl.flatMap({ URL(string: $0) }) {
                                        AsyncImage(url: url) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            Circle().foregroundStyle(.gray.opacity(0.2))
                                        }
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .frame(width: 32, height: 32)
                                            .foregroundStyle(.gray.opacity(0.2))
                                            .overlay(
                                                Text(comment.ownerName.prefix(1).uppercased())
                                                    .foregroundStyle(.white)
                                                    .font(.system(size: 13, weight: .semibold))
                                            )
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(comment.ownerName)
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 14))
                                        Text(comment.text)
                                            .foregroundStyle(.white.opacity(0.85))
                                            .font(.system(size: 14))
                                        Text(comment.timestamp.timeAgoDisplay())
                                            .foregroundStyle(.gray)
                                            .font(.caption)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 12)
                }

                Divider().background(.white.opacity(0.1))

                // Input bar
                HStack(spacing: 10) {
                    TextField("Add a comment...", text: $vm.newComment)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)

                    Button {
                        if let user = authVM.currentUser {
                            Task { await vm.postComment(postID: post.id ?? "", owner: user) }
                        }
                    } label: {
                        Image(systemName: vm.isPosting ? "hourglass" : "paperplane.fill")
                            .foregroundStyle(.white)
                    }
                    .disabled(vm.newComment.isEmpty || vm.isPosting)
                }
                .padding()
            }
        }
        .task { await vm.fetchComments(postID: post.id ?? "") }
    }
}
