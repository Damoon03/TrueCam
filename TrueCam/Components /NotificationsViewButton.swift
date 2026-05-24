//
//  NotificationsViewButton.swift
//  TrueCam
//
//  Created by Damoon saber on 3/3/1405 AP.
//

import SwiftUI

struct NotificationsViewButton: View {
    
    var icon: String
    var text: String
    @Binding var toggle: Bool
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 45)
                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(Color.white)
                
                Text(text)
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
                    .font(.system(size: 14))
                
                Spacer()
                
                Toggle("", isOn: $toggle)
                
            }
            .containerRelativeFrame(.horizontal) { width, _ in
                width * 0.85
            }
            .frame(height: 30)
        }
    }
}

#Preview {
    NotificationsViewButton(icon: "face.smiling.fill", text: "RealMojis", toggle: .constant(true))
}
