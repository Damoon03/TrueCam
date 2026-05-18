//
//  SearchBar.swift
//  TrueCam
//
//  Created by Damoon saber on 2/28/1405 AP.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Add or search friends", text: $text)
                    .foregroundStyle(.white)
                    .focused($isFocused)
            }
            .padding(.horizontal, 12)
            .frame(height: 50)
            .background(Color(red: 28/255, green: 28/255, blue: 30/255))
            .cornerRadius(10)
            
            if isFocused {
                Button("Cancel") {
                    text = ""
                    isFocused = false
                }
                .foregroundStyle(.white)
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .trailing))
                    )
                )
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isFocused)
    }
}


#Preview {
    SearchBar(text: .constant("") )
}
