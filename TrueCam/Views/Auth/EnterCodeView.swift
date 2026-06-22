//
//  EnterCodeView.swift
//  TrueCam
//

import SwiftUI
import Combine

struct EnterCodeView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var code: String
    let onConfirm: () -> Void

    var phoneDisplay: String? = nil

    @FocusState private var isFocused: Bool
    private let codeLength = 6

    @State private var timeRemaining = 59
    @State private var canResend = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
                    header

                    otpInputArea

                    resendSection

                    if code.count == codeLength {
                        Button {
                            print("Verifying Code: \(code)")
                            onConfirm()
                        } label: {
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
        .onAppear { isFocused = true }
        .animation(.snappy, value: code.count)
    }

    private var header: some View {
        VStack(spacing: 12) {
            Text("Enter the code we sent to")
                .foregroundStyle(.white.opacity(0.6))
                .font(.system(size: 16))

            Button {
                dismiss()
            } label: {
                HStack(spacing: 4) {
                    Text(phoneDisplay ?? "Edit phone number")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 4)

                    Image(systemName: "pencil.line")
                        .font(.system(size: 14))
                        .foregroundStyle(.thickMaterial)
                }
            }
        }
    }

    private var otpInputArea: some View {
        ZStack {
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0.01)
                .onChange(of: code) { _, newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    code = String(filtered.prefix(codeLength))
                }

            HStack(spacing: 12) {
                ForEach(0..<codeLength, id: \.self) { index in
                    CodeBox(index: index, code: code, isFocused: isFocused)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
    }

    private var resendSection: some View {
        Group {
            if canResend {
                Button {
                    timeRemaining = 59
                    canResend = false

                    code = ""
                    isFocused = true

                    // TODO: trigger resend via VM if you later add an action
                } label: {
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
            guard !canResend else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                canResend = true
            }
        }
    }
}

#Preview {
    EnterCodeView(code: .constant(""), onConfirm: {}, phoneDisplay: "+98 912 345 67 89")
}
