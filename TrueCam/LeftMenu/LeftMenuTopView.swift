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
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Image(systemName: "arror.forward")
                    .foregroundStyle(.white)
                
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

#Preview {
    LeftMenuTopView()
}
