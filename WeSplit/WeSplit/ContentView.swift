//
//  ContentView.swift
//  WeSplit
//
//  Created by Asher De Souza on 11/12/2023.
//

// use palette style picker for tip

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    public var individualCost: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        return (checkAmount * ((100.0 + tipSelection) / 100.0)) / peopleCount
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Enter total bill and no of people") {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                
                    Picker("Number of people", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }.pickerStyle(.navigationLink)
                }
                
                Section("How much do you want to tip?") {
                    Picker("Tip Percentage", selection: $tipPercentage){
                        ForEach(1..<101, id:\.self){
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.navigationLink)
                }
                
                Section("Total Bill") {
                    Text(individualCost * Double(numberOfPeople + 2), format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                }
                
                Section("Individual Cost") {
                    Text(individualCost, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
