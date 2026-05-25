//
//  FeedView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/20/1405 AP.
//

import SwiftUI

struct FeedView: View {
    
    @Binding var selection: Int
    
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
                            Button {
                                withAnimation(.spring()) {
                                    selection = 0
                                }
                            } label: {
                                Image(systemName: "person.2.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                            
                            Text("TrueCam.")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                                .font(.caption.bold())
                                .kerning(2)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring()) {
                                    selection = 2
                                }
                            } label: {
                                Image("profile")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(17.5)
                            }
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
    FeedView(selection: .constant(1))
}
