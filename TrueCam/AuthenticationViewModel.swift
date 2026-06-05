//
//  AuthenticationViewModel.swift
//  TrueCam
//
//  Created by Damoon saber on 3/9/1405 AP.
//

import SwiftUI
import Combine
import FirebaseAuth

enum AuthStep {
    case name
    case age
    case phone
    case code
    case done
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    @Published var step: AuthStep = .name

    @Published var name: String = ""
    @Published var birthDate: Date? = nil
    @Published var phone: String = ""
    @Published var code: String = ""

    @Published var isSendingOTP = false
    @Published var verificationID: String?
    
    @Published var authError: String?
    
    @Published var countryCode: String = "98"


    
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

            _ = try await Auth.auth().signIn(with: credential)

            withAnimation(.snappy) {
                step = .done
            }

            isLoggedIn = true

        } catch {
            authError = error.localizedDescription
        }
    }
    
    var e164Phone: String {
        var clean = phone.filter(\.isNumber)
        
        if clean.hasPrefix("0") {
            clean.removeFirst()
        }
        
        return "+\(countryCode)\(clean)"
    }
    
    func sendOTP() async {
        guard !isSendingOTP else { return }
        guard canConfirmPhone else { return }

        isSendingOTP = true
        defer { isSendingOTP = false }

        do {
            let result = try await PhoneAuthProvider
                .provider()
                .verifyPhoneNumber(e164Phone, uiDelegate: nil)

            verificationID = result

            withAnimation(.snappy) {
                step = .code
            }
            
        } catch {
            authError = error.localizedDescription
            
        }
    }
}
