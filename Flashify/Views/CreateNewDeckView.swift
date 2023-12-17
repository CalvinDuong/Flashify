//
//  CreateNewDeckView.swift
//  Flashify
//
//  Created by Jason Huynh 12/02/23.
//

import SwiftUI

struct CreateNewDeckView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var newDeckName = ""
    @State private var flashcards = [Flashcard]()
    
    @State private var isPresentingAddCardAlert = false
    @State private var newFrontText = ""
    @State private var newBackText = ""
    @State private var newTag = ""
    
    
    var body: some View {
        NavigationStack {
            Form {
                deckInfoSection
                flashcardsSection
                saveDeckButton
            }
            .navigationTitle("Add New Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                            .font(.system(size: 25))
                    }
                }
            }
            .alert("Add Card", isPresented: $isPresentingAddCardAlert) {
                TextField("Term", text: $newFrontText)
                TextField("Define", text: $newBackText)
                TextField("Tag", text: $newTag)
                Button(action: {
                    let newCard = Flashcard(frontText: newFrontText, backText: newBackText, tag: newTag)
                    flashcards.append(newCard)
                    newFrontText = ""
                    newBackText = ""
                    newTag = ""
                }) {
                    Text("Add")
                }
            } message: {}
        }
    }
    
    @ViewBuilder private var deckInfoSection: some View {
        Section("Deck Name") {
            TextField("", text: $newDeckName)
        }
    }
    
    private var flashcardsSection: some View {
        Section("Flashcards") {
            if flashcards.isEmpty {
                Text("No Flashcards")
            } else {
                List(flashcards) { card in
                    CreateCardView(card: card, flashcards: $flashcards)
                }
            }
            
            HStack {
                Button(action: {
                    isPresentingAddCardAlert.toggle()
                }) {
                    Text("Add Card")
                        .foregroundStyle(.green)
                }
                Spacer()
            }
        }
    }
    
    private var saveDeckButton: some View {
        Button(action: {
            let newDeck = Deck(name: newDeckName, cards: flashcards)
            modelContext.insert(newDeck)
            dismiss()
        }) {
            HStack {
                Spacer()
                Text("Save")
                    .font(.title2)
                Spacer()
            }
            .foregroundStyle(.white).bold()
            .frame(height: 40)
        }
        .listRowBackground(Color.green)
    }
}

#Preview {
    CreateNewDeckView()
        .modelContainer(for: [Deck.self, Flashcard.self])
}
