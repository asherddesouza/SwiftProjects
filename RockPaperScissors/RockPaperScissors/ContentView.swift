//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Asher De Souza on 30/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var CPUSelection = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var gameEnd = false
    @State private var userScore = 0
    @State private var roundCount = 1
    
    let options = ["Rock", "Paper", "Scissors"]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea()
            
            VStack {
                Text("The CPU has chosen \(options[CPUSelection])")
                HStack(spacing: 0) {
                    Text("and you need to ")
                    Text("\(shouldWin == true ? "win" : "lose").")
                        .foregroundStyle(shouldWin == true ? .green : .red)
                }
                
                Text(" ")
                
                HStack(spacing: 20) {
                    Button("🪨") {
                        buttonTapped(0)
                    }
                    
                    Button("🧻") {
                        buttonTapped(1)
                    }
                    
                    Button("✂️") {
                        buttonTapped(2)
                    }
                }
                .font(.system(size: 60))
                
                
                Text(" ")
                
                Text("Your current score is \(userScore)")
                Text(" ")
                Text("Round \(roundCount)")
            }
            .bold()
            .font(.system(size: 25))
            .foregroundStyle(.white)
        }
        .alert("Game Finished", isPresented: $gameEnd) {
            Button("Restart Game", action: resetGame)
        } message: {
            Text("Your final score was \(userScore)")
        }
    }
    
    func buttonTapped(_ selection: Int) {
        switch selection {
        case 0: //User Rock
            switch CPUSelection {
            case 0: //Rock
                if shouldWin == false {
                    userScore += 1
                }
                newRound()
            case 1: //Paper
                if shouldWin == false {
                    userScore += 1
                }
                newRound()
            case 2: //Scissors
                if shouldWin == true {
                    userScore += 1
                }
                newRound()
            default:
                ()
            }
        case 1: //User Paper
            switch CPUSelection {
            case 0: //Rock
                if shouldWin == true {
                    userScore += 1
                }
                newRound()
            case 1: //Paper
                if shouldWin == false {
                    userScore += 1
                }
                newRound()
            case 2: //Scissors
                if shouldWin == false {
                    userScore += 1
                }
                newRound()
            default:
                ()
            }
        case 2: //User Scissors
            switch CPUSelection {
            case 0: //Rock
                if shouldWin == false {
                    userScore += 1
                }
                newRound()
            case 1: //Paper
                if shouldWin == true {
                    userScore += 1
                }
                newRound()
            case 2: //Scissors
                if shouldWin == false {
                    userScore += 1
                }
                newRound()
            default:
                ()
            }
            
        default:
            ()
        }
    }
    
    func newRound(){
        if roundCount == 10 {
            gameEnd = true
        } else {
            roundCount += 1
            CPUSelection = Int.random(in: 0...2)
            shouldWin = Bool.random()
        }
    }
    
    func resetGame(){
        roundCount = 1
        userScore = 0
        CPUSelection = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}

#Preview {
    ContentView()
}
