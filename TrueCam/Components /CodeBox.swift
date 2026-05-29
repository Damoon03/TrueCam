//
//  CodeBox.swift
//  TrueCam
//
//  Created by Damoon saber on 3/8/1405 AP.
//

import SwiftUI

struct CodeBox: View {
    let index: Int
    let code: String
    let isFocused: Bool
    
    var body: some View {
        let char = index < code.count ? String(code[code.index(code.startIndex, offsetBy: index)]) : ""
        let isSelected = isFocused && index == min(code.count, 5)
        
        Text(char)
            .font(.system(size: 22, weight: .medium))
            .foregroundStyle(.white)
            .frame(width: 40, height: 45)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.white : Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
            .animation(.snappy, value: isSelected)
    }
}
