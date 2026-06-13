//
//  ContactUsView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/1/1405 AP.
//

import SwiftUI

struct ContactUsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    
                    ZStack {
                        Text("How can we help you?")
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
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                
                VStack {
                    VStack(spacing: 28) {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Image(systemName: "questionmark.circle")
                                
                                Text("Ask a Question")
                            }
                            .foregroundStyle(.white)
                        }
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Image(systemName: "ladybug")
                                
                                Text("Report a Problem")
                            }
                            .foregroundStyle(.white)
                        }
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Image(systemName: "atom")
                                
                                Text("Become Beta Tester")
                            }
                            .foregroundStyle(.white)
                        }
                        
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)
            }
        }
    }
}

#Preview {
    ContactUsView()
}
