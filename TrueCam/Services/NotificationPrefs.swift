//
//  NotificationPrefs.swift
//  TrueCam
//

import FirebaseFirestore

struct NotificationPrefs: Codable {
    var mentions: Bool = false
    var comments: Bool = false
    var friendRequests: Bool = false
    var lateTrueCam: Bool = false
    var realMojis: Bool = false
}

/// Stores notification preferences under users/{uid}/settings/notifications
struct Firestore_NotificationPrefs {

    private static func docRef(uid: String) -> DocumentReference {
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("settings")
            .document("notifications")
    }

    static func fetch(uid: String) async throws -> NotificationPrefs {
        let snapshot = try await docRef(uid: uid).getDocument()
        guard snapshot.exists else { return NotificationPrefs() }
        return try snapshot.data(as: NotificationPrefs.self)
    }

    static func save(uid: String, prefs: NotificationPrefs) async throws {
        let data = try Firestore.Encoder().encode(prefs)
        try await docRef(uid: uid).setData(data, merge: true)
    }
}

/// Stores selected timezone region under users/{uid}/settings/general
struct Firestore_TimeZonePrefs {

    private static func docRef(uid: String) -> DocumentReference {
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("settings")
            .document("general")
    }

    static func fetch(uid: String) async throws -> String {
        let snapshot = try await docRef(uid: uid).getDocument()
        return snapshot.data()?["timeZoneArea"] as? String ?? "europe"
    }

    static func save(uid: String, area: String) async throws {
        try await docRef(uid: uid).setData(["timeZoneArea": area], merge: true)
    }
}
