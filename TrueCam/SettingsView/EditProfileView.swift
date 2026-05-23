//
//  EditProfileView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/27/1405 AP.
//

import SwiftUI

struct EditProfileView: View {
    
    @State var fullname = ""
    @State var username = ""
    @State var bio = ""
    @State var location = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                // MARK: Header
                ZStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(.white)
                        }

                        Spacer()
                        Text("Save")
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal)
                    
                    Text("Edit Profile")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                
                DividerLine()
                
                // MARK: Profile section
                ZStack(alignment: .bottomTrailing) {
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    
                    ZStack {
                        Circle().frame(width: 34, height: 34).foregroundStyle(.black)
                        Circle().frame(width: 30, height: 30).foregroundStyle(.white)
                        Circle().frame(width: 30, height: 30).foregroundStyle(.black.opacity(0.1))
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 16))
                            .shadow(color: .white, radius: 1)
                    }
                }
                .padding(.vertical, 20)
                
                DividerLine()
                
                // MARK: Form Section
                VStack(spacing: 20) {
                    
                    LabeledField(label: "Full Name", placeholder: "Damoon", text: $fullname)
                        .padding(.horizontal)

                    DividerLine()
                    
                    LabeledField(label: "Username", placeholder: "damoon_che", text: $username)
                        .padding(.horizontal)

                    DividerLine()
                    
                    HStack(alignment: .top) {
                        Text("Bio")
                            .foregroundStyle(.white)
                            .font(.system(size: 16))
                            .frame(width: 90, alignment: .leading)
                            .padding(.top, 6)

                        ZStack(alignment: .topLeading) {
                            if bio.isEmpty {
                                Text("Write your bio...")
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 8)
                            }
                            TextEditor(text: $bio)
                                .foregroundColor(.white)
                                .frame(minHeight: 60, maxHeight: 100)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .padding(.horizontal, 2)
                        }
                    }
                    .padding(.horizontal)

                    DividerLine()
                    
                    LabeledField(label: "Location", placeholder: "Add your location", text: $location)
                        .padding(.horizontal)

                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    EditProfileView()
}
