//
//  Feed.swift
//  TrueCam
//
//  Created by Damoon saber on 2/20/1405 AP.
//

import SwiftUI

struct Feed: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ZStack {
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "camera.aperture")
                                .foregroundColor(.white)
                           
                            Spacer()
                            
                            Text("TrueCam")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 22))
                            
                            Spacer()
                            
                            Image("profile")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .cornerRadius(17.5)
                            
                            
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text("My Friends")
                                .foregroundColor(.white)
                            
                            Text("Discovery")
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    Feed()
}
