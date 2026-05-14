//
//  Profile.swift
//  TrueCam
//
//  Created by Damoon saber on 2/24/1405 AP.
//

import SwiftUI

struct Profile: View {
    var body: some View {
        VStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Image(systemName: "arrow.backward")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 20))
                        
                        Spacer()
                        
                        Text("Profile")
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.white)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                }
                
                VStack {
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .cornerRadius(65)
                   
                    Text("Damoon")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    
                    Text("@damoon_che")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 15))
                    
                    HStack {
                        Text("Your memories")
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(Color.gray)
                                .font(.system(size: 10))
                            
                            Text("Only visible to you")
                                .foregroundStyle(Color.gray)
                                .font(.system(size: 10))
                        }
                    }
                    .padding()
                    
                    VStack {
                        ZStack {
                           RoundedRectangle(cornerRadius: 25)
                                .foregroundStyle(Color.gray)
                                .opacity(0.1)
                                .frame(height: 230)
                            
                            VStack {
                                HStack {
                                    Text("Last 2 weeks")
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: 16))
                                        .padding(.top, 8)
                                    
                                    Spacer()
                                }
                                .padding(.leading)
                                
                                VStack {
                                    HStack(spacing: 4) {
                                        ForEach(1 ..< 8) { _ in
                                            MemoryView(day: 1)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Profile()
}
