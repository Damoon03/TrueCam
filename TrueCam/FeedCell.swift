//
//  FeedCell.swift
//  TrueCam
//
//  Created by Damoon saber on 2/20/1405 AP.
//

import SwiftUI

struct FeedCell: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
               
                ZStack {
                    VStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                    }
                    
                    VStack {
                        HStack {
                            
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    FeedCell()
}
