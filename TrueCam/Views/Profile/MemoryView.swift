//
//  MemoryView.swift
//  TrueCam
//

import SwiftUI

struct MemoryView: View {
    var post: Post?
    var placeholderDay: Int?

    var body: some View {
        ZStack {
            if let post, let url = URL(string: post.backImageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle().foregroundStyle(.white.opacity(0.05))
                }
                .containerRelativeFrame(.horizontal) { width, _ in width / 8 }
                .frame(height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.white, lineWidth: 1)
                )
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(.white.opacity(0.05))
                    .containerRelativeFrame(.horizontal) { width, _ in width / 8 }
                    .frame(height: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .overlay(
                        Text(placeholderDay.map(String.init) ?? "")
                            .foregroundStyle(.white.opacity(0.3))
                            .font(.caption2)
                    )
            }
        }
        .frame(height: 70)
    }
}

#Preview {
    MemoryView(placeholderDay: 1)
}
