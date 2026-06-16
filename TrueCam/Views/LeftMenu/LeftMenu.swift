//
//  LeftMenu.swift
//  TrueCam
//

import SwiftUI

struct LeftMenu: View {

    @State var menu = "suggestions"
    @Binding var selection: Int

    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject private var friendsVM = FriendsViewModel()
    @State private var searchText = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            LeftMenuTopView(searchText: $searchText, selection: $selection)

            if !searchText.isEmpty {
                SearchResultsView(friendsVM: friendsVM)
            } else if menu == "suggestions" {
                Suggestions(friendsVM: friendsVM)
            } else if menu == "friends" {
                FriendsView(friendsVM: friendsVM)
            } else if menu == "requests" {
                RequestsView(friendsVM: friendsVM)
            }

            if searchText.isEmpty {
                VStack {
                    Spacer()

                    ZStack {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .containerRelativeFrame(.horizontal) { width, _ in
                                        width * 0.7
                                    }
                                    .frame(height: 40)
                                    .foregroundStyle(Color(red: 20/255, green: 20/255, blue: 20/255))

                                HStack(spacing: 4) {

                                    Capsule()
                                        .frame(width: 100, height: 28)
                                        .foregroundStyle(Color(red: 46/255, green: 46/255, blue: 48/255))
                                        .opacity(menu == "suggestions" ? 1 : 0)
                                        .overlay(
                                            Text("Suggestions")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14))
                                        )
                                        .onTapGesture {
                                            withAnimation(.linear(duration: 0.25)) {
                                                self.menu = "suggestions"
                                            }
                                        }

                                    Capsule()
                                        .frame(width: 70, height: 28)
                                        .foregroundStyle(Color(red: 46/255, green: 46/255, blue: 48/255))
                                        .opacity(menu == "friends" ? 1 : 0)
                                        .overlay(
                                            Text("Friends")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14))
                                        )
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.25)) {
                                                self.menu = "friends"
                                            }
                                        }

                                    Capsule()
                                        .frame(width: 75, height: 28)
                                        .foregroundStyle(Color(red: 46/255, green: 46/255, blue: 48/255))
                                        .opacity(menu == "requests" ? 1 : 0)
                                        .overlay(
                                            ZStack {
                                                Text("Requests")
                                                    .foregroundStyle(.white)
                                                    .font(.system(size: 14))

                                                if friendsVM.friendRequests.count > 0 {
                                                    HStack {
                                                        Spacer()
                                                        Circle()
                                                            .fill(.red)
                                                            .frame(width: 8, height: 8)
                                                            .offset(x: -6, y: -8)
                                                    }
                                                }
                                            }
                                        )
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.25)) {
                                                self.menu = "requests"
                                            }
                                        }

                                }
                                .animation(.easeInOut(duration: 0.25), value: menu)

                            }

                        }
                        .zIndex(1)
                        LinearGradient(colors: [.black, .white.opacity(0)], startPoint: .bottom, endPoint: .top)
                            .ignoresSafeArea()
                            .frame(height: 60)
                            .opacity(0.9)

                    }
                }
            }
        }
        .onChange(of: searchText) { _, newValue in
            guard let user = viewModel.currentUser else { return }
            Task { await friendsVM.search(query: newValue, currentUser: user) }
        }
        .task {
            if let user = viewModel.currentUser {
                await friendsVM.loadAll(currentUser: user)
            }
        }
        .onChange(of: viewModel.currentUser?.id) { _, _ in
            if let user = viewModel.currentUser {
                Task { await friendsVM.loadAll(currentUser: user) }
            }
        }
    }
}
