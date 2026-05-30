//
//  MainAuthenticationView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/9/1405 AP.
//
import SwiftUI

struct MainAuthenticationView: View {
    @State private var currentStep: AuthStep = .name
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var number: String = ""
    @State private var Code: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false


    var body: some View {
        NavigationStack {
            switch currentStep {
            case .name:
                EnterNameView(name: $name) {
                    currentStep = .age
                }
            case .age:
                EnterAgeView(age: $age) {
                    currentStep = .phone
                }
                
            case .phone:
                EnterPhoneNumberView(number: $number) {
                    currentStep = .code
                }
                
            case .code:
                EnterCodeView(Code: $Code) {
                    currentStep = .done
                }
                    
            case .done:
                ZStack {
                    Color.black.ignoresSafeArea()
                    ProgressView("Finishing...")
                        .tint(.white)
                        .foregroundStyle(.white)
                }
                .task {
                    // TODO: verify/save user session here
                    isLoggedIn = true
                }
            }
        }
    }
}



enum AuthStep {
    case name
    case age
    case phone
    case code
    case done
}

#Preview {
    MainAuthenticationView()
}
