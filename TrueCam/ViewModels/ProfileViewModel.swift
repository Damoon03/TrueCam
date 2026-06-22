//
//  ProfileViewModel.swift
//  TrueCam
//

import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var error: String?

    func fetchPosts(uid: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            posts = try await PostService.fetchUserPosts(uid: uid)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
