//
//  FriendsView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/29/1405 AP.
//

import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 65)
                        .foregroundStyle(Color.Resolved(red: 40/255, green: 40/255, blue: 35/255))
                        .overlay(
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
                                    Text("Invite friends to TrueCam")
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                    
                                    Text("TrueCam/damoon_che")
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                            }
                                .padding(.horizontal)
                        )
                }
                .padding(.horizontal)
                
                VStack {
                    HStack {
                        Text("MY FRIENDS (21)")
                            .foregroundStyle(Color(red: 205/255, green: 204/255, blue: 209/255))
                            .fontWeight(.semibold)
                            .font(.system(size: 14))
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        
                        Spacer()
                    }
                    
                    ForEach(1..<16) { _ in

                        FriendCellView()
                    }
                }
                .padding(.top)
                
                Spacer()
                
            }
            .padding(.top, 20)
        }
        .padding(.top, 110)
    }
}

#Preview {
    FriendsView()
}
