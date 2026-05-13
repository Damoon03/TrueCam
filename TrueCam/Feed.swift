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
                ScrollView {
                    VStack {
                        VStack {
                            ZStack {
                                VStack(alignment: .leading) {
                                    Image("back")
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(5)
                                }
                                
                                VStack {
                                    HStack {
                                        Image("front")
                                            .resizable()
                                            .scaledToFit()
                                            .border(.black)
                                            .cornerRadius(2)
                                            .frame(width: 20, height: 40)
                                            .padding(.leading)
                                        Spacer()
                                        
                                        
                                    }
                                    .padding(.top, 18)
                                    Spacer()
                                }
                            }
                            .frame(width: 100)
                        }
                        
                        VStack { Text("Add a Caption...")
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                            
                            Text("View Comment")
                                .foregroundStyle(Color.gray)
                            
                            HStack {
                                
                                Text("Iran, Rasht • 2h ago")
                                    .foregroundStyle(Color.gray)
                                    .font(.system(size: 12))
                                
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        
                        ForEach(1 ..< 8) { _ in
                            FeedCell()
                        }
                    }
                    .padding(.top, 80)
                }
                
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("TrueCam")
                                .foregroundStyle(Color(.white))
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
                                .foregroundStyle(Color(.white))
                            
                            Text("Discovery")
                                .foregroundStyle(Color(.gray))
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
