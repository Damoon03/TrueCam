//
//  RequestsView.swift
//  TrueCam
//

import SwiftUI
import FirebaseAuth

struct RequestsView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var friendsVM: FriendsViewModel

    var body: some View {
        VStack {
            ScrollView {
                inviteCard

                VStack {
                    HStack {
                        Text("FRIEND REQUESTS (\(friendsVM.friendRequests.count))")
                            .foregroundStyle(Color(red: 205/255, green: 204/255, blue: 209/255))
                            .fontWeight(.semibold)
                            .font(.system(size: 14))
                            .padding(.horizontal)

                        Spacer()
                    }
                    .padding(.bottom, 10)

                    if friendsVM.isLoading {
                        ProgressView().tint(.white)
                            .padding(.top, 20)
                    } else if friendsVM.friendRequests.isEmpty {
                        RoundedRectangle(cornerRadius: 18)
                            .containerRelativeFrame(.horizontal) { width, _ in
                                width * 0.95
                            }
                            .frame(height: 90)
                            .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            .overlay(
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("No pending requests")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                    }

                                    HStack {
                                        Text("You don't have any pending requests")
                                            .foregroundStyle(.white)
                                    }
                                }
                            )
                    } else {
                        ForEach(friendsVM.friendRequests) { user in
                            requestRow(for: user)
                        }
                    }
                }
                .padding(.top)

                Spacer()
            }
            .padding(.top, 20)
        }
        .padding(.top, 110)
    }

    @ViewBuilder
    private func requestRow(for user: User) -> some View {
        HStack {
            if let imageUrl = user.profileImageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Circle().foregroundStyle(.gray.opacity(0.1))
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.gray.opacity(0.1))
                    .overlay(
                        Text(user.name.prefix(1).uppercased())
                            .foregroundStyle(.white)
                            .font(.system(size: 50 * 0.4, weight: .semibold))
                    )
            }

            VStack(alignment: .leading) {
                Text(user.name)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)

                if let username = user.username {
                    Text(username)
                        .foregroundStyle(.gray)
                        .font(.system(size: 13))
                }
            }

            Spacer()

            Button {
                guard let uid = viewModel.userSession?.uid else { return }
                Task { await friendsVM.acceptRequest(from: user, currentUID: uid) }
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
                    .frame(width: 70, height: 32)
                    .overlay(
                        Text("Accept")
                            .foregroundStyle(.black)
                            .font(.system(size: 13, weight: .semibold))
                    )
            }

            Button {
                guard let uid = viewModel.userSession?.uid else { return }
                Task { await friendsVM.declineRequest(from: user, currentUID: uid) }
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
                    .font(.system(size: 16))
                    .padding(.leading, 4)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }

    private var inviteCard: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(height: 65)
            .foregroundStyle(Color(red: 40/255, green: 40/255, blue: 35/255))
            .overlay(
                HStack {
                    if let imageUrl = viewModel.currentUser?.profileImageUrl,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Circle().foregroundStyle(.gray.opacity(0.1))
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    } else {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.gray.opacity(0.1))
                            .overlay(
                                Text(viewModel.currentUser?.name.prefix(1).uppercased() ?? "")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 40 * 0.45, weight: .semibold))
                            )
                    }

                    VStack(alignment: .leading) {
                        Text("Invite friends to TrueCam")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)

                        if let username = viewModel.currentUser?.username {
                            Text("TrueCam/\(username)")
                                .foregroundStyle(.gray)
                        }
                    }

                    Spacer()

                    ShareLink(item: shareURL) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                    }
                }
                .padding(.horizontal)
            )
            .padding(.horizontal)
    }

    private var shareURL: URL {
        URL(string: "https://truecam.app/\(viewModel.currentUser?.username ?? "")") ?? URL(string: "https://truecam.app")!
    }
}
