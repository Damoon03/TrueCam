//
//  FeedCell.swift
//  TrueCam
//

import SwiftUI

struct FeedCell: View {
    let post: Post
    let currentUID: String
    let onLike: () -> Void
    let onComment: () -> Void

    private var isLiked: Bool { post.likes.contains(currentUID) }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading) {

                // MARK: - Header
                HStack {
                    if let url = post.ownerProfileImageUrl.flatMap({ URL(string: $0) }) {
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
                                Text(post.ownerName.prefix(1).uppercased())
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18, weight: .semibold))
                            )
                    }

                    VStack(alignment: .leading) {
                        Text(post.ownerName)
                            .foregroundStyle(.white)
                            .font(.system(size: 16))

                        Text(post.timestamp.timeAgoDisplay())
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                    }
                }
                .padding(.horizontal)

                // MARK: - Dual Photos (BeReal style)
                ZStack {
                    // Back camera image (main)
                    AsyncImage(url: URL(string: post.backImageUrl)) { image in
                        image.resizable().scaledToFit().cornerRadius(20)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.gray.opacity(0.15))
                            .frame(height: 400)
                    }
                    .padding(.top, 40)

                    // Front camera image (small overlay)
                    VStack {
                        HStack {
                            AsyncImage(url: URL(string: post.frontImageUrl)) { image in
                                image.resizable().scaledToFit().cornerRadius(8)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.black)
                            }
                            .frame(width: 100, height: 130)
                            .border(.black, width: 2)
                            .cornerRadius(8)
                            .padding(.leading)

                            Spacer()
                        }
                        .padding(.top, 55)
                        Spacer()
                    }

                    // Like / Comment buttons
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(spacing: 12) {
                                Button(action: onLike) {
                                    VStack(spacing: 4) {
                                        Image(systemName: isLiked ? "heart.fill" : "heart")
                                            .foregroundStyle(isLiked ? .red : .white)
                                            .font(.system(size: 25))
                                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                                        Text("\(post.likeCount)")
                                            .foregroundStyle(.white)
                                            .font(.caption)
                                    }
                                }

                                Button(action: onComment) {
                                    VStack(spacing: 4) {
                                        Image(systemName: "bubble.left.fill")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 21))
                                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                                        Text("\(post.commentCount)")
                                            .foregroundStyle(.white)
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 55)
                        }
                    }
                }

                // MARK: - Caption
                if let caption = post.caption, !caption.isEmpty {
                    Text(caption)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                }

                if let location = post.location, !location.isEmpty {
                    Text(location)
                        .foregroundStyle(.gray)
                        .font(.system(size: 12))
                        .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 600)
        }
    }
}

// MARK: - Date helper
extension Date {
    func timeAgoDisplay() -> String {
        let seconds = Int(Date().timeIntervalSince(self))
        switch seconds {
        case ..<60:       return "just now"
        case ..<3600:     return "\(seconds / 60)m ago"
        case ..<86400:    return "\(seconds / 3600)h ago"
        default:          return "\(seconds / 86400)d ago"
        }
    }
}
