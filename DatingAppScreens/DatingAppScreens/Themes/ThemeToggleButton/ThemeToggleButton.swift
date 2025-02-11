//
//  Untitled.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/02/25.
//

import SwiftUI

struct ThemeToggleButton: View {
    @EnvironmentObject var themeManager: ThemeManager // Access theme

    var body: some View {
        
//        Text("\(themeManager.currentTheme.id ?? "")")
        
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) { // ✅ Smooth transition
                themeManager.setTheme(
                    themeManager.currentTheme.id == "light" ? Themes.dark : Themes.light
                )
            }
        }) {
            Image(systemName: themeManager.currentTheme.id == "light" ? "moon.fill" : "sun.max.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14) // ✅ Smaller icon
                .foregroundColor( themeManager.currentTheme.id == "light" ? Color.white : .white)
                .padding(8) // ✅ Reduced padding to shrink circle
                .background(
                    
                    Circle()
                        .fill( themeManager.currentTheme.id == "light" ? themeManager.currentTheme.buttonColor : .white.opacity(0.2) )
//                        .shadow(color: themeManager.currentTheme.buttonColor.opacity(0.2), radius: 4, x: 0, y: 2) // ✅ Softer shadow
                )
        }
    }
}
