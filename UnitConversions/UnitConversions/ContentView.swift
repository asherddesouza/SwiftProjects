//
//  ContentView.swift
//  UnitConversions
//
//  Created by Asher De Souza on 13/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var numberInput = 0.0
    @State private var inputUnit = "Seconds"
    @State private var outputUnit = "Minutes"
    @FocusState private var amountIsFocused: Bool
    
    func removeTrailingZero(_ temp: Double) -> String {
        return String(format: "%g", temp)
    }
    
    public var finalTime: String {
        
        var inputTimeInSeconds: Double = 0
        var finalTimeMeasure: Double = 0
        
        switch inputUnit {
        case "Seconds":
            inputTimeInSeconds = numberInput
        case "Minutes":
            inputTimeInSeconds = numberInput * 60
        case "Hours":
            inputTimeInSeconds = numberInput * 3600
        case "Days":
            inputTimeInSeconds = numberInput * 86400
        default:
            break
        }
        
        switch outputUnit {
        case "Seconds":
            finalTimeMeasure = inputTimeInSeconds
        case "Minutes":
            finalTimeMeasure = inputTimeInSeconds / 60
        case "Hours":
            finalTimeMeasure = inputTimeInSeconds / 3600
        case "Days":
            finalTimeMeasure = inputTimeInSeconds / 86400
        default:
            break
        }

        return removeTrailingZero(finalTimeMeasure)
    }
    
    
    
    let timeUnits = ["Seconds", "Minutes", "Hours", "Days"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Enter the value you want to convert") {
                    TextField("Enter time value", value: $numberInput, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                Section("What unit are you starting from?") {
                    Picker("Time Unit", selection: $inputUnit) {
                        ForEach(timeUnits, id:\.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                }
                Section("What unit are you converting to?") {
                    Picker("Time Unit", selection: $outputUnit) {
                        ForEach(timeUnits, id:\.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                }
                Section("Final Converted Time") {
                    if (finalTime != "1"){
                        Text("\(finalTime) \(outputUnit)").textCase(.lowercase)
                    }
                    else {
                        Text(("\(finalTime) \(outputUnit)").dropLast()).textCase(.lowercase)
                    }
                }
            }
            .navigationTitle("Time Conversion")
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
