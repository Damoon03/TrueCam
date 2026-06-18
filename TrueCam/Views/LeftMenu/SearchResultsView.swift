//
//  SearchResultsView.swift
//  TrueCam
//

import SwiftUI
import FirebaseAuth

struct SearchResultsView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var friendsVM: FriendsViewModel

    var body: some View {
        ScrollView {
            VStack {
                if friendsVM.searchResults.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.2))
                        Text("No users found")
                            .foregroundStyle(.white.opacity(0.4))
                            .font(.subheadline)
                    }
                    .padding(.top, 60)
                } else {
                    ForEach(friendsVM.searchResults) { user in
                        resultRow(for: user)
                    }
                }
            }
            .padding(.top)
        }
        .padding(.top, 110)
    }

    @ViewBuilder
    private func resultRow(for user: User) -> some View {
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

            statusButton(for: user)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }

    private func statusButton(for user: User) -> AnyView {
        guard let currentUID = viewModel.userSession?.uid,
              let targetUID = user.id,
              let currentUser = viewModel.currentUser else {
            return AnyView(EmptyView())
        }

        if currentUser.friendUIDs.contains(targetUID) {
            return AnyView(
                Text("Friends")
                    .foregroundStyle(.gray)
                    .font(.system(size: 13))
            )
        } else if currentUser.friendRequestsSent.contains(targetUID) {
            return AnyView(
                Text("Requested")
                    .foregroundStyle(.gray)
                    .font(.system(size: 13))
            )
        } else {
            return AnyView(
                Button {
                    Task { await friendsVM.sendRequest(to: user, currentUID: currentUID) }
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(red: 44/255, green: 44/255, blue: 46/255))
                        .frame(width: 45, height: 25)
                        .overlay(
                            Text("ADD")
                                .foregroundStyle(.white)
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                        )
                }
            )
        }
    }
}
