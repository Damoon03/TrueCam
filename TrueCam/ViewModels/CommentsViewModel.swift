//
//  CommentsViewModel.swift
//  TrueCam
//

import SwiftUI
import Combine

@MainActor
final class CommentsViewModel: ObservableObject {

    @Published var comments: [Comment] = []
    @Published var newComment: String = ""
    @Published var isLoading = false
    @Published var isPosting = false

    func fetchComments(postID: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            comments = try await PostService.fetchComments(postID: postID)
        } catch {
            print("Fetch comments error:", error.localizedDescription)
        }
    }

    func postComment(postID: String, owner: User) async {
        let text = newComment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        isPosting = true
        defer { isPosting = false }
        do {
            try await PostService.addComment(postID: postID, text: text, owner: owner)
            newComment = ""
            await fetchComments(postID: postID)
        } catch {
            print("Post comment error:", error.localizedDescription)
        }
    }
}
