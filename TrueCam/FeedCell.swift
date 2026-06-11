//
//  FeedCell.swift
//  TrueCam
//
//  Created by Damoon saber on 2/20/1405 AP.
//

import SwiftUI

struct FeedCell: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                // USERNAME
                
                HStack {
                    if let imageUrl = viewModel.currentUser?.profileImageUrl,
                       let url = URL(string: imageUrl) {
                        
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Circle()
                                .foregroundStyle(.gray.opacity(0.1))
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                    } else {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.gray.opacity(0.1))
                            .overlay(
                                Text(viewModel.currentUser?.name.prefix(1).uppercased() ?? "")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 40 * 0.45, weight: .semibold))
                            )
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Damoon_che")
                            .foregroundStyle(Color.white)
                      //      .fontWeight(.semibold)
                            .font(.system(size: 16))
                        
                        Text("Iran • 2h ago")
                            .foregroundStyle(Color.gray)
                            .font(.system(size: 14))
                    }
                }
                .padding(.horizontal)
                
                
                // IMAGE
                
                ZStack {
                    
                    VStack {
                        Spacer()
                       
                        HStack {
                            Spacer()
                        
                            VStack {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: 25))
                                    .shadow(color: .black, radius: 3,x: 1,y: 1)

                                Image(systemName: "bubble.left.fill")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: 21))
                                    .shadow(color: .black, radius: 3,x: 1,y: 1)
                                    .padding(.top, 10)

                                
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 35)
                        }
                    }
                    .zIndex(1)

                    VStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                        
                        
                        HStack {
                            Text("Add a Comment...")
                                .foregroundStyle(Color(.gray))
                                .fontWeight(.semibold)
                                .padding(.leading, 10)
                            Spacer()
                        }
                    }
                    .padding(.top, 40)
                    
                    VStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(.black))
                                .frame(width: 125, height: 165)
                                .overlay(
                                    Image("front")
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                        .frame(width: 120, height: 160))
                                .padding(.leading)
                            
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 600)
        }
    }
}

#Preview {
    FeedCell()
}
