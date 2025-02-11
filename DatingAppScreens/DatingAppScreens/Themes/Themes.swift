//
//  Themes.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/02/25.
//

import SwiftUI


struct AppTheme {
    let id: String
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    let textColor: Color
    
 
    let buttonColor: Color
    
    let font: Font
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
}


struct Themes {
    static let light = AppTheme(
        id: "light",
        primaryColor: .blue,
        secondaryColor: .gray,
        backgroundColor: .white,
        textColor: .black,
 
        buttonColor: .blue,
        font: .system(size: 16, weight: .regular),
        cornerRadius: 12,
        shadowRadius: 5
    )

    static let dark = AppTheme(
        id: "dark",
        primaryColor: .white,
        secondaryColor: .gray,
        backgroundColor: .black,
        textColor: .white,
  
        buttonColor: .cyan,
        font: .system(size: 16, weight: .medium),
        cornerRadius: 12,
        shadowRadius: 5
    )

    static let redTheme = AppTheme(
        id: "red",
        primaryColor: .red,
        secondaryColor: .orange,
        backgroundColor: .black,
        textColor: .white,
 
        buttonColor: .red,
        font: .system(size: 18, weight: .bold),
        cornerRadius: 20,
        shadowRadius: 8
    )

    static let allThemes = [light, dark, redTheme]
}


class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = Themes.light

    @AppStorage("selectedThemeID") private var selectedThemeID: String = "light"

    init() {
        // Load saved theme or default to light
        self.currentTheme = Themes.allThemes.first { $0.id == selectedThemeID } ?? Themes.light
    }

    func setTheme(_ theme: AppTheme) {
        
        DispatchQueue.main.async { // ✅ Ensures UI updates immediately
                   self.currentTheme = theme
                   self.selectedThemeID = theme.id
               }
//        self.currentTheme = theme
       
    }
}
