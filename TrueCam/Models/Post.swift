//
//  Post.swift
//  TrueCam
//

import FirebaseFirestore
import Foundation

struct Post: Codable, Identifiable {
    @DocumentID var id: String?

    let ownerUID: String
    let ownerName: String
    var ownerProfileImageUrl: String?

    let frontImageUrl: String
    let backImageUrl: String

    var caption: String?
    var location: String?

    let timestamp: Date

    var likes: [String]       // array of UIDs who liked
    var commentCount: Int

    var likeCount: Int { likes.count }
}
