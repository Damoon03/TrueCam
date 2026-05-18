//
//  LeftMenu.swift
//  TrueCam
//
//  Created by Damoon saber on 2/28/1405 AP.
//

import SwiftUI

struct LeftMenu: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            LeftMenuTopView()
        }
    }
}

#Preview {
    LeftMenu()
}
