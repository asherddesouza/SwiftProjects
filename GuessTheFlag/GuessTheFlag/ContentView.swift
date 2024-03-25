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
    
    @State private var rotationAmounts: [Double] = Array(repeating: 0.0, count: 3)
    @State private var opacityAmounts: [Double] = Array(repeating: 1.0, count: 3)
    @State private var scaleAmounts: [Double] = Array(repeating: 1.0, count: 3)
    
    @State private var flagSelected = 0
    
    struct FlagImage: View {
        var countryFlag: String
        
        var body: some View {
            Image(countryFlag)
                .clipShape(.rect(cornerRadii:.init(topLeading: 10, bottomLeading:10, bottomTrailing: 10, topTrailing: 10)))
                .shadow(radius: 5)
        }
    }
    
    
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
                            if flagSelected == number {
                                withAnimation(.bouncy(duration: 1)) {
                                    rotationAmounts[number] += 360
                                }
                            } else {
                                opacityAmounts[number] = 0.25
                                scaleAmounts[number] = 0.8
                            }
                            
                        } label: {
                            FlagImage(countryFlag: countries[number])
                        }
                        .rotation3DEffect(.degrees(rotationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                        .opacity(opacityAmounts[number])
                        .scaleEffect(scaleAmounts[number])
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
            selectedNumber = number
            scoreTitle = "Incorrect"
        }
        
        gameRounds += 1
        
        if gameRounds == 9 {
            gameCompleted = true
        } else {
            showingScore = true
        }
        
        flagSelected = number
        
        for i in 0..<opacityAmounts.count {
            if i == number {
                opacityAmounts[i] = 1.0 // set opacity to 1.0 for the tapped button
            } else {
                opacityAmounts[i] = 0.25 // set opacity to 0.25 for other buttons
            }
        }
        
        for i in 0..<scaleAmounts.count {
            if i == number {
                scaleAmounts[i] = 1.0 // set opacity to 1.0 for the tapped button
            } else {
                scaleAmounts[i] = 0.8 // set opacity to 0.25 for other buttons
            }
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        for i in 0..<opacityAmounts.count {
            opacityAmounts[i] = 1.0 // set opacity to 1.0 for the tapped button
        }
        
        for i in 0..<scaleAmounts.count {
            scaleAmounts[i] = 1.0 // set opacity to 1.0 for the tapped button
        }
        
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
