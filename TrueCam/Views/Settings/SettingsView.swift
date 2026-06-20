//
//  SettingsView.swift
//  TrueCam
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel

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
                        if let currentUser = viewModel.currentUser {
                            NavigationLink {
                                EditProfileView(currentUser: currentUser)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                profileCard(for: currentUser)
                            }
                        } else {
                            profileCardPlaceholder
                        }
                    }

                    // MARK: - Features Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("FEATURES")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .padding(.horizontal, 22)

                        NavigationLink {
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

                    // MARK: - Settings Section
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
                                        settingsRow(icon: "square.and.pencil", title: "Notifications", height: 30)
                                    }
                                    .buttonStyle(.plain)

                                    DividerLine()

                                    NavigationLink {
                                        TimeZoneView().navigationBarBackButtonHidden()
                                    } label: {
                                        settingsRow(icon: "globe.europe.africa.fill", title: "Time Zone", height: 30)
                                    }
                                    .buttonStyle(.plain)

                                    DividerLine()

                                    NavigationLink {
                                        OtherView().navigationBarBackButtonHidden()
                                    } label: {
                                        settingsRow(icon: "hammer.circle", title: "Other", height: 26)
                                    }
                                    .buttonStyle(.plain)
                                }
                            )
                    }

                    // MARK: - About Section
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
                                        settingsRow(icon: "square.and.arrow.up", title: "Share TrueCam", height: 30)
                                    }
                                    .buttonStyle(.plain)

                                    DividerLine()

                                    NavigationLink {
                                        Text("Rating View")
                                    } label: {
                                        settingsRow(icon: "star", title: "Rate TrueCam", height: 30)
                                    }
                                    .buttonStyle(.plain)

                                    DividerLine()

                                    NavigationLink {
                                        HelpView().navigationBarBackButtonHidden()
                                    } label: {
                                        settingsRow(icon: "lifepreserver", title: "Help", height: 26)
                                    }
                                    .buttonStyle(.plain)

                                    DividerLine()

                                    NavigationLink {
                                        Text("About view")
                                    } label: {
                                        settingsRow(icon: "info.circle", title: "About", height: 30)
                                    }
                                    .buttonStyle(.plain)
                                }
                            )
                    }

                    VStack {
                        Button {
                            viewModel.signOut()
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

                        Text("version 0.0.1 - production")
                            .foregroundStyle(Color.gray)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Reusable row

    @ViewBuilder
    private func settingsRow(icon: String, title: String, height: CGFloat) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .font(.system(size: 16))

            Text(title)
                .foregroundStyle(.white)
                .fontWeight(.semibold)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
                .font(.system(size: 16))
        }
        .padding(.horizontal, 24)
        .frame(height: height)
        .contentShape(Rectangle())
    }

    // MARK: - Profile card

    @ViewBuilder
    private func profileCard(for user: User) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(.white.opacity(0.07))
            .containerRelativeFrame(.horizontal) { width, _ in
                width * 0.9
            }
            .frame(height: 90)
            .overlay(
                HStack {
                    if let imageUrl = user.profileImageUrl,
                       let url = URL(string: imageUrl) {

                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Circle()
                                .foregroundStyle(.gray.opacity(0.1))
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())

                    } else {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.gray.opacity(0.1))
                            .overlay(
                                Text(user.name.prefix(1).uppercased())
                                    .foregroundStyle(.white)
                                    .font(.system(size: 60 * 0.45, weight: .semibold))
                            )
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 18))

                        Text("@\(user.username ?? "username")")
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

    private var profileCardPlaceholder: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(.white.opacity(0.07))
            .containerRelativeFrame(.horizontal) { width, _ in
                width * 0.9
            }
            .frame(height: 90)
            .overlay(
                ProgressView().tint(.white)
            )
    }
}
