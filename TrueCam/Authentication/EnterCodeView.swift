//
//  EnterCodeView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/8/1405 AP.
//

import SwiftUI
import Combine

struct EnterCodeView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var code: String = ""
    @FocusState private var isFocused: Bool
    let codeLength = 6
    
    @State private var timeRemaining = 59
    @State private var canResend = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("TrueCam.")
                        .foregroundStyle(.white)
                        .font(.system(size: 22))
                        .font(.caption.bold())
                        .kerning(2)
                    Spacer()
                }

                Spacer()
                
                VStack(spacing: 35) {
                    VStack(spacing: 12) {
                        Text("Enter the code we sent to")
                            .foregroundStyle(.white.opacity(0.6))
                            .font(.system(size: 16))
                        
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Text("+98 912 345 67 89")
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 4)
                                
                                Image(systemName: "pencil.line")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.thickMaterial)
                            }
                        }
                    }
                    
                    otpInputArea
                    
                    resendSection
                    
                    if code.count == codeLength {
                        Button(action: {
                            print("Verifying Code: \(code)")
                        }) {
                            Text("CONFIRM")
                                .font(.caption.bold())
                                .kerning(2)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 30)
                                .background(Color.white)
                                .foregroundStyle(.black)
                                .cornerRadius(5)
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .onAppear {
            isFocused = true
        }
        .animation(.snappy, value: code.count)
    }
    
    private var otpInputArea: some View {
        ZStack {
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0)
                .onChange(of: code) { oldValue, newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    code = String(filtered.prefix(codeLength))
                }
            
            HStack(spacing: 12) {
                ForEach(0..<codeLength, id: \.self) { index in
                    CodeBox(index: index, code: code, isFocused: isFocused)
                }
            }
        }
        .onTapGesture {
            isFocused = true
        }
    }
    
    private var resendSection: some View {
        Group {
            if canResend {
                Button(action: {
                    timeRemaining = 59
                    canResend = false
                }) {
                    Text("Resend Code")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.blue)
                }
            } else {
                HStack(spacing: 4) {
                    Text("Resend code in")
                        .foregroundStyle(.white.opacity(0.4))
                    
                    Text("0:\(timeRemaining, specifier: "%02d")")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                canResend = true
            }
        }
    }
}

#Preview {
    EnterCodeView()
}
