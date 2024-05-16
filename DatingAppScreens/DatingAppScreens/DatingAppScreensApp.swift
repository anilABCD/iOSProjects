//
//  DatingAppScreensApp.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI

class TokenManager: ObservableObject {
    @AppStorage("accessToken") var accessToken: String = ""
}


@main
struct DatingAppScreensApp: App {
    
    @StateObject private var tokenManager = TokenManager()
   
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(tokenManager)
        }
    }
}
