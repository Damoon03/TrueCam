//
//  Dividerline.swift
//  TrueCam
//

import SwiftUI

struct DividerLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.35))
            .frame(height: 0.5)
            .frame(maxWidth: .infinity)
    }
}
