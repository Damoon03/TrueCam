//
//  SuggestionCellView.swift
//  TrueCam
//

import SwiftUI

struct SuggestionCellView: View {
    let user: User
    let onAdd: () -> Void
    let onDismiss: () -> Void

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
            }

            Spacer()

            Button(action: onAdd) {
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

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
                    .font(.system(size: 16))
                    .padding(.leading, 6)
            }
        }
        .padding(.horizontal)
    }
}
