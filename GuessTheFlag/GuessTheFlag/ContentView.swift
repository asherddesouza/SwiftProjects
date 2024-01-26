//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Asher De Souza on 18/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var userScore = 0
    @State private var scoreTitle = ""
    @State private var selectedNumber = 0
    @State private var gameCompleted = false
    @State private var gameRounds = 1
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .gray], startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea()
            
            VStack {
                Text("Guess the Country")
                    .font(.title.weight(.black))
                    .foregroundStyle(.white)
                
                Spacer().frame(height: 50)
                
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .foregroundStyle(.white)
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.rect(cornerRadii:.init(topLeading: 10, bottomLeading:10, bottomTrailing: 10, topTrailing: 10)))
                                .shadow(radius: 5)
                        }
                    }
                    
                    Text("Score: \(userScore)")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                }
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                if (scoreTitle == "Incorrect"){
                    Text("That's the flag of \(countries[selectedNumber])")
                }
                Text("Your score is: \(userScore)")
            }
            .alert("Game Finished", isPresented: $gameCompleted) {
                Button("Restart Game", action: resetGame)
            } message: {
                Text("Your final score was \(userScore)")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            selectedNumber = number
        } else {
            scoreTitle = "Incorrect"
        }
        
        gameRounds += 1
        
        if gameRounds == 9 {
            gameCompleted = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        gameCompleted = false
        gameRounds = 1
        userScore = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
