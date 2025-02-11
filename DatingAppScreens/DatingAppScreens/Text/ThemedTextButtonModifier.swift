//
//  ThemedTextModifier 2.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/02/25.
//


//
//  ThemedTextModifier.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/02/25.
//


import SwiftUI

struct ThemedTextButtonModifier: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager

    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background( themeManager.currentTheme.buttonColor)
            .foregroundColor(.white)
            .font( themeManager.currentTheme.font)
            .cornerRadius( themeManager.currentTheme.cornerRadius)
//            .shadow(radius: tokenManager.themeManager.currentTheme.shadowRadius)
            
    }
}
