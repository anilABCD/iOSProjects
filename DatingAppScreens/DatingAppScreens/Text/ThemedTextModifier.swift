//
//  ThemedTextModifier.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/02/25.
//


import SwiftUI

struct ThemedTextModifier: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager

    func body(content: Content) -> some View {
        content
            .foregroundColor(themeManager.currentTheme.textColor)
            .font(themeManager.currentTheme.font)
            .padding()
            .background(themeManager.currentTheme.backgroundColor)
            .cornerRadius(themeManager.currentTheme.cornerRadius)
    }
}
