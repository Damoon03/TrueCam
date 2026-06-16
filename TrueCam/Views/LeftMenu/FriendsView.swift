//
//  FriendsView.swift
//  TrueCam
//

import SwiftUI
import FirebaseAuth

struct FriendsView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var friendsVM: FriendsViewModel

    var body: some View {
        VStack {
            ScrollView {
                inviteCard

                VStack {
                    HStack {
                        Text("MY FRIENDS (\(friendsVM.friends.count))")
                            .foregroundStyle(Color(red: 205/255, green: 204/255, blue: 209/255))
                            .fontWeight(.semibold)
                            .font(.system(size: 14))
                            .padding(.horizontal)
                            .padding(.bottom, 10)

                        Spacer()
                    }

                    if friendsVM.isLoading {
                        ProgressView().tint(.white)
                            .padding(.top, 20)
                    } else if friendsVM.friends.isEmpty {
                        Text("You haven't added any friends yet")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                            .padding(.top, 12)
                    } else {
                        ForEach(friendsVM.friends) { friend in
                            FriendCellView(user: friend) {
                                guard let uid = viewModel.userSession?.uid else { return }
                                Task { await friendsVM.removeFriend(friend, currentUID: uid) }
                            }
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
