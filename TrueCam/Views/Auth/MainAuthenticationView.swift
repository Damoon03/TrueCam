//
//  MainAuthenticationView.swift
//  TrueCam
//

import SwiftUI

struct MainAuthenticationView: View {
    @EnvironmentObject var vm: AuthenticationViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                switch vm.step {
                case .name:
                    EnterNameView(name: $vm.name) {
                        vm.confirmName()
                    }

                case .age:
                    EnterAgeView(birthDate: $vm.birthDate) {
                        vm.confirmAge()
                    }

                case .phone:
                    EnterPhoneNumberView(vm: vm) {
                        Task {
                            await vm.confirmPhone()
                        }
                    }

                case .code:
                    EnterCodeView(code: $vm.code, onConfirm: {
                        Task { await vm.confirmCode() }
                    }, phoneDisplay: vm.phone)


                case .done:
                    ProgressView("Finishing...")
                        .tint(.white)
                        .foregroundStyle(.white)
                }
            }
        }
        .alert("Error", isPresented: .constant(vm.authError != nil)) {
            Button("OK") { vm.authError = nil }
        } message: {
            Text(vm.authError ?? "")
        }
    }
}
