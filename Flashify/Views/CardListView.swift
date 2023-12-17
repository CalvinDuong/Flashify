//
//  CardView.swift
//  Flashify
//
//  Created by Jason Huynh 12/02/23.
//

import SwiftUI

struct CardListView: View {
    var card: Flashcard
    var body: some View {
        HStack {
            Text((card.frontText.count > 18) ? card.frontText.prefix(15) + "...": card.frontText)
            Spacer()
            Text((card.backText.count > 18) ? card.backText.prefix(15) + "...": card.backText)
        }
    }
}

struct CreateCardView: View {
    var card: Flashcard
    @Binding var flashcards: [Flashcard]
    
    var body: some View {
        HStack {
            CardListView(card: card)
            
            Button(action: {
                if let removeIndex = flashcards.firstIndex(of: card) {
                    flashcards.remove(at: removeIndex)
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundStyle(.red)
            }
        }
    }
}
