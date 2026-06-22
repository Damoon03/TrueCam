//
//  UserService.swift
//  TrueCam
//

import FirebaseFirestore

struct UserService {

    private static let db = Firestore.firestore()

    // MARK: - Fetch single user

    static func fetchUser(uid: String) async throws -> User {
        let snapshot = try await db.collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }

    // MARK: - Search users by name or username

    static func searchUsers(query: String) async throws -> [User] {
        let q = query.lowercased()
        let snapshot = try await db.collection("users").getDocuments()
        return snapshot.documents
            .compactMap { try? $0.data(as: User.self) }
            .filter {
                $0.name.lowercased().contains(q) ||
                ($0.username ?? "").lowercased().contains(q)
            }
    }

    // MARK: - Friend requests

    static func sendFriendRequest(from senderUID: String, to receiverUID: String) async throws {
        // Add to sender's sent list
        try await db.collection("users").document(senderUID).updateData([
            "friendRequestsSent": FieldValue.arrayUnion([receiverUID])
        ])
        // Add to receiver's received list
        try await db.collection("users").document(receiverUID).updateData([
            "friendRequestsReceived": FieldValue.arrayUnion([senderUID])
        ])
    }

    static func cancelFriendRequest(from senderUID: String, to receiverUID: String) async throws {
        try await db.collection("users").document(senderUID).updateData([
            "friendRequestsSent": FieldValue.arrayRemove([receiverUID])
        ])
        try await db.collection("users").document(receiverUID).updateData([
            "friendRequestsReceived": FieldValue.arrayRemove([senderUID])
        ])
    }

    static func acceptFriendRequest(currentUID: String, requesterUID: String) async throws {
        // Add each other as friends
        try await db.collection("users").document(currentUID).updateData([
            "friendUIDs": FieldValue.arrayUnion([requesterUID]),
            "friendRequestsReceived": FieldValue.arrayRemove([requesterUID])
        ])
        try await db.collection("users").document(requesterUID).updateData([
            "friendUIDs": FieldValue.arrayUnion([currentUID]),
            "friendRequestsSent": FieldValue.arrayRemove([currentUID])
        ])
    }

    static func declineFriendRequest(currentUID: String, requesterUID: String) async throws {
        try await db.collection("users").document(currentUID).updateData([
            "friendRequestsReceived": FieldValue.arrayRemove([requesterUID])
        ])
        try await db.collection("users").document(requesterUID).updateData([
            "friendRequestsSent": FieldValue.arrayRemove([currentUID])
        ])
    }

    static func removeFriend(currentUID: String, friendUID: String) async throws {
        try await db.collection("users").document(currentUID).updateData([
            "friendUIDs": FieldValue.arrayRemove([friendUID])
        ])
        try await db.collection("users").document(friendUID).updateData([
            "friendUIDs": FieldValue.arrayRemove([currentUID])
        ])
    }

    // MARK: - Fetch friends

    static func fetchFriends(uids: [String]) async throws -> [User] {
        guard !uids.isEmpty else { return [] }
        var friends: [User] = []
        for uid in uids {
            if let user = try? await fetchUser(uid: uid) {
                friends.append(user)
            }
        }
        return friends
    }

    // MARK: - Fetch friend requests

    static func fetchFriendRequests(uids: [String]) async throws -> [User] {
        try await fetchFriends(uids: uids)
    }

    // MARK: - Update profile

    static func updateProfile(uid: String, fullname: String, username: String, bio: String, location: String) async throws {
        try await db.collection("users").document(uid).updateData([
            "name": fullname,
            "username": username,
            "bio": bio,
            "location": location
        ])
    }

    static func updateProfileImageURL(uid: String, url: String) async throws {
        try await db.collection("users").document(uid).updateData(["profileImageUrl": url])
    }

    // MARK: - Generic preferences update (notifications, timezone, etc.)

    static func updateFields(uid: String, data: [String: Any]) async throws {
        try await db.collection("users").document(uid).updateData(data)
    }

    // MARK: - Delete account

    static func deleteAccount(uid: String) async throws {
        try await db.collection("users").document(uid).delete()
    }
}
