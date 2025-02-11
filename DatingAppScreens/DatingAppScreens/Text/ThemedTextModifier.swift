//
//  ThemedTextModifier.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/02/25.
//


import SwiftUI

struct ThemedTextModifier: ViewModifier {
    @EnvironmentObject var tokenManager: ThemeManager

    func body(content: Content) -> some View {
        content
            .foregroundColor(tokenManager.currentTheme.textColor)
            .font(tokenManager.currentTheme.font)
            .padding()
            .background(tokenManager.currentTheme.backgroundColor.opacity(0.2))
            .cornerRadius(tokenManager.currentTheme.cornerRadius)
    }
}
