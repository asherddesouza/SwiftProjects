//
//  ContentView.swift
//  WordScramble
//
//  Created by Asher De Souza on 06/02/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var userScore = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section("Score: \(userScore)") {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            if word.count <= 50 {
                                Image(systemName: "\(word.count).circle")
                            } else {
                                Text("\(word.count)")
                            }
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK"){ }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("New Word", action: startGame)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isMoreThanTwoLetters(word: answer) else {
            wordError(title: "Word is too short.", message: "Minimum 3 characters.")
            return
        }
        
        guard isNotStartingWord(word: answer) else {
            wordError(title: "Word can't be the same as starting word", message: "That would be cheating.")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already.", message: "No duplicates allowed!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word isn't real.", message: "That word doesn't exist!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible.", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        userScore += 1
        
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "fortnite"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isMoreThanTwoLetters(word: String) -> Bool {
        return word.count >= 3 ? true : false
    }
    
    func isNotStartingWord(word: String) -> Bool {
        return word != rootWord ? true : false
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
