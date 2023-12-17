//
//  CardView.swift
//  Flashify
//
//  Created by Jason Huynh 12/02/23.
//

import SwiftUI

struct CardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var deck: Deck
    
    @State var frontDegree = 0.0
    @State var backDegree = 90.0
    @State var isFlipped = false
    @State var cardNum = 0
    
    let durationAndDelay: CGFloat = 0.2
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if (deck.cards.count > 0) {
                    ZStack {
                        CardFrontView(degree: $frontDegree, textContent: deck.cards[cardNum].frontText)
                        CardBackView(degree: $backDegree, textContent: deck.cards[cardNum].backText)
                    }.onTapGesture {
                        flipCard()
                    }
                } else {
                    CardBackView(degree: $frontDegree, textContent: "No Cards Available")
                }
                Spacer()
                cardNavigation
            }
            .navigationTitle(deck.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        reset()
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                            .font(.system(size: 25))
                    }
                }
            }
        }
    }
    

    
    private var cardNavigation: some View {
        HStack {
            if cardNum > 0 && deck.cards.count > 0 {
                Button(action: {
                    if !isFlipped {
                        flipCard()
                    }
                    cardNum -= 1
                }){
                    Text("< Prev")
                }.frame(maxWidth: .infinity)
            } else {
                Text("< Prev")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
            }
            
            Text("\(cardNum + 1) of \(deck.cards.count)").foregroundColor(.gray)
            
            if cardNum < (deck.cards.count - 1) && deck.cards.count > 0{
                Button(action: {
                    if !isFlipped {
                        flipCard()
                    }
                    cardNum += 1
                }){
                    Text("Next >")
                }.frame(maxWidth: .infinity)
            } else {
                Text("Next >")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func flipCard() {
        isFlipped.toggle()
        
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 0
            }
        }
    }
    
    private func reset() {
        frontDegree = 0.0
        backDegree = 90.0
        isFlipped = false
        cardNum = 0
    }
}
