//
//  EnterPhoneNumberView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/7/1405 AP.
//
import SwiftUI

struct EnterPhoneNumberView: View {

    @State private var country = Country(phoneCode: "98", isoCode: "IR")
    @State private var showCountryList = false
    @FocusState private var isFocused: Bool
    
    @ObservedObject var vm: AuthenticationViewModel
    let onConfirm: () -> Void

    var body: some View {

        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Text("TrueCam.")
                    .foregroundStyle(.white)
                    .font(.system(size: 22))
                    .font(.caption.bold())
                    .kerning(2)
                Spacer()
            }

            VStack(spacing: 24) {
                Text("Insert your phone number")
                    .foregroundStyle(.white)
                    .fontWeight(.heavy)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                VStack(spacing: 15) {
                    HStack(spacing: 10) {
                        Button {
                            showCountryList.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                Text(country.flag)
                                Text("+\(country.phoneCode)")
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 85, height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }

                        TextField(
                            "",
                            text: $vm.phone,
                            prompt: Text("Your number")
                                .foregroundStyle(.white.opacity(0.2))
                        )
                        .focused($isFocused)
                        .keyboardType(.phonePad)
                        .onChange(of: vm.phone) { _, newValue in
                            let filtered = newValue.filter(\.isNumber)
                            if filtered != newValue {
                                vm.phone = filtered
                            }
                        }
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .frame(height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            isFocused ? Color.white : Color.white.opacity(0.15),
                                            lineWidth: 1
                                        )
                                )
                        )
                        .animation(.snappy, value: isFocused)
                    }
                    .padding(.horizontal, 30)

                    Text("""
                    By tapping "CONFIRM", you agree to our Privacy and Policy and
                    Terms of Service.
                    """)
                        .foregroundStyle(.gray)
                        .font(.caption)
                        .multilineTextAlignment(.center)

                    Button {
                        print("Confirming: \(vm.e164Phone)")
                        onConfirm()
                    } label: {
                        if vm.isSendingOTP {
                            ProgressView()
                        } else {
                            Text("CONFIRM")
                                .font(.caption.bold())
                                .kerning(2)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 30)
                                .background(
                                    vm.canConfirmPhone
                                    ? Color.white
                                    : Color.white.opacity(0.3)
                                )
                                .foregroundStyle(.black)
                                .cornerRadius(5)
                        }
                    }
                    .disabled(!vm.canConfirmPhone || vm.isSendingOTP)
                    .padding(.horizontal, 30)
                    .animation(.snappy, value: vm.canConfirmPhone)
                }
            }
            .onAppear {
                vm.countryCode = country.phoneCode
            }
            .offset(y: -50)
        }
        .sheet(isPresented: $showCountryList) {
            NavigationStack {
                CountryPickerView(store: CountriesStore()) { selected in
                    country = selected
                    vm.countryCode = selected.phoneCode
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}



//#Preview {
//    EnterPhoneNumberView(vm: <#AuthenticationViewModel#>, number: .constant(""), onConfirm: {})
//}
