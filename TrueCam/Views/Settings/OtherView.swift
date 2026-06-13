//
//  OtherView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/1/1405 AP.
//

import SwiftUI

struct OtherView: View {
    
    @State var fastCamera = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    
                    ZStack {
                        Text("Other")
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
                    VStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Image(systemName: "camera.viewfinder")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                                
                                Text("Fast Camera (reduce quality)")
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .font(.system(size: 14))
                                Spacer()
                                
                                Toggle("", isOn: $fastCamera)
                                    .frame(width: 60)
                            }
                            .padding(.horizontal)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Image(systemName: "xmark.app")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                                
                                Text("Clear cach")
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .font(.system(size: 14))
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
                                
                               Spacer()
                                
                                Text("Delete Account")
                                    .foregroundStyle(.red)
                                   
                                Spacer()
                                
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    OtherView()
}
