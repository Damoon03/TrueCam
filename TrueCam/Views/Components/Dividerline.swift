//
//  Dividerline.swift
//  TrueCam
//
//  Created by Damoon saber on 2/27/1405 AP.
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
