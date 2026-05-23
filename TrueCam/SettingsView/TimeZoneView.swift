//
//  TimeZoneView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/28/1405 AP.
//

import SwiftUI

struct TimeZoneView: View {
    
    @State var aera = "europe"
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                ZStack {
                    Text("Time Zone")
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
                }
                .padding(.horizontal)
                
                Spacer()
                
            }

            VStack {
                VStack {
                    HStack {
                        Text("Select your Time Zone")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        
                        Spacer()
                        
                    }
                    
                    Text("To receive your TrueCam notification during daytime, select your time zone. When changing your time zone, your current TrueCam will be deleted. You can only change time zones once a day.")
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .padding(.top, 3)
                
                }
                .padding()

                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white.opacity(0.07))
                            .containerRelativeFrame(.horizontal) { width, _ in
                                width * 0.9
                            }
                            .frame(height: 190)
                        
                            .overlay (
                                VStack {
                                    Button {
                                        self.aera = "europe"
                                    } label: {
                                        HStack {
                                            Image(systemName: "globe.europe.africa.fill")
                                                .foregroundStyle(.white)
                                            
                                            Text("Europe")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            if aera == "europe" {
                                                Image(systemName: "checkmark.circle")
                                                    .foregroundStyle(.gray)
                                            }
                                            
                                        }
                                        .padding(.horizontal)
                                        .padding(.top, 8 )
                                    }
                                    
                                    DividerLine()
                                    
                                    Button {
                                        self.aera = "americas"

                                    } label: {
                                        HStack {
                                            Image(systemName: "globe.americas.fill")
                                                .foregroundStyle(.white)
                                            
                                            Text("Americas")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            if aera == "americas" {
                                                Image(systemName: "checkmark.circle")
                                                    .foregroundStyle(.gray)
                                            }
                                            
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical,5 )

                                    }
                                    
                                    DividerLine()
                                    
                                    Button {
                                        self.aera = "eastasia"

                                    } label: {
                                        HStack {
                                            Image(systemName: "globe.asia.australia.fill")
                                                .foregroundStyle(.white)
                                            
                                            Text("Eaat Asia")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            if aera == "eastasia" {
                                                Image(systemName: "checkmark.circle")
                                                    .foregroundStyle(.gray)
                                            }
                                            
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical,5 )

                                    }
                                    
                                    DividerLine()
                                    
                                    Button {
                                        self.aera = "westasia"

                                    } label: {
                                        HStack {
                                            Image(systemName: "globe.asia.australia.fill")
                                                .foregroundStyle(.white)
                                            
                                            Text("West Asia")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            if aera == "westasia" {
                                                Image(systemName: "checkmark.circle")
                                                    .foregroundStyle(.gray)
                                            }
                                            
                                        }
                                        .padding(.horizontal)
                                        .padding(.bottom, 8 )
                                        .padding(.top, 4)

                                    }
                                }
                            )
                    }
                    
                    Spacer()
                    
                    Button {
                         
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray.opacity(0.6))
                            .containerRelativeFrame(.horizontal) { width, _ in
                                width * 0.9
                            }
                            .frame(height: 45)
                            .overlay(Text("Save")
                                .foregroundStyle(.black)
                            )
                            
                    }
                    .padding(.bottom)

                }
                
            }
            .padding(.vertical, 50)
        }
    }
}

#Preview {
    TimeZoneView()
}
