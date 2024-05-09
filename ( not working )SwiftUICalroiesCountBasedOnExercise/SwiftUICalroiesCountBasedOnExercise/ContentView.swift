//
//  ContentView.swift
//  SwiftUICalroiesCountBasedOnExercise
//
//  Created by Anil Kumar Potlapally on 09/05/24.
//

import Foundation
import SwiftUI
import HealthKit
import Combine


struct Exercise: Identifiable , Hashable {
    var id = UUID()
    var name: String
    var caloriesPerMinute: Double  // Calories burned per minute
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)  // Using `UUID` as the unique identifier for hashing
   }
       
       
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
           return lhs.id == rhs.id
    }
}

class HealthViewModel: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var stepsCount: Int = 0
    @Published var exercises: [Exercise] = []
    
    // List of common exercises with their calorie rates (approximate values)
    let exerciseList = [
        Exercise(name: "Running", caloriesPerMinute: 10),
        Exercise(name: "Cycling", caloriesPerMinute: 8),
        Exercise(name: "Swimming", caloriesPerMinute: 11),
        Exercise(name: "Yoga", caloriesPerMinute: 4)
    ]
    
    init() {
        requestHealthAuthorization()
        fetchSteps()
    }
    
    func requestHealthAuthorization() {
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        healthStore.requestAuthorization(toShare: nil, read: [stepType]) { success, error in
            if !success {
                print("HealthKit authorization failed")
            }
        }
    }
    
    func fetchSteps() {
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let now = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: [])
        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            if let sum = result?.sumQuantity() {
                let steps = Int(sum.doubleValue(for: .count()))
                DispatchQueue.main.async {
                    self.stepsCount = steps
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func addExercise(exercise: Exercise, minutes: Double) {
        exercises.append(Exercise(name: exercise.name, caloriesPerMinute: exercise.caloriesPerMinute * minutes))
    }
    
    var totalCaloriesBurned: Double {
        let exerciseCalories = exercises.reduce(0.0) { $0 + $1.caloriesPerMinute }
        let stepCalories = Double(stepsCount) * 0.04  // Approximation: 0.04 cal per step
        return exerciseCalories + stepCalories
    }
}


struct ContentView: View {
    @ObservedObject var viewModel = HealthViewModel()
    
    @State private var selectedExercise: Exercise? = nil
    @State private var exerciseDuration = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Total Steps: \(viewModel.stepsCount)")
                    .font(.title)
                
                Form {
                    Section(header: Text("Log Exercise")) {
                        Picker("Select Exercise", selection: $selectedExercise) {
                            ForEach(viewModel.exerciseList) { exercise in
                                Text(exercise.name).tag(exercise as Exercise?)
                            }
                        }
                        TextField("Duration in Minutes", text: $exerciseDuration)
                            .keyboardType(.decimalPad)

                        Button("Add Exercise") {
                            // Ensure exercise and duration are valid
                            if let exercise = selectedExercise,
                               let minutes = Double(exerciseDuration) {
                                viewModel.addExercise(exercise: exercise, minutes: minutes)
                                exerciseDuration = ""  // Reset the text field
                            } else {
                                print("Invalid exercise or duration")
                            }
                        }
                    }
                    
                    Section(header: Text("Exercises")) {
                        ForEach(viewModel.exercises) { exercise in
                            Text("\(exercise.name) - \(exercise.caloriesPerMinute) calories")
                        }
                    }
                    
                    Section(header: Text("Total Calories Burned")) {
                        Text("\(viewModel.totalCaloriesBurned, specifier: "%.2f") calories")
                    }
                }
            }
            .navigationTitle("Calorie Tracker")
        }
    }
}



#Preview {
    ContentView()
}
