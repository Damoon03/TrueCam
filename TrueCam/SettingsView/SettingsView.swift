//
//  SettingsView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/25/1405 AP.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = AuthenticationViewModel()

    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    ZStack {
                        Text("Settings")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    
                    // MARK: - Profile Card
                    VStack {
                        NavigationLink{
                            EditProfileView().navigationBarBackButtonHidden()
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.white.opacity(0.07))
                                .containerRelativeFrame(.horizontal) { width, _ in
                                    width * 0.9
                                }
                                .frame(height: 90)
                                .overlay(
                                    HStack {
                                        if vm.currentUser?.profileImageUrl == nil {
                                            Circle()
                                                .frame(width: 60, height: 60)
                                                .foregroundStyle(.gray.opacity(0.1))
                                                .overlay(
                                                    Text(vm.currentUser?.name.prefix(1).uppercased() ?? "")
                                                        .foregroundStyle(.white)
                                                        .font(.system(size: 60 * 0.45, weight: .semibold))
                                                )
                                        } else {
                                            Image("profile")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle())
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Damoon")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                                .font(.system(size: 18))
                                            
                                            Text("@damoon_che")
                                                .foregroundStyle(.white.opacity(0.8))
                                                .fontWeight(.semibold)
                                                .font(.system(size: 14))
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 20))
                                    }
                                        .padding(.horizontal, 20)
                                )
                        }
                    }
                    
                    // MARK: - Features Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("FEATURES")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .padding(.horizontal, 22)
                        
                        NavigationLink{
                            MemoriesView().navigationBarBackButtonHidden()
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.white.opacity(0.07))
                                .containerRelativeFrame(.horizontal) { width, _ in
                                    width * 0.9
                                }
                                .frame(height: 45)
                                .overlay(
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 16))
                                        
                                        Text("Memories")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 16))
                                    }
                                        .padding(.horizontal, 24)
                                )
                        }
                    }
                    .padding(.top, 8)
                    
                    //MARK: - Settings Section
                    VStack(alignment: .leading) {
                        Text("SETTINGS")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .padding(.horizontal, 22)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white.opacity(0.07))
                            .containerRelativeFrame(.horizontal) { width, _ in
                                width * 0.9
                            }
                            .frame(height: 145)
                            .overlay(
                                VStack {
                                    NavigationLink {
                                        NotificationsView().navigationBarBackButtonHidden()
                                    } label: {
                                        HStack {
                                            Image(systemName: "square.and.pencil")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                            
                                            Text("Notifications")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .padding(.horizontal, 24)
                                        .frame(height: 30)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    
                                    
                                    DividerLine()
                                        
                                    
                                       
                                    
                                    NavigationLink {
                                        TimeZoneView().navigationBarBackButtonHidden()
                                    } label: {
                                        HStack {
                                            Image(systemName: "globe.europe.africa.fill")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                            
                                            Text("Time Zone")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .padding(.horizontal, 24)
                                        .frame(height: 30)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    
                                    
                                   DividerLine()
                                       
                                    
                                    NavigationLink {
                                        OtherView().navigationBarBackButtonHidden()
                                    } label: {
                                        HStack {
                                            Image(systemName: "hammer.circle")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                            
                                            Text("Other")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .padding(.horizontal, 24)
                                        .frame(height: 26)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                }
                            )
                    }
                    
                    //MARK: - About Section
                    VStack(alignment: .leading) {
                        Text("ABOUT")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .padding(.horizontal, 22)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white.opacity(0.07))
                            .containerRelativeFrame(.horizontal) { width, _ in
                                width * 0.9
                            }
                            .frame(height: 190)
                            .overlay(
                                VStack {
                                    NavigationLink {
                                        Text("Share view")
                                    } label: {
                                        HStack {
                                            Image(systemName: "square.and.arrow.up")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                            
                                            Text("Share TrueCam")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .padding(.horizontal, 24)
                                        .frame(height: 30)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    
                                    
                                   DividerLine()
                                        
                                    
                                    NavigationLink {
                                        Text("Rating View")
                                    } label: {
                                        HStack {
                                            Image(systemName: "star")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                            
                                            Text("Rate TrueCam")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .padding(.horizontal, 24)
                                        .frame(height: 30)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    
                                    
                                    DividerLine()

                                    
                                    NavigationLink {
                                        HelpView().navigationBarBackButtonHidden()
                                    } label: {
                                        HStack {
                                            Image(systemName: "lifepreserver")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                            
                                            Text("Help")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .padding(.horizontal, 24)
                                        .frame(height: 26)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    
                                    DividerLine()

                                    
                                    NavigationLink {
                                        Text("About view")
                                    } label: {
                                        HStack {
                                            Image(systemName: "info.circle")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                            
                                            Text("About")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .padding(.horizontal, 24)
                                        .frame(height: 30)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    
                                }
                                
                            )
                    }
                    VStack() {
                        Button {
                            vm.signOut()
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.white.opacity(0.07))
                                .containerRelativeFrame(.horizontal) { width, _ in
                                    width * 0.9
                                }
                                .frame(height: 45)
                                .overlay(Text("Log Out")
                                    .foregroundStyle(Color.red)
                                )
                        }

                        Text("version 0.0.0 - production")
                            .foregroundStyle(Color.gray)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SettingsView()
}
