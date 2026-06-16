//
//  LeftMenuTopView.swift
//  TrueCam
//

import SwiftUI

struct LeftMenuTopView: View {

    @Binding var searchText: String
    @Binding var selection: Int

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()

                    Button {
                        withAnimation(.spring()) {
                            selection = 1
                        }
                    } label: {
                        Image(systemName: "arrow.forward")
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal)

                Text("TrueCam.")
                    .foregroundStyle(.white)
                    .font(.system(size: 22))
                    .font(.caption.bold())
                    .kerning(2)
            }

            SearchBar(text: $searchText)

            Spacer()
        }
    }
}

#Preview {
    LeftMenuTopView(searchText: .constant(""), selection: .constant(1))
}
