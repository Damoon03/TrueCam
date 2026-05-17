//
//  ContentView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/20/1405 AP.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
       Feed()
    }
}

#Preview {
    ContentView()
}
