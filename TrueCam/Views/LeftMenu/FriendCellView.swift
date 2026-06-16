//
//  FriendCellView.swift
//  TrueCam
//

import SwiftUI

struct FriendCellView: View {
    let user: User
    let onRemove: () -> Void

    var body: some View {
        HStack {
            if let imageUrl = user.profileImageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Circle().foregroundStyle(.gray.opacity(0.1))
                }
                .frame(width: 65, height: 65)
                .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 65, height: 65)
                    .foregroundStyle(.gray.opacity(0.1))
                    .overlay(
                        Text(user.name.prefix(1).uppercased())
                            .foregroundStyle(.white)
                            .font(.system(size: 65 * 0.4, weight: .semibold))
                    )
            }

            VStack(alignment: .leading) {
                Text(user.name)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)

                if let username = user.username {
                    Text(username)
                        .foregroundStyle(.gray)
                        .padding(.top, -10)
                }

                if let location = user.location {
                    HStack {
                        Image(systemName: "location")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))

                        Text(location)
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                            .padding(.leading, -4)
                    }
                }
            }

            Spacer()

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
                    .font(.system(size: 16))
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}
