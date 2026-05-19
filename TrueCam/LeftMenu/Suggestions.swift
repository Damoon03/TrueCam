//
//  Suggestions.swift
//  TrueCam
//
//  Created by Damoon saber on 2/29/1405 AP.
//

import SwiftUI

struct Suggestions: View {
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 65)
                        .foregroundStyle(Color.Resolved(red: 40/255, green: 40/255, blue: 35/255))
                        .overlay(
                            HStack {
                                
                                Image("profile")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
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
                        Text("ADD YOUR CONTACTS")
                            .foregroundStyle(Color(red: 205/255, green: 204/255, blue: 209/255))
                            .fontWeight(.semibold)
                            .font(.system(size: 14))
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        
                        Spacer()
                    }
                    
                    ForEach(1..<15 ) { _ in
                        SuggestionCellView()
                        
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
    Suggestions()
}
