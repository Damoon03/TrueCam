//
//  TimeZoneView.swift
//  TrueCam
//

import SwiftUI
import FirebaseAuth

struct TimeZoneView: View {

    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var area = "europe"
    @State private var initialArea = "europe"
    @State private var isSaving = false
    @State private var isLoading = true
    @Environment(\.dismiss) var dismiss

    private var hasChanges: Bool { area != initialArea }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                ZStack {
                    Text("Time Zone")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)

                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        }

                        Spacer()
                    }
                }
                .padding(.horizontal)

                Spacer()

            }

            VStack {
                VStack {
                    HStack {
                        Text("Select your Time Zone")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 20))

                        Spacer()

                    }

                    Text("To receive your TrueCam notification during daytime, select your time zone. When changing your time zone, your current TrueCam will be deleted. You can only change time zones once a day.")
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .padding(.top, 3)

                }
                .padding()

                if isLoading {
                    ProgressView().tint(.white)
                    Spacer()
                } else {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.white.opacity(0.07))
                                .containerRelativeFrame(.horizontal) { width, _ in
                                    width * 0.9
                                }
                                .frame(height: 190)

                                .overlay (
                                    VStack {
                                        areaRow(icon: "globe.europe.africa.fill", title: "Europe", value: "europe", topPadding: 8, bottomPadding: 0)

                                        DividerLine()

                                        areaRow(icon: "globe.americas.fill", title: "Americas", value: "americas", topPadding: 5, bottomPadding: 5)

                                        DividerLine()

                                        areaRow(icon: "globe.asia.australia.fill", title: "East Asia", value: "eastasia", topPadding: 5, bottomPadding: 5)

                                        DividerLine()

                                        areaRow(icon: "globe.asia.australia.fill", title: "West Asia", value: "westasia", topPadding: 4, bottomPadding: 8)
                                    }
                                )
                        }

                        Spacer()

                        Button {
                            Task { await save() }
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(hasChanges ? .white : .gray.opacity(0.6))
                                .containerRelativeFrame(.horizontal) { width, _ in
                                    width * 0.9
                                }
                                .frame(height: 45)
                                .overlay(
                                    Group {
                                        if isSaving {
                                            ProgressView().tint(.black)
                                        } else {
                                            Text("Save")
                                                .foregroundStyle(.black)
                                        }
                                    }
                                )
                        }
                        .disabled(!hasChanges || isSaving)
                        .padding(.bottom)

                    }
                }

            }
            .padding(.vertical, 50)
        }
        .task {
            await load()
        }
    }

    @ViewBuilder
    private func areaRow(icon: String, title: String, value: String, topPadding: CGFloat, bottomPadding: CGFloat) -> some View {
        Button {
            self.area = value
        } label: {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.white)

                Text(title)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)

                Spacer()

                if area == value {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(.gray)
                }

            }
            .padding(.horizontal)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
        }
    }

    private func load() async {
        defer { isLoading = false }
        guard let uid = viewModel.userSession?.uid else { return }
        do {
            let snapshot = try await Firestore_TimeZonePrefs.fetch(uid: uid)
            area = snapshot
            initialArea = snapshot
        } catch { }
    }

    private func save() async {
        guard let uid = viewModel.userSession?.uid else { return }
        isSaving = true
        defer { isSaving = false }
        do {
            try await Firestore_TimeZonePrefs.save(uid: uid, area: area)
            initialArea = area
        } catch {
            print("Failed to save timezone:", error.localizedDescription)
        }
    }
}

#Preview {
    TimeZoneView()
        .environmentObject(AuthenticationViewModel())
}
