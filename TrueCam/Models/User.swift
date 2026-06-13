//
//  User.swift
//  TrueCam
//
//  Created by Damoon saber on 3/16/1405 AP.
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
}
