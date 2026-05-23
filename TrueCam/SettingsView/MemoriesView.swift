//
//  MemoriesView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/2/1405 AP.
//

import SwiftUI

struct MemoriesView: View {
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("Memories")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }

                            
                            Spacer()
                            
                            Image(systemName: "questionmark.circle")
                                .foregroundStyle(.white)
                                .font(.system(size: 18))
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                
                VStack {
                    VStack {
                        HStack {
                            Text("Your memories are activated")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .padding(.leading)
                            Spacer()
                        }
                        
                        Text("All your TrueCam are automatically added to your memories and only visible by you")
                            .foregroundStyle(.white)
                            .padding(.top, 5)
                        
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(height: 210)
                            .foregroundStyle(Color(red: 22/255, green: 4/255, blue: 3/255))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.red, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Deactivate and Delete Memories")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                               
                                Spacer()
                            }
                            
                            VStack {
                                HStack {
                                    Text("If you deactivate your memories, all your TrueCam will be deleted and unrecoverable")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 14))
                                   
                                    Spacer()
                                }
                               
                                HStack {
                                    Text("All your future TrueCam wont be saved in Memories and will be automatically deleted as well")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 14))
                                   
                                    Spacer()
                                }
                            }
                            .padding(.top, 4)
                            
                            RoundedRectangle(cornerRadius: 12)
                                .containerRelativeFrame(.horizontal) { width, _ in
                                    width * 0.5
                                }
                                .frame(height: 40)
                                .foregroundStyle(Color(red: 44/255, green: 44/255, blue: 46/255))
                                .overlay(
                                    Text("Deactivate Memories")
                                        .foregroundStyle(.red)
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                )
                                .padding(.top, 8)
                        }
                        .padding(.leading)
                    }
                    .padding(.top, 22)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)
            }
        }
    }
}

#Preview {
    MemoriesView()
}
