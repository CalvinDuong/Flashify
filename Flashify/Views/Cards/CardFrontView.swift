//
//  CardFrontView.swift
//  flashify
//
//  Created by Jason Huynh on 12/1/23.
//

import SwiftUI

struct CardFrontView: View {
    @Binding var degree : Double
    let textContent: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.black.opacity(0.9))
                .frame(height: 300)
                .padding()

            Text(textContent)
                .lineLimit(10)
                .foregroundColor(.white)
                .font(.system(size: 30, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(30)
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 1.0, y: 0.0, z: 0.0))
    }
}
