//
//  NotificationsView.swift
//  TrueCam
//

import SwiftUI
import FirebaseAuth

struct NotificationsView: View {

    @EnvironmentObject var viewModel: AuthenticationViewModel

    @State var mentions = false
    @State var comments = false
    @State var friendRequests = false
    @State var lateTrueCam = false
    @State var realMojis = false

    @State private var initialValues: [Bool] = []
    @State private var buttonActive = false
    @State private var isSaving = false
    @State private var isLoading = true

    @Environment(\.dismiss) var dismiss

    private var currentValues: [Bool] {
        [mentions, comments, friendRequests, lateTrueCam, realMojis]
    }

    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    ZStack {
                        Text("Notifications")
                            .fontWeight(.semibold)

                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            }

                            Spacer()
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .foregroundStyle(.white)

                VStack {

                    VStack {

                        HStack {
                            Text("On TrueCam you're in control of your push notifications.")
                            Spacer()
                        }

                        HStack {
                            Text("You can choose the type of notifications you want to receive.")
                            Spacer()
                        }
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .font(.system(size: 16))

                    if isLoading {
                        ProgressView().tint(.white).padding(.top, 40)
                    } else {
                        VStack(spacing: 14) {

                            VStack {
                                NotificationsViewButton(icon: "person.crop.square.filled.and.at.rectangle", text: "Mentions", toggle: $mentions)

                                HStack {
                                    Text("timcook mentioned you on johnternus's TrueCam.")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 12))
                                        .padding(.leading)

                                    Spacer()
                                }
                            }

                            VStack {
                                NotificationsViewButton(icon: "bubble.left.fill", text: "Comments", toggle: $comments)

                                HStack {
                                    Text("johnmayer commented on your TrueCam.")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 12))
                                        .padding(.leading)

                                    Spacer()
                                }
                            }

                            VStack {
                                NotificationsViewButton(icon: "person.2.fill", text: "Friend Requests", toggle: $friendRequests)

                                HStack {
                                    Text("johnfrusciante just sent you a friend request.")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 12))
                                        .padding(.leading)

                                    Spacer()
                                }
                            }

                            VStack {
                                NotificationsViewButton(icon: "timer", text: "Late TrueCam", toggle: $lateTrueCam)

                                HStack {
                                    Text("chrislattner just posted late.")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 12))
                                        .padding(.leading)

                                    Spacer()
                                }
                            }

                            VStack {
                                NotificationsViewButton(icon: "face.smiling.fill", text: "RealMojis", toggle: $realMojis)

                                HStack {
                                    Text("stevewozniak just reacted to your TrueCam.")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 12))
                                        .padding(.leading)

                                    Spacer()
                                }
                            }

                        }
                        .padding(.top, 8)
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)

                VStack {
                    Spacer()

                    WhiteButtonView(
                        buttonActive: $buttonActive,
                        text: isSaving ? "Saving..." : "Save"
                    ) {
                        Task { await save() }
                    }
                }
                .padding()

            }
        }
        .onChange(of: currentValues) { _, newValue in
            buttonActive = newValue != initialValues
        }
        .task {
            await load()
        }
    }

    private func load() async {
        defer { isLoading = false }
        guard let uid = viewModel.userSession?.uid else { return }

        do {
            let prefs = try await Firestore_NotificationPrefs.fetch(uid: uid)
            mentions = prefs.mentions
            comments = prefs.comments
            friendRequests = prefs.friendRequests
            lateTrueCam = prefs.lateTrueCam
            realMojis = prefs.realMojis
        } catch {
            // Defaults to all-off if no prefs saved yet
        }

        initialValues = currentValues
    }

    private func save() async {
        guard let uid = viewModel.userSession?.uid else { return }
        isSaving = true
        defer { isSaving = false }

        let prefs = NotificationPrefs(
            mentions: mentions,
            comments: comments,
            friendRequests: friendRequests,
            lateTrueCam: lateTrueCam,
            realMojis: realMojis
        )

        do {
            try await Firestore_NotificationPrefs.save(uid: uid, prefs: prefs)
            initialValues = currentValues
            buttonActive = false
        } catch {
            print("Failed to save notification prefs:", error.localizedDescription)
        }
    }
}

#Preview {
    NotificationsView()
        .environmentObject(AuthenticationViewModel())
}
