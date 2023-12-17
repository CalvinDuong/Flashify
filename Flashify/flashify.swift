//
//  flashify.swift
//  Flashify
//
//  Created by Jason Huynh 12/02/23.
//

import SwiftUI

@main
struct flashify: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Deck.self, Flashcard.self])
        }
    }
}
