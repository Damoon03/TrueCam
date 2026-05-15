//
//  Settings.swift
//  TrueCam
//
//  Created by Damoon saber on 2/25/1405 AP.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                // MARK: - Header
                HStack {
                    Image(systemName: "arrow.backward")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 20))

                    Spacer()

                    Text("Settings")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .font(.system(size: 18))

                    Spacer()

                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .opacity(0) 
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)

                // MARK: - Profile Card
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white.opacity(0.07))
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width * 0.9
                    }
                    .frame(height: 90)
                    .overlay(
                        HStack {
                            Image("profile")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())

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

                // MARK: - Features Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("FEATURES")
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                        .font(.system(size: 12))
                        .padding(.horizontal, 22)

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
                .padding(.top, 8)

                Spacer()
            }
        }
    }
}

#Preview {
    Settings()
}
