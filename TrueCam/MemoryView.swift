//
//  MemoryView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/24/1405 AP.
//

import SwiftUI

struct MemoryView: View {
    var day: Int

    var body: some View {
        ZStack {
            Text("\(day)")
                .foregroundStyle(.white)
                .zIndex(1)

            Image("back")
                .resizable()
                .containerRelativeFrame(.horizontal) { width, _ in
                    width / 8
                }
                .frame(height: 70)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.white, lineWidth: 1)
                )
        }
        .frame(height: 70)
    }
}

#Preview {
    MemoryView(day: 1)
}
