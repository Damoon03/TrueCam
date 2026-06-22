//
//  User.swift
//  TrueCam
//

import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?

    var name: String
    var phone: String
    var date: Date

    var username: String?
    var profileImageUrl: String?
    var bio: String?
    var location: String?

    var friendUIDs: [String]
    var friendRequestsSent: [String]
    var friendRequestsReceived: [String]

    var friendCount: Int { friendUIDs.count }

    enum CodingKeys: String, CodingKey {
        case id, name, phone, date, username, profileImageUrl, bio, location
        case friendUIDs, friendRequestsSent, friendRequestsReceived
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        phone = try c.decode(String.self, forKey: .phone)
        date = try c.decode(Date.self, forKey: .date)
        username = try c.decodeIfPresent(String.self, forKey: .username)
        profileImageUrl = try c.decodeIfPresent(String.self, forKey: .profileImageUrl)
        bio = try c.decodeIfPresent(String.self, forKey: .bio)
        location = try c.decodeIfPresent(String.self, forKey: .location)
        friendUIDs = (try? c.decodeIfPresent([String].self, forKey: .friendUIDs)) ?? []
        friendRequestsSent = (try? c.decodeIfPresent([String].self, forKey: .friendRequestsSent)) ?? []
        friendRequestsReceived = (try? c.decodeIfPresent([String].self, forKey: .friendRequestsReceived)) ?? []
    }
}
