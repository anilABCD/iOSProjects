//
//  swiftuiHealthKitApp.swift
//  swiftuiHealthKit
//
//  Created by Anil Kumar Potlapally on 09/05/24.
//

import SwiftUI

@main
struct swiftuiHealthKitApp: App {
    
    @StateObject var manager = HealthManager();
    
    var body: some Scene {
        WindowGroup {
            BeActiveTabView().environmentObject(manager)
        }
    }
}
