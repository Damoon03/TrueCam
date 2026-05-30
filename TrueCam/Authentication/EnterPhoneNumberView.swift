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
    @State private var phoneNumber = ""
    @FocusState private var isFocused: Bool
    
    @Binding var number: String
    let onConfirm: () -> Void

    var body: some View {
        NavigationStack {
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
                            // Country Selector Button
                            Button {
                                self.showCountryList.toggle()
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

                            // Phone TextField
                            TextField("", text: $phoneNumber, prompt: Text("Your number").foregroundStyle(.white.opacity(0.2)))
                                .focused($isFocused)
                                .keyboardType(.phonePad)
                                .onChange(of: phoneNumber) { oldValue, newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.phoneNumber = filtered
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
                            

                        if !phoneNumber.isEmpty {
                            Button(action: {
                                print("Confirming: +\(country.phoneCode)\(phoneNumber)")
                                onConfirm()
                            }) {
                                Text("CONFIRM")
                                    .font(.system(size: 12, weight: .bold))
                                    .kerning(2)
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.white)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 30)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                       
                    }
                }
                .offset(y: -50)
            }
            // Sheet for Country Picker
            .sheet(isPresented: $showCountryList) {
                NavigationStack {
                    CountryPickerView(store: CountriesStore()) { selected in
                        self.country = selected
                    }
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    EnterPhoneNumberView(number: .constant(""), onConfirm: {})
}
