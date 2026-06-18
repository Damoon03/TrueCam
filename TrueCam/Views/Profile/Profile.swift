//
//  Profile.swift
//  TrueCam
//

import SwiftUI
import Combine

struct Profile: View {

    @Binding var selection: Int
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject private var profileVM = ProfileViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.black
                        .ignoresSafeArea()

                    VStack {
                        HStack {
                            Button {
                                withAnimation(.spring()) {
                                    selection = 1
                                }
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: 20))
                            }
                            Spacer()

                            Text("Profile")
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)

                            Spacer()

                            NavigationLink {
                                SettingsView().navigationBarBackButtonHidden()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .padding(.horizontal)

                        Spacer()
                    }

                    VStack {
                        if let imageUrl = viewModel.currentUser?.profileImageUrl,
                           let url = URL(string: imageUrl) {

                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle()
                                    .foregroundStyle(.gray.opacity(0.1))
                            }
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())

                        } else {
                            Circle()
                                .frame(width: 130, height: 130)
                                .foregroundStyle(.gray.opacity(0.1))
                                .overlay(
                                    Text(viewModel.currentUser?.name.prefix(1).uppercased() ?? "")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 130 * 0.45, weight: .semibold))
                                )
                        }

                        Text(viewModel.currentUser?.name ?? "")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 20))
                            .fontWeight(.bold)

                        Text("@\(viewModel.currentUser?.username ?? "username")")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 15))

                        HStack(spacing: 4) {
                            Text("\(viewModel.currentUser?.friendCount ?? 0)")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                            Text("friends")
                                .foregroundStyle(.gray)
                        }
                        .font(.system(size: 14))
                        .padding(.top, 4)

                        HStack {
                            Text("Your memories")
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 15))

                            Spacer()

                            HStack(spacing: 4) {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(Color.gray)
                                    .font(.system(size: 10))

                                Text("Only visible to you")
                                    .foregroundStyle(Color.gray)
                                    .font(.system(size: 10))
                            }
                        }
                        .padding()

                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .foregroundStyle(Color.gray)
                                    .opacity(0.1)
                                    .frame(height: 230)

                                VStack {
                                    HStack {
                                        Text("Last 2 weeks")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: 16))
                                            .padding(.top, 8)

                                        Spacer()
                                    }
                                    .padding(.leading)

                                    if profileVM.isLoading {
                                        ProgressView()
                                            .tint(.white)
                                            .frame(maxHeight: .infinity)
                                    } else {
                                        VStack {
                                            HStack(spacing: 4) {
                                                ForEach(0..<7, id: \.self) { i in
                                                    MemoryView(
                                                        post: recentPosts.indices.contains(i) ? recentPosts[i] : nil,
                                                        placeholderDay: i + 1
                                                    )
                                                }
                                            }

                                            HStack(spacing: 4) {
                                                ForEach(7..<14, id: \.self) { i in
                                                    MemoryView(
                                                        post: recentPosts.indices.contains(i) ? recentPosts[i] : nil,
                                                        placeholderDay: i + 1
                                                    )
                                                }
                                            }
                                            .padding(.top, -2)
                                        }
                                        .padding(.top, -2)
                                    }

                                    NavigationLink {
                                        MemoriesView().navigationBarBackButtonHidden()
                                    } label: {
                                        Text("View all my Memories")
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 13))
                                            .overlay(RoundedRectangle(cornerRadius: 8)
                                                .stroke(.gray, lineWidth: 2)
                                                .frame(width: 155, height: 20)
                                                .opacity(0.5))
                                            .padding(8)
                                    }
                                }
                            }
                        }

                        if let username = viewModel.currentUser?.username {
                            Text("🔗TrueCam/\(username)")
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 15))
                                .padding(.top, 10)
                        }

                        Spacer()
                    }
                    .padding(.top, 35)
                }
            }
        }
        .task {
            if let uid = viewModel.currentUser?.id {
                await profileVM.fetchPosts(uid: uid)
            }
        }
        .onChange(of: viewModel.currentUser?.id) { _, newID in
            if let uid = newID {
                Task { await profileVM.fetchPosts(uid: uid) }
            }
        }
    }

    private var recentPosts: [Post] {
        Array(profileVM.posts.prefix(14))
    }
}
