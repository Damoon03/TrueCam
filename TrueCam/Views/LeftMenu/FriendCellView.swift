//
//  FriendCellView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/29/1405 AP.
//

import SwiftUI

struct FriendCellView: View {
    var body: some View {
        HStack {
            Image("elliot")
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 65)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("Elliot")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)

                Text("Elliot_Alderson")
                    .foregroundStyle(.gray)
                    .padding(.top, -10)
                
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                    
                    Text("MrRobot")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                        .padding(.leading, -4)
                }
                
            }
            
            Spacer()
            
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
                .font(.system(size: 16))
                .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

#Preview {
    FriendCellView()
}
