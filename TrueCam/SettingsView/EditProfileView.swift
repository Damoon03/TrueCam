//
//  EditProfileView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/27/1405 AP.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @State private var fullname: String
    @State private var username: String
    @State private var bio: String
    @State private var location: String

    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var profileImage: Image?
    @State private var uiImage: UIImage?

    
    let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        
        _fullname = State(initialValue: currentUser.name)
        _username = State(initialValue: currentUser.username ?? "")
        _bio = State(initialValue: currentUser.bio ?? "")
        _location = State(initialValue: currentUser.location ?? "")
    }
    private var hasChanges: Bool {
        fullname != currentUser.name ||
        username != (currentUser.username ?? "") ||
        bio != (currentUser.bio ?? "") ||
        location != (currentUser.location ?? "") ||
        uiImage != nil
    }

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
                    
                        Button {
                            Task {
                                do {
                                    try await viewModel.updateUserProfile(
                                        fullname: fullname,
                                        username: username,
                                        bio: bio,
                                        location: location
                                    )
                                    
                                    if let uiImage {
                                        await viewModel.updateProfileImage(uiImage)
                                    }
                                    
                                    dismiss()
                                } catch {
                                    print("Update error:", error.localizedDescription)
                                }
                            }
                        } label: {
                            Text("Save")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                        }
                        .disabled(!hasChanges)
                        .opacity(hasChanges ? 1 : 0.5)

                    }
                    .padding(.horizontal)
                    
                    Text("Edit Profile")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                
                DividerLine()
                
                // MARK: Profile section
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack(alignment: .bottomTrailing) {
                        
                        if let profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else if let imageUrl = currentUser.profileImageUrl,
                                  let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle()
                                    .fill(.gray.opacity(0.1))
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        } else {
                            Circle()
                                .frame(width: 120, height: 120)
                                .foregroundStyle(.gray.opacity(0.1))
                                .overlay(
                                    Text(currentUser.name.prefix(1).uppercased())
                                        .foregroundStyle(.white)
                                        .font(.system(size: 120 * 0.45, weight: .semibold))
                                )
                        }

                        ZStack {
                            Circle()
                                .frame(width: 34, height: 34)
                                .foregroundStyle(.black)
                            
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.white)
                            
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.black.opacity(0.1))
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                                .shadow(color: .white, radius: 1)
                        }
                    }
                }
                .padding(.vertical, 20)
                .onChange(of: selectedItem) { _, newValue in
                    Task {
                        guard let data = try? await newValue?.loadTransferable(type: Data.self),
                              let uiImage = UIImage(data: data) else {
                            print("❌ Failed to load image data")
                            return
                        }

                        print("✅ Image loaded")
                        print("Size in bytes:", data.count)
                        print("Dimensions:", uiImage.size)

                        self.uiImage = uiImage
                        self.profileImage = Image(uiImage: uiImage)
                    }
                }



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

//#Preview {
//    EditProfileView(currentUser: User.init(from: Constant.1))
//}
