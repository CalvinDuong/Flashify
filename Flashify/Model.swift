//
//  Model.swift
//  Flashify
//
//  Created by Jason Huynh 12/02/23.
//

import Foundation
import SwiftData

@Model
class Deck {
    var name: String
    var cards: [Flashcard]
    
    init(name: String, cards: [Flashcard]) {
        self.name = name
        self.cards = cards
    }
}

@Model
class Flashcard {
    var frontText: String
    var backText: String
    var tag: String
    
    init(frontText: String, backText: String, tag: String) {
        self.frontText = frontText
        self.backText = backText
        self.tag = tag
    }
}
