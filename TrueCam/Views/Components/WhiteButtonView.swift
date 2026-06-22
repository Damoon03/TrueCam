//
//  WhiteButtonView.swift
//  TrueCam
//

import SwiftUI

struct WhiteButtonView: View {

    @Binding var buttonActive: Bool
    var text: String
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width * 0.9
                    }
                    .frame(height: 45)
                    .foregroundStyle(buttonActive ? Color(red: 250/255, green: 250/255, blue: 250/255)
                    : Color(red: 86/255, green: 86/255, blue: 88/255))

                HStack {
                    Spacer()

                    Text(text)
                        .foregroundStyle(.black)
                        .font(.system(size: 14))
                        .fontWeight(.medium)

                    Spacer()
                }
                .containerRelativeFrame(.horizontal) { width, _ in
                    width * 0.3 }
                .frame(height: 30)
            }
        }
        .disabled(!buttonActive)
    }
}

#Preview {
    WhiteButtonView(buttonActive: .constant(false), text: "Save")
}
