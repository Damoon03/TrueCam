//
//  RequestsView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/29/1405 AP.
//

import SwiftUI

struct RequestsView: View {
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
                        Text("FINDING REQUESTS (0)")
                            .foregroundStyle(Color(red: 205/255, green: 204/255, blue: 209/255))
                            .fontWeight(.semibold)
                            .font(.system(size: 14))
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Text("sent")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                            .padding(.trailing)
                    }
                    .padding(.bottom, 10)
                    
                    RoundedRectangle(cornerRadius: 18)
                        .containerRelativeFrame(.horizontal) { width, _ in
                            width * 0.95
                        }
                        .frame(height: 90)
                        .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                        .overlay(
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("No pending requests")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                                
                                HStack {
                                    Text("You don't have any pending requests")
                                        .foregroundStyle(.white)
                                }
                            }
                        )
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
    RequestsView()
}
