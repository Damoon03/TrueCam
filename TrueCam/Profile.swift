//
//  Profile.swift
//  TrueCam
//
//  Created by Damoon saber on 2/24/1405 AP.
//

import SwiftUI

struct Profile: View {
    
    @Binding var selection: Int
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Button {
                                withAnimation(.spring()) {
                                    selection = 1
                                }
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: 20))
                            }
                            Spacer()
                            
                            Text("Profile")
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            NavigationLink {
                                SettingsView().navigationBarBackButtonHidden()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(Color.white)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                    }
                    
                    VStack {
                        if viewModel.currentUser?.profileImageUrl == nil {
                            Circle()
                                .frame(width: 130, height: 130)
                                .foregroundStyle(.gray.opacity(0.1))
                                .overlay(
                                    Text(viewModel.currentUser?.name.prefix(1).uppercased() ?? "")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 130 * 0.45, weight: .semibold))
                                )
                        } else {
                            Image("profile")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130, height: 130)
                                .clipShape(.circle)
                        }
                        
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
                                            ForEach(1 ..< 8) { x in
                                                MemoryView(day: x)
                                            }
                                        }
                                        
                                        HStack(spacing: 4) {
                                            ForEach(1 ..< 8) { x in
                                                MemoryView(day: x + 7)
                                            }
                                        }
                                        .padding(.top, -2)
                                    }
                                    .padding(.top, -2)
                                    
                                    Text("View all my Memories")
                                        .foregroundStyle(Color.white)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 13))
                                        .overlay(RoundedRectangle(cornerRadius: 8)
                                            .stroke(.gray,lineWidth: 2)
                                            .frame(width: 155, height: 20)
                                            .opacity(0.5))
                                        .padding(8)
                                }
                                
                            }
                        }
                        
                        Text("🔗TrueCam/damoon_che")
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                            .padding(.top, 10)
                        Spacer()
                        
                        
                    }
                    .padding(.top, 35)
                }
            }
        }
    }
}

#Preview {
    Profile(selection: .constant(2))
}
