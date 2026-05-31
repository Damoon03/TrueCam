//
//  AuthenticationViewModel.swift
//  TrueCam
//
//  Created by Damoon saber on 3/9/1405 AP.
//

import SwiftUI
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
    @AppStorage("isLoggedIn") var isLoggedIn = false

    @Published var step: AuthStep = .name

    @Published var name: String = ""
    @Published var birthDate: Date? = nil
    @Published var phone: String = ""
    @Published var code: String = ""

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

    func confirmPhone() {
        guard canConfirmPhone else { return }
        withAnimation(.snappy) {
            step = .code
        }
    }

    func confirmCode() async {
        guard canConfirmCode else { return }

        try? await Task.sleep(for: .milliseconds(700))

        withAnimation(.snappy) {
            step = .done
        }

        try? await Task.sleep(for: .milliseconds(400))
        isLoggedIn = true
    }
}
