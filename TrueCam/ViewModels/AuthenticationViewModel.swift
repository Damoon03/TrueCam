//
//  AuthenticationViewModel.swift
//  TrueCam
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

enum AuthStep {
    case name, age, phone, code, done
}

@MainActor
final class AuthenticationViewModel: ObservableObject {

    @Published var step: AuthStep = .name
    @Published var name: String = ""
    @Published var birthDate: Date? = nil
    @Published var phone: String = ""
    @Published var code: String = ""
    @Published var isSendingOTP = false
    @Published var verificationID: String?
    @Published var authError: String?
    @Published var countryCode: String = "98"
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    private var authListener: AuthStateDidChangeListenerHandle?

    init() {
        setupAuthListener()
    }

    deinit {
        if let authListener { Auth.auth().removeStateDidChangeListener(authListener) }
    }

    private func setupAuthListener() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            self.userSession = user
            if user != nil { Task { await self.fetchUser() } }
        }
    }

    // MARK: - Validation

    var canConfirmName: Bool { !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var canConfirmAge: Bool {
        guard let birthDate else { return false }
        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        return age >= 18
    }

    var canConfirmPhone: Bool { phone.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10 }
    var canConfirmCode: Bool { code.count == 6 }

    var e164Phone: String {
        var clean = phone.filter(\.isNumber)
        if clean.hasPrefix("0") { clean.removeFirst() }
        return "+\(countryCode)\(clean)"
    }

    // MARK: - Flow

    func confirmName() {
        guard canConfirmName else { return }
        withAnimation(.snappy) { step = .age }
    }

    func confirmAge() {
        guard canConfirmAge else { return }
        withAnimation(.snappy) { step = .phone }
    }

    func confirmPhone() async { await sendOTP() }

    func confirmCode() async {
        guard let verificationID, canConfirmCode else { return }
        do {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
            let result = try await Auth.auth().signIn(with: credential)
            self.userSession = result.user
            await createUser()
            withAnimation(.snappy) { step = .done }
        } catch {
            authError = error.localizedDescription
        }
    }

    // MARK: - OTP

    func sendOTP() async {
        guard !isSendingOTP, canConfirmPhone else { return }
        isSendingOTP = true
        defer { isSendingOTP = false }
        do {
            let id = try await PhoneAuthProvider.provider().verifyPhoneNumber(e164Phone, uiDelegate: nil)
            self.verificationID = id
            withAnimation(.snappy) { step = .code }
        } catch {
            authError = error.localizedDescription
        }
    }

    // MARK: - Firestore

    func createUser() async {
        guard let uid = userSession?.uid else { return }
        let userData: [String: Any] = [
            "id": uid,
            "name": name,
            "phone": e164Phone,
            "date": birthDate ?? Date(),
            "friendUIDs": [],
            "friendRequestsSent": [],
            "friendRequestsReceived": []
        ]
        do {
            try await Firestore.firestore().collection("users").document(uid).setData(userData)
        } catch {
            print("Create user error:", error.localizedDescription)
        }
    }

    func fetchUser() async {
        guard let uid = userSession?.uid else { return }
        do {
            self.currentUser = try await UserService.fetchUser(uid: uid)
        } catch {
            print("Fetch user error:", error.localizedDescription)
        }
    }

    // MARK: - Profile editing

    func updateUserProfile(fullname: String, username: String, bio: String, location: String) async throws {
        guard let uid = userSession?.uid else { return }
        try await UserService.updateProfile(uid: uid, fullname: fullname, username: username, bio: bio, location: location)
        currentUser?.name = fullname
        currentUser?.username = username
        currentUser?.bio = bio
        currentUser?.location = location
    }

    func updateProfileImage(_ image: UIImage) async {
        guard let uid = userSession?.uid else { return }
        do {
            let imageUrl = try await ImageUploader.uploadProfileImage(image, uid: uid)
            try await UserService.updateProfileImageURL(uid: uid, url: imageUrl)
            currentUser?.profileImageUrl = imageUrl
        } catch {
            print("Profile image update error:", error.localizedDescription)
        }
    }

    // MARK: - Sign out

    func signOut() {
        do {
            try Auth.auth().signOut()
            userSession = nil
            currentUser = nil
        } catch {
            print(error.localizedDescription)
        }
    }
}
