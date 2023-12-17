//
//  ContentView.swift
//  Flashify
//
//  Created by Jason Huynh on 12/2/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "list.dash")
                }
            ImportAIView()
                .tabItem {
                    Label("ImportAI", systemImage: "list.dash")
                }
        }
        .modelContainer(for: [Deck.self, Flashcard.self])
    }
}

#Preview {
    ContentView().modelContainer(for: [Deck.self, Flashcard.self])
}
