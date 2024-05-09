//
//  HealthManager.swift
//  swiftuiHealthKit
//
//  Created by Anil Kumar Potlapally on 09/05/24.
//

import Foundation
import SwiftUI
import HealthKit

class HealthManager : ObservableObject {
    
    let healthStore = HKHealthStore();
    
    init()
    {
        let steps = HKQuantityType(.stepCount)
        
        let healthTypes : Set = [steps]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [ ], read: healthTypes )
                
            }
            catch {
                print ("error fetching health data")
            }
        }
    }
}
