//
//  ThemedButtonStyle.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/02/25.
//

import SwiftUI

struct ThemedButtonStyle: ButtonStyle {
    @EnvironmentObject var themeManager: ThemeManager

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background( themeManager.currentTheme.buttonColor)
            .foregroundColor(.white)
            .font( themeManager.currentTheme.font)
            .cornerRadius( themeManager.currentTheme.cornerRadius)
//            .shadow(radius: tokenManager.themeManager.currentTheme.shadowRadius)
            .opacity(configuration.isPressed ? 0.8 : 1.0) // Press effect
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
