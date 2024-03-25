//
//  ContentView.swift
//  TimesTablesGame
//
//  Created by Asher De Souza on 13/02/2024.
//

import SwiftUI

struct Question {
    var question: String
    var answer: Int
}

struct ContentView: View {
    @State private var gameplayActive = false // false is setup, true is gameplay
    @State private var gameEnd = false
    
    @State private var selectedTimesTable = 1
    @State private var selectedQuestionCount = 5
    
    @State private var currentQuestion = 0
    @State private var questionSet = [Question(question: "Async Placeholder", answer: 0)]
    @State private var questionResult = false
    @State private var userScore = 0
    
    @State private var showingResult = false
    @State private var alertTitle = ""
    
    @State private var userAnswer = ""
    
    let questionCount = [5, 10, 20]
    let multipliers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    
    var body: some View {
            NavigationStack {
                Form {
                    VStack {
                        Text("Times tables you want to practise")
                        
                        Picker("numberSelection", selection: $selectedTimesTable) {
                            ForEach(1...12, id: \.self) { num in
                                Text("\(num)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack {
                        Text("Select the number of questions")
                        
                        Picker("questionSelection", selection: $selectedQuestionCount) {
                            ForEach(questionCount, id: \.self) { num in
                                Text("\(num)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Button("Done") {
                        gameplayActive.toggle()
                        generateQuestions(selectedQuestionCount)
                    }
                        .navigationDestination(isPresented: $gameplayActive) {
                            ZStack {
                                LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                
                                VStack {
                                    HStack {
                                        Text("Times Table: ×\(selectedTimesTable)")
                                        Text("Question: \(currentQuestion + 1)/\(selectedQuestionCount) ")
                                    }
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .bold()
                                    .padding()
                                    
                                    VStack {
                                        Text(String("\(questionSet[currentQuestion].question)"))
                                    }
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .bold()
                                    
                                    VStack {
                                        TextField("Answer", text: $userAnswer)
                                            .keyboardType(.numberPad)
                                            .textFieldStyle(.roundedBorder)
                                            .padding()
                                        
                                        Button("Check") {
                                            questionResult = checkAnswer()
                                            showingResult = true
                                        }
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(6.0)
                                    }
                                }
                                .alert(alertTitle, isPresented: $showingResult){
                                    if gameEnd != true {
                                        Button("Continue", action: nextQuestion)
                                    } else {
                                        Button("Restart", action: restartGame)
                                    }
                                    
                                } message: {
                                    Text("Your score is \(userScore)")
                                }
                            }
                            .ignoresSafeArea()
                }
                .navigationTitle("Setup")
                }
            }
    }
    
    func generateQuestions(_ count: Int) {
        questionSet = []
        
        for _ in 0..<selectedQuestionCount {
            let randomOperand = Int.random(in: 1..<13)
            
            let tempQuestionStruct = Question(
                question: "What is \(selectedTimesTable) × \(randomOperand)?",
                answer: (selectedTimesTable * randomOperand)
            )
            questionSet.append(tempQuestionStruct)
        }
    }
    
    func nextQuestion(){
        if currentQuestion < selectedQuestionCount - 1 {
            currentQuestion += 1
            userAnswer = ""
        } else {
            gameEnd = true
        }
    }
    
    func checkAnswer() -> Bool {
        if currentQuestion < selectedQuestionCount - 1 {
            if Int(userAnswer) == (questionSet[currentQuestion].answer){
                alertTitle = "Correct"
                userScore += 1
                return true
            } else {
                alertTitle = "Incorrect"
                return false
            }
        } else {
            alertTitle = "Game Over"
            gameEnd = true
            return false
        }
        
    }
    
    func restartGame() {
        gameplayActive = false
        gameEnd = false
        
        currentQuestion = 0
        questionSet = [Question(question: "Async Placeholder", answer: 0)]
        questionResult = false
        userScore = 0
        showingResult = false
    }
}

#Preview {
    ContentView()
}
