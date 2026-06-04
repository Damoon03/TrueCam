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
    @StateObject var vm: AuthenticationViewModel

    @Binding var number: String
    let onConfirm: () -> Void

    private var digitsOnlyNumber: String {
        number.filter { "0123456789".contains($0) }
    }

    private var fullE164Like: String {
        "+\(country.phoneCode)\(digitsOnlyNumber)"
    }

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
                            text: $number,
                            prompt: Text("Your number").foregroundStyle(.white.opacity(0.2))
                        )
                        .focused($isFocused)
                        .keyboardType(.phonePad)
                        .onChange(of: number) { _, newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                number = filtered
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
                                        .stroke(isFocused ? Color.white : Color.white.opacity(0.15), lineWidth: 1)
                                )
                        )
                        .animation(.snappy, value: isFocused)
                    }
                    .padding(.horizontal, 30)

                    Text("By tapping \"CONFIRM\", you agree to our Privacy and Policy and \n Terms of Service.")
                        .foregroundStyle(.gray)
                        .font(.caption)
                        .multilineTextAlignment(.center)

                    if !digitsOnlyNumber.isEmpty {
                        Button {
                            print("Confirming: \(fullE164Like)")
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
                                    .background(Color.white)
                                    .foregroundStyle(.black)
                                    .cornerRadius(5)
                            }
                        }
                        .disabled(vm.isSendingOTP)
                        .padding(.horizontal, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .offset(y: -50)
        }
        .sheet(isPresented: $showCountryList) {
            NavigationStack {
                CountryPickerView(store: CountriesStore()) { selected in
                    country = selected
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}


//#Preview {
//    EnterPhoneNumberView(vm: <#AuthenticationViewModel#>, number: .constant(""), onConfirm: {})
//}
