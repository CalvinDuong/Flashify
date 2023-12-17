//
//  CardFrontView.swift
//  flashify
//
//  Created by Jason Huynh on 12/1/23.
//

import SwiftUI

struct CardBackView: View {
    @Binding var degree : Double
    let textContent: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .stroke(.gray, lineWidth: 1)
                .frame(height: 300)
                .padding()

            Text(textContent)
                .lineLimit(10)
                .font(.system(size: 15, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(30)
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 1.0, y: 0.0, z: 0.0))
    }
}
