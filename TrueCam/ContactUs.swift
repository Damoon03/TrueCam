//
//  ContactUs.swift
//  TrueCam
//
//  Created by Damoon saber on 3/1/1405 AP.
//

import SwiftUI

struct ContactUs: View {
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
                            Image(systemName: "arrow.backward")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                            
                            Spacer()
                        }
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
    ContactUs()
}
