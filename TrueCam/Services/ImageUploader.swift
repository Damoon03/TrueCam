//
//  ImageUploader.swift
//  TrueCam
//

import UIKit
import FirebaseStorage

struct ImageUploader {

    static func uploadImage(_ image: UIImage, path: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw URLError(.cannotDecodeContentData)
        }

        let ref = Storage.storage().reference().child(path)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await ref.putDataAsync(imageData, metadata: metadata)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }

    static func uploadProfileImage(_ image: UIImage, uid: String) async throws -> String {
        try await uploadImage(image, path: "profile_images/\(uid).jpg")
    }

    static func uploadPostImage(_ image: UIImage, uid: String, postID: String, type: String) async throws -> String {
        try await uploadImage(image, path: "posts/\(uid)/\(postID)_\(type).jpg")
    }
}
