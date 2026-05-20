//
//  LeftMenuTopView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/28/1405 AP.
//

import SwiftUI

struct LeftMenuTopView: View {
    
    @State var text = ""
    @State var isEditing = true
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
                Text("TrueCam.")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 22))
            }
            SearchBar(text: $text)
                    Spacer()
        }
        
    }
}

#Preview {
    LeftMenuTopView(selection: .constant(1))
}
