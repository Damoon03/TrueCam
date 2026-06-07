//
//  AuthenticationViewModel.swift
//  TrueCam
//
//  Created by Damoon saber on 3/9/1405 AP.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

enum AuthStep {
    case name
    case age
    case phone
    case code
    case done
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
        if let authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }

    // MARK: - Auth Listener

    private func setupAuthListener() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }

            self.userSession = user

            if user != nil {
                Task {
                    await self.fetchUser()
                }
            }
        }
    }

    // MARK: - Validation

    var canConfirmName: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var canConfirmAge: Bool {
        guard let birthDate else { return false }
        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        return age >= 18
    }

    var canConfirmPhone: Bool {
        let trimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= 10
    }

    var canConfirmCode: Bool {
        code.count == 6
    }

    // MARK: - Flow

    func confirmName() {
        guard canConfirmName else { return }

        withAnimation(.snappy) {
            step = .age
        }
    }

    func confirmAge() {
        guard canConfirmAge else { return }

        withAnimation(.snappy) {
            step = .phone
        }
    }

    func confirmPhone() async {
        await sendOTP()
    }

    func confirmCode() async {

        guard let verificationID else { return }
        guard canConfirmCode else { return }

        do {

            let credential = PhoneAuthProvider.provider()
                .credential(
                    withVerificationID: verificationID,
                    verificationCode: code
                )

            let result = try await Auth.auth().signIn(with: credential)

            self.userSession = result.user

            await createUser()

            withAnimation(.snappy) {
                step = .done
            }

        } catch {
            authError = error.localizedDescription
        }
    }

    // MARK: - Phone Formatting

    var e164Phone: String {
        var clean = phone.filter(\.isNumber)

        if clean.hasPrefix("0") {
            clean.removeFirst()
        }

        return "+\(countryCode)\(clean)"
    }

    // MARK: - OTP

    func sendOTP() async {

        guard !isSendingOTP else { return }
        guard canConfirmPhone else { return }

        isSendingOTP = true
        defer { isSendingOTP = false }

        do {

            let verificationID = try await PhoneAuthProvider
                .provider()
                .verifyPhoneNumber(e164Phone, uiDelegate: nil)

            self.verificationID = verificationID

            withAnimation(.snappy) {
                step = .code
            }

        } catch {
            authError = error.localizedDescription
        }
    }

    // MARK: - Firestore

    func createUser() async {

        guard let uid = userSession?.uid else { return }

        let db = Firestore.firestore()

        let userData: [String: Any] = [
            "id": uid,
            "name": name,
            "phone": e164Phone,
            "date": birthDate ?? Date()
        ]

        do {
            try await db.collection("users")
                .document(uid)
                .setData(userData)
        } catch {
            print("Create user error:", error.localizedDescription)
        }
    }

    func fetchUser() async {

        guard let uid = userSession?.uid else { return }

        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument()

            self.currentUser = try snapshot.data(as: User.self)

        } catch {
            print("Fetch user error:", error.localizedDescription)
        }
    }
}
