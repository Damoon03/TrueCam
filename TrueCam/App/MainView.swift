//
//  MainView.swift
//  TrueCam
//

import SwiftUI
import Combine

struct MainView: View {

    @EnvironmentObject var viewModel: AuthenticationViewModel

    var body: some View {
        Group {
            if viewModel.userSession == nil {
                MainAuthenticationView()
            } else {
                ContentView()
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthenticationViewModel())
}
