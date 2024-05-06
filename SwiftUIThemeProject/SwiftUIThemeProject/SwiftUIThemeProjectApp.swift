//
//  SwiftUIThemeProjectApp.swift
//  SwiftUIThemeProject
//
//  Created by Anil Kumar Potlapally on 06/05/24.
//

import SwiftUI

// Main SwiftUI App with ThemeManager as an EnvironmentObject
@main
struct SwiftUIThemeProjectApp: App {
    
    @StateObject private var themeManager = ThemeManager(initialTheme: Themes.light)
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(themeManager)// Provide the theme manager to the entire app
        }
    }
}
