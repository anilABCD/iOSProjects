//
//  DatingAppScreensApp.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI
import GoogleSignIn

class TokenManager: ObservableObject {
    @AppStorage("accessToken") var accessToken: String = ""
}


@main
struct DatingAppScreensApp: App {
    
    @StateObject private var tokenManager = TokenManager()
   
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(tokenManager).onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
              }.onAppear {
                  GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    // Check if `user` exists; otherwise, do something with `error`
                  }
                }
        }
    }
}
