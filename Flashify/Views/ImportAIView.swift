//
//  ImportAIView.swift
//  Flashify
//
//  Created by Jason Huynh on 12/2/23.
//

import SwiftUI
import SwiftData
import GoogleGenerativeAI

struct ImportAIView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let palmClient = GenerativeLanguage(apiKey: "AIzaSyAqbvBmA3Fn0TdwgHH_UpoKDqHGELoqEi4")
    
    @State private var newDeckName = ""
    @State private var flashcards = [Flashcard]()
    
    @State private var textInput = ""
        
    @State private var generating = false
    @State private var genSuccAlert = false
    @State private var genFailAlert = false
    
    private let failedJSON = """
{
  "ERROR": "AI output not a JSON file"
}
"""
    
    var body: some View {
        
        NavigationStack {
            Form {
                deckInfoSection
                if !generating {
                    genFromTextButton
                    genFromListButton
                } else {
                    loadingButton
                }
            }
            .navigationTitle("FlashifyAI")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Cards Succesfully Generated", isPresented: $genSuccAlert) {
                Button("OK", role: .cancel) { }
            }
            .alert("Cards Failed to Generate. Please try again", isPresented: $genFailAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    @ViewBuilder private var deckInfoSection: some View {
        Section("Deck Name") {
            TextField("", text: $newDeckName)
        }
        Section("Topic") {
            Text("Provide some notes or a comma separated list to generate flashcards from").foregroundColor(.gray)
            TextField("Text Here", text: $textInput, axis: .vertical)
        }
    }
    
    private var genFromTextButton: some View {
        Button(action: {
            Task {
                let prompt = "I am trying to create flashcards to study with. Pick as most key ideas you can from the following paragraph and ask a question about that topic or keep just the topic. Return strictly a JSON object and remove anything that's not within the { and } of the JSON format. The key of the JSON object is the question or topic and the value is a graduate level answer of the question. The definition or answer may include extra knowledge outside of the provided paragraph and should be a few sentences long.  Here is the paragraph: + \(textInput)"
                do {
                    generating = true
                    let response = try? await palmClient.generateText(with: prompt)
                    if let candidate = response?.candidates?.first, let text = candidate.output {
                        print(text)
                        let text = JSONFilter(input: text)
                        print(text)
                        if let jsonData = text.data(using: .utf8) {
                            do {
                                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] {
                                    for (key, value) in jsonDict {
                                        let newCard = Flashcard(frontText: key, backText: value, tag: "")
                                        flashcards.append(newCard)
                                    }
                                }
                            }
                        }
                        let newDeck = Deck(name: newDeckName, cards: flashcards)
                        modelContext.insert(newDeck)
                        flashcards = [Flashcard]()
                        genSuccAlert = true
                        generating = false
                    }
                } catch {
                    genFailAlert = true
                    generating = false
                }
            }
        }) {
            HStack {
                Spacer()
                Text("Import from Text")
                    .font(.title3)
                Spacer()
            }
            .foregroundStyle(.white).bold()
            .frame(height: 40)
        }
        .listRowBackground(Color.green)
    }
    
    private var genFromListButton: some View {
        Button(action: {
            Task {
                let prompt = "I am trying to create flashcards to study with. I will be providing a comma separated list of topics that I want to make about. For each topic in the list, return strictly a JSON object and remove anything that's not within { and }. The JSON key must be the topic provided and the JSON value should be a graduate level definition or answer of the topic. The definition should be a 3 or more sentences long. If a topic is unknown, then ignore and skip that topic in the list. Here is the list: + \(textInput)"
                do {
                    generating = true
                    let response = try? await palmClient.generateText(with: prompt)
                    if let candidate = response?.candidates?.first, let text = candidate.output {
                        print(text)
                        let text = JSONFilter(input: text)
                        print(text)
                        if let jsonData = text.data(using: .utf8) {
                            do {
                                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] {
                                    for (key, value) in jsonDict {
                                        let newCard = Flashcard(frontText: key, backText: value, tag: "")
                                        flashcards.append(newCard)
                                    }
                                }
                            }
                        }
                        let newDeck = Deck(name: newDeckName, cards: flashcards)
                        modelContext.insert(newDeck)
                        flashcards = [Flashcard]()
                        genSuccAlert = true
                        generating = false
                    }
                } catch {
                    genFailAlert = true
                    generating = false
                }
            }
        }) {
            HStack {
                Spacer()
                Text("Import from List")
                    .font(.title3)
                Spacer()
            }
            .foregroundStyle(.white).bold()
            .frame(height: 40)
        }
        .listRowBackground(Color.blue)
    }
    
    private var loadingButton: some View {
        Button(action: {
            
        }) {
            HStack {
                Spacer()
                Text("Generating Cards...")
                    .font(.title2)
                Spacer()
            }
            .foregroundStyle(.white).bold()
            .frame(height: 100)
        }
        .listRowBackground(Color.gray)
    }
    
    func JSONFilter(input: String) -> String {
        if let startIndex = input.firstIndex(of: "{"), 
            let endIndex = input.firstIndex(of: "}") {
            return String(input[startIndex...endIndex])
        } else if let endIndex = input.firstIndex(of: "}") {
            return "{" + String(input[...endIndex])
        } else if let startIndex = input.firstIndex(of: "{") {
            return String(input[startIndex...]) + "}"
        } else {
            return failedJSON
        }
    }
}

#Preview {
    ImportAIView()
        .modelContainer(for: [Deck.self, Flashcard.self])
}
