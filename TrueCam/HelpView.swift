//
//  HelpView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/1/1405 AP.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("Help")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "arrow.backward")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                        }
                    }
                    
                    Spacer()
                    
                }
                
                VStack {
                    
                    VStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                                
                                Text("Contact us")
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .font(.system(size: 16))
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                                    .fixedSize()
                                    .padding(.trailing, 20)
                            }
                            .padding(.horizontal)
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                                
                                Text("Help Center")
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .font(.system(size: 16))
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                                    .fixedSize()
                                    .padding(.trailing, 20)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                }
            }
        }
    }
}

#Preview {
    HelpView()
}
