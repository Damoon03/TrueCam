//
//  FeedViewModel.swift
//  TrueCam
//

import SwiftUI
import Combine

@MainActor
final class FeedViewModel: ObservableObject {

    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var error: String?

    func fetchFeed(currentUser: User) async {
        guard let uid = currentUser.id else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            posts = try await PostService.fetchFeedPosts(friendUIDs: currentUser.friendUIDs, currentUID: uid)
        } catch {
            self.error = error.localizedDescription
        }
    }

    func toggleLike(post: Post, currentUID: String) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        let isLiked = post.likes.contains(currentUID)
        // Optimistic update
        if isLiked {
            posts[index].likes.removeAll { $0 == currentUID }
        } else {
            posts[index].likes.append(currentUID)
        }
        do {
            if isLiked {
                try await PostService.unlikePost(post, uid: currentUID)
            } else {
                try await PostService.likePost(post, uid: currentUID)
            }
        } catch {
            // Revert on failure
            if isLiked {
                posts[index].likes.append(currentUID)
            } else {
                posts[index].likes.removeAll { $0 == currentUID }
            }
        }
    }
}
