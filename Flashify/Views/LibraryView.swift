//
//  Contentview.swift
//  Flashify
//
//  Created by Jason Huynh 12/02/23.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var decks: [Deck]
    
    @State private var isPresentingCreateNewDeckSheet = false
    @State private var isPresentingDeck = false
    @State var isInEditMode = false
    @State private var selectedDeck: Deck? = nil

    
    var body: some View {
        NavigationStack {
            Group {
                if decks.isEmpty {
                    Text("No Decks")
                        .font(.title).bold()
                        .foregroundStyle(.gray)
                } else {
                    decksList
                }
            }
            .navigationTitle("My Decks")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isInEditMode.toggle()
                        }
                    }) {
                        Text(isInEditMode ? "Done" : "Edit")
                    }
                    
                    Button(action: {
                        isPresentingCreateNewDeckSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingCreateNewDeckSheet) {
                CreateNewDeckView()
            }
        }
        
        
    }
    
    private var decksList: some View {

        List(decks) { deck in
            DisclosureGroup(
                content: {
                    ForEach(deck.cards) { card in
                        CardListView(card: card)
                    }
                },
                label: {
                    HStack {
                        if isInEditMode {
                            Button(action: {
                                modelContext.delete(deck)
                            }) {
                                HStack {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundStyle(.red)
                                    .font(.system(size: 25))
                                    Text(deck.name)
                                        .font(.title)
                                }
                            }
                        } else {
                            Button(action: {
                                selectedDeck = deck
                                isPresentingDeck.toggle()
                            }) {
                                Text(deck.name)
                                    .font(.title)
                            }
                        }
                    }
                }
            )
            .sheet(isPresented: $isPresentingDeck) {
                if let selectedDeck = selectedDeck {
                        CardView(deck: selectedDeck)
                } else {
                    CardView(deck: deck)
                }
            }
        }
    }
}


#Preview {
    LibraryView()
        .modelContainer(for: [Deck.self, Flashcard.self])
}
