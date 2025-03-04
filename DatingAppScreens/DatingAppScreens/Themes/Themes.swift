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
    let navigationLinkColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    
    let cardBackgroundColor : Color
    let tabsBackgroundColor : Color
    
    let textColor: Color
    let subTextColor : Color
    
    let popUpBackgroundColor : Color
 
    let buttonColor: Color
    let buttonSecondaryColor : Color
    
    let font: Font
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
}


struct Themes {
    static let light = AppTheme(
        id: "light",
        primaryColor: .blue,
        navigationLinkColor: .black,
      
        secondaryColor: .gray,
        backgroundColor: .white.opacity(0.5),
        
        cardBackgroundColor : .white ,
        tabsBackgroundColor :.white,
        
        textColor: .black,
        subTextColor : .black.opacity(0.5) ,
        
        popUpBackgroundColor : .blue ,
        
        buttonColor: .blue,
        
        
        buttonSecondaryColor: .blue.opacity(0.9) ,
        
        font: .system(size: 16, weight: .regular),
        cornerRadius: 12,
        shadowRadius: 5
    )

    static let dark = AppTheme(
        id: "dark",
        primaryColor: .white,
        navigationLinkColor: .white,
        secondaryColor: .gray,
        backgroundColor: .black,
        
        cardBackgroundColor : .black ,
        tabsBackgroundColor :.black,
        
        textColor: .white,
        subTextColor: .white.opacity(0.5),
  
        popUpBackgroundColor : .cyan,
        
        
        buttonColor: .cyan,
        buttonSecondaryColor : .white.opacity(0.1) ,
        font: .system(size: 16, weight: .medium),
        cornerRadius: 12,
        shadowRadius: 5
    )

    static let redTheme = AppTheme(
        id: "red",
        primaryColor: .red,
        navigationLinkColor: .red,
        secondaryColor: .orange,
        backgroundColor: .black,
        
        cardBackgroundColor : .black ,
        tabsBackgroundColor :.black,
        
        textColor: .white,
        subTextColor: .white.opacity(0.5),
        
        popUpBackgroundColor : .red.opacity(0.5) ,
        
        buttonColor: .red,
        buttonSecondaryColor: .red, 
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
