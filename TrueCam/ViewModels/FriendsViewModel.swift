//
//  FriendsViewModel.swift
//  TrueCam
//

import SwiftUI
import Combine

@MainActor
final class FriendsViewModel: ObservableObject {

    @Published var friends: [User] = []
    @Published var friendRequests: [User] = []
    @Published var suggestions: [User] = []
    @Published var searchResults: [User] = []
    @Published var isLoading = false
    @Published var error: String?

    func loadAll(currentUser: User) async {
        guard let uid = currentUser.id else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            async let friendsResult   = UserService.fetchFriends(uids: currentUser.friendUIDs)
            async let requestsResult  = UserService.fetchFriendRequests(uids: currentUser.friendRequestsReceived)
            async let suggestResult   = UserService.searchUsers(query: "")

            let (f, r, s) = try await (friendsResult, requestsResult, suggestResult)
            friends        = f
            friendRequests = r
            // suggestions = all users except self, friends, and pending
            let excluded = Set([uid] + currentUser.friendUIDs + currentUser.friendRequestsSent + currentUser.friendRequestsReceived)
            suggestions = s.filter { !excluded.contains($0.id ?? "") }
        } catch {
            self.error = error.localizedDescription
        }
    }

    func search(query: String, currentUser: User) async {
        guard !query.isEmpty else { searchResults = []; return }
        do {
            let results = try await UserService.searchUsers(query: query)
            searchResults = results.filter { $0.id != currentUser.id }
        } catch {
            self.error = error.localizedDescription
        }
    }

    func sendRequest(to user: User, currentUID: String) async {
        guard let targetUID = user.id else { return }
        do {
            try await UserService.sendFriendRequest(from: currentUID, to: targetUID)
            suggestions.removeAll { $0.id == targetUID }
        } catch {
            self.error = error.localizedDescription
        }
    }

    func acceptRequest(from user: User, currentUID: String) async {
        guard let requesterUID = user.id else { return }
        do {
            try await UserService.acceptFriendRequest(currentUID: currentUID, requesterUID: requesterUID)
            friendRequests.removeAll { $0.id == requesterUID }
            friends.append(user)
        } catch {
            self.error = error.localizedDescription
        }
    }

    func declineRequest(from user: User, currentUID: String) async {
        guard let requesterUID = user.id else { return }
        do {
            try await UserService.declineFriendRequest(currentUID: currentUID, requesterUID: requesterUID)
            friendRequests.removeAll { $0.id == requesterUID }
        } catch {
            self.error = error.localizedDescription
        }
    }

    func removeFriend(_ user: User, currentUID: String) async {
        guard let friendUID = user.id else { return }
        do {
            try await UserService.removeFriend(currentUID: currentUID, friendUID: friendUID)
            friends.removeAll { $0.id == friendUID }
        } catch {
            self.error = error.localizedDescription
        }
    }
}
