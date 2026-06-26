# TrueCam

> A BeReal-inspired photo sharing app for iOS — capture authentic, simultaneous front and back camera moments and share them with friends in real time.

---

## Overview

TrueCam is an iOS social photo app built with Swift and SwiftUI. Inspired by BeReal, it challenges users to capture genuine moments using both the front and back cameras simultaneously. Posts are shared with a friends network, and memories are preserved in a personal grid — an authentic visual diary with no filters, no curation.

---

## Features

- **Dual Camera Capture** — Simultaneously captures front and back camera photos in a single tap, mirroring the BeReal experience
- **Real-Time Feed** — A Firestore-backed social feed that updates live as friends post
- **Likes & Comments** — React to and comment on posts in real time
- **Friends System** — Send and accept friend requests; your feed only shows people you're connected with
- **Memories Grid** — A personal archive of all your past TrueCam moments
- **User Profiles** — Customizable profiles with post history and friend counts
- **Authentication** — Secure sign-up and login via Firebase Auth
- **Preference Persistence** — User settings and preferences saved locally across sessions

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift |
| UI Framework | SwiftUI |
| Architecture | MVVM |
| Backend | Firebase (Firestore, Auth, Storage) |
| Camera | AVFoundation |
| Minimum Target | iOS 17+ |

---

## Architecture

TrueCam follows a clean **MVVM** architecture with protocol-based service injection for testability and separation of concerns.

```
TrueCam/
├── Models/             # Data models (Post, User, Comment, etc.)
├── ViewModels/         # Business logic (FeedViewModel, ProfileViewModel, FriendsViewModel, etc.)
├── Views/              # SwiftUI views and screens
├── Services/           # Firebase service abstractions
│   ├── FirestoreService
│   ├── AuthService
│   └── StorageService
└── Utilities/          # Extensions, helpers
```

Key ViewModels:
- `FeedViewModel` — Manages the real-time Firestore post feed
- `CameraViewModel` / `CameraManager` — Handles AVFoundation dual-camera session
- `FriendsViewModel` — Friend requests and connections
- `ProfileViewModel` — User profile data and post history

---

## Getting Started

### Prerequisites

- Xcode 15+
- iOS 17+ device or simulator
- A Firebase project with Firestore, Auth, and Storage enabled

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Damoon03/TrueCam.git
   cd TrueCam
   ```

2. **Add Firebase configuration**
   - Go to your [Firebase Console](https://console.firebase.google.com/)
   - Download `GoogleService-Info.plist`
   - Drag it into the Xcode project root (ensure "Copy items if needed" is checked)

3. **Configure Firebase**
   Make sure your Firebase project has the following enabled:
   - **Authentication** — Email/Password sign-in
   - **Cloud Firestore** — Database for posts, users, comments
   - **Firebase Storage** — Photo uploads

4. **Open and run**
   ```bash
   open TrueCam.xcodeproj
   ```
   Select your target device and hit **Run** (`⌘R`).

---

## Camera Note

Simultaneous front and back camera capture requires a **physical iOS device** (iPhone XS or later recommended). The simulator does not support real camera hardware.

---

## Firestore Data Model

```
users/
  {userId}/
    username, profileImageURL, friendCount, ...

posts/
  {postId}/
    userId, frontImageURL, backImageURL, timestamp, likesCount
    comments/ {commentId}/
      userId, text, timestamp

friendRequests/
  {requestId}/
    fromUserId, toUserId, status
```

---

## Roadmap

- [ ] Push notifications for new posts and friend requests
- [ ] Daily TrueCam prompt / challenge
- [ ] Reaction emojis on posts
- [ ] Stories / ephemeral posts
- [ ] Explore / discover page

---

## License

This project is for portfolio and educational purposes.

---

## Author

**Damoon** — iOS Developer  
[GitHub](https://github.com/Damoon03)
