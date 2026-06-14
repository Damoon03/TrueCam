//
//  Comment.swift
//  TrueCam
//

import FirebaseFirestore
import Foundation

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?

    let ownerUID: String
    let ownerName: String
    var ownerProfileImageUrl: String?

    let text: String
    let timestamp: Date
}
