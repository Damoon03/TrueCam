//
//  PostService.swift
//  TrueCam
//

import FirebaseFirestore
import UIKit

struct PostService {

    private static let db = Firestore.firestore()

    // MARK: - Upload a BeReal-style dual photo post

    static func uploadPost(
        frontImage: UIImage,
        backImage: UIImage,
        caption: String?,
        location: String?,
        owner: User
    ) async throws {
        guard let uid = owner.id else { return }

        let postID = UUID().uuidString

        async let frontUrl = ImageUploader.uploadPostImage(frontImage, uid: uid, postID: postID, type: "front")
        async let backUrl  = ImageUploader.uploadPostImage(backImage,  uid: uid, postID: postID, type: "back")

        let (front, back) = try await (frontUrl, backUrl)

        let post = Post(
            id: postID,
            ownerUID: uid,
            ownerName: owner.name,
            ownerProfileImageUrl: owner.profileImageUrl,
            frontImageUrl: front,
            backImageUrl: back,
            caption: caption,
            location: location,
            timestamp: Date(),
            likes: [],
            commentCount: 0
        )

        let data = try Firestore.Encoder().encode(post)
        try await db.collection("posts").document(postID).setData(data)
    }

    // MARK: - Fetch feed posts (friends + own)

    static func fetchFeedPosts(friendUIDs: [String], currentUID: String) async throws -> [Post] {
        var uids = friendUIDs
        uids.append(currentUID)

        // Firestore whereField in supports max 30 values
        let chunks = stride(from: 0, to: uids.count, by: 30).map {
            Array(uids[$0..<min($0 + 30, uids.count)])
        }

        var posts: [Post] = []
        for chunk in chunks {
            let snapshot = try await db.collection("posts")
                .whereField("ownerUID", in: chunk)
                .order(by: "timestamp", descending: true)
                .limit(to: 20)
                .getDocuments()

            let batch = snapshot.documents.compactMap { try? $0.data(as: Post.self) }
            posts.append(contentsOf: batch)
        }

        return posts.sorted { $0.timestamp > $1.timestamp }
    }

    // MARK: - Like / Unlike

    static func likePost(_ post: Post, uid: String) async throws {
        guard let postID = post.id else { return }
        try await db.collection("posts").document(postID).updateData([
            "likes": FieldValue.arrayUnion([uid])
        ])
    }

    static func unlikePost(_ post: Post, uid: String) async throws {
        guard let postID = post.id else { return }
        try await db.collection("posts").document(postID).updateData([
            "likes": FieldValue.arrayRemove([uid])
        ])
    }

    // MARK: - Comments

    static func fetchComments(postID: String) async throws -> [Comment] {
        let snapshot = try await db.collection("posts")
            .document(postID)
            .collection("comments")
            .order(by: "timestamp", descending: false)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Comment.self) }
    }

    static func addComment(postID: String, text: String, owner: User) async throws {
        guard let uid = owner.id else { return }
        let comment = Comment(
            ownerUID: uid,
            ownerName: owner.name,
            ownerProfileImageUrl: owner.profileImageUrl,
            text: text,
            timestamp: Date()
        )
        let data = try Firestore.Encoder().encode(comment)
        try await db.collection("posts").document(postID).collection("comments").addDocument(data: data)
        try await db.collection("posts").document(postID).updateData([
            "commentCount": FieldValue.increment(Int64(1))
        ])
    }

    // MARK: - Fetch user posts (for profile/memories)

    static func fetchUserPosts(uid: String) async throws -> [Post] {
        let snapshot = try await db.collection("posts")
            .whereField("ownerUID", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Post.self) }
    }

    // MARK: - Delete post

    static func deletePost(_ post: Post) async throws {
        guard let postID = post.id else { return }
        try await db.collection("posts").document(postID).delete()
    }
}
