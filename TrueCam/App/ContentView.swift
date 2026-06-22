//
//  ContentView.swift
//  TrueCam
//

import SwiftUI

struct ContentView: View {

    init() {
        UITextView.appearance().backgroundColor = .clear
    }

    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }

    @State var selection = 1

    @EnvironmentObject var viewModel: AuthenticationViewModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            TabView(selection: $selection) {

                LeftMenu(selection: $selection)
                    .tag(0)

                FeedView(selection: $selection)
                    .tag(1)

                Profile(selection: $selection)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selection) { oldValue, newValue in
                simpleSuccess()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationViewModel())
}
