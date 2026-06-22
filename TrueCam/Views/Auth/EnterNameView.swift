//
//  EnterNameView.swift
//  TrueCam
//
import SwiftUI

struct EnterNameView: View {

    @Binding var name: String
    let onConfirm: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Text("TrueCam.")
                        .foregroundStyle(.white)
                        .font(.system(size: 22))
                        .font(.caption.bold())
                        .kerning(2)
                    Spacer()
                }

                VStack(spacing: 40) {
                    HStack {
                        Spacer()
                        Text("let's get started, What's your name?")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        Spacer()
                    }

                    TextField("", text: $name,
                              prompt: Text("Enter name...").foregroundStyle(.white.opacity(0.2)))
                        .focused($isFocused)
                        .font(.system(size: 16, weight: .medium))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isFocused ? Color.white : Color.white.opacity(0.15), lineWidth: 1)
                                )
                        )
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 80)
                        .animation(.snappy, value: isFocused)

                    if !name.isEmpty {
                        Button(action: {
                            onConfirm()
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
                        .transition(.opacity)
                    }
                }
                .padding(.top, 100)

                Spacer()
            }
        }
        .onAppear { isFocused = true }
        .animation(.snappy, value: name.isEmpty)
    }
}


#Preview {
EnterNameView(name: .constant(""), onConfirm: {})
}
