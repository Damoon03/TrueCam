//
//  LabledField.swift
//  TrueCam
//
//  Created by Damoon saber on 2/27/1405 AP.
//

import SwiftUI

struct LabeledField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.white)
                .font(.system(size: 16))
                .frame(width: 90, alignment: .leading)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.leading, 6)
                }
                
                TextField("", text: $text)
                    .foregroundColor(.white)
                    .padding(.leading, 6)
            }
        }
    }
}
