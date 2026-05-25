//
//  EnterNameView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/4/1405 AP.
//
import SwiftUI

struct EnterNameView: View {
    @State private var name = ""
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
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        Spacer()
                    }
                    
                    TextField("", text: $name, prompt: Text("Enter name...").foregroundStyle(.white.opacity(0.2)))
                        .focused($isFocused)
                        .font(.system(size: 16, weight: .medium))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground).opacity(0.1))
                                .stroke(isFocused ? Color.white.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
                                .frame(width: 200 ,height: 50)
                        )
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 80)
                        .animation(.snappy, value: isFocused)
                    
                    if !name.isEmpty {
                        Button(action: {  }) {
                            Text("CONFIRM")
                                .font(.caption.bold())
                                .kerning(2)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 30)
                                .background(Color.white)
                                .foregroundStyle(.black)
                                .cornerRadius(5)
                        }
                        .transition(.opacity.animation(.easeIn))
                    }
                }
                .padding(.top, 100)
                Spacer()
            }
        }
    }
}


#Preview {
    EnterNameView()
}
