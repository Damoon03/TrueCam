//
//  ImageUploader.swift
//  TrueCam
//
//  Created by Damoon saber on 3/19/1405 AP.
//

import UIKit
import FirebaseStorage

struct ImageUploader {
    
    static func uploadImage(_ image: UIImage, uid: String) async throws -> String {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let ref = Storage.storage()
            .reference()
            .child("profile_images")
            .child("\(uid).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = try await ref.putDataAsync(imageData, metadata: metadata)
        
        let url = try await ref.downloadURL()
        
        return url.absoluteString
    }
}
