//
//  ContentView.swift
//  SwiftUIThemeProject
//
//  Created by Anil Kumar Potlapally on 06/05/24.
//

import SwiftUI


// Define a Theme data model and make it Equatable
struct Theme: Equatable {
    let backgroundColor: Color
    let textColor: Color
    let buttonBackgroundColor: Color
    let buttonTextColor: Color

    // Conform to Equatable by defining how themes are compared
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.backgroundColor == rhs.backgroundColor &&
               lhs.textColor == rhs.textColor &&
               lhs.buttonBackgroundColor == rhs.buttonBackgroundColor &&
               lhs.buttonTextColor == rhs.buttonTextColor
    }
}

// Define a collection of themes
struct Themes {
    static let light = Theme(
        backgroundColor: Color.white,
        textColor: Color.black,
        buttonBackgroundColor: Color.blue,
              buttonTextColor: Color.white
    )
    
    static let dark = Theme(
        backgroundColor: Color.black,
        textColor: Color.white,
        buttonBackgroundColor: Color.orange,
                buttonTextColor: Color.black
    )
}

// Create an ObservableObject to manage the current theme
class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme
    
    init(initialTheme: Theme) {
        self.currentTheme = initialTheme
    }
    
    // Method to toggle between light and dark themes
    func toggleTheme() {
        if currentTheme == Themes.light {
            currentTheme = Themes.dark
        } else {
            currentTheme = Themes.light
        }
    }
}

// A custom ViewModifier to apply the current theme to a view
struct ThemedModifier: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .background(themeManager.currentTheme.backgroundColor)
            .foregroundColor(themeManager.currentTheme.textColor)
    }
    
//    @Environment(\.colorScheme) var colorScheme
//       
//       func body(content: Content) -> some View {
//           let theme = (colorScheme == .dark) ? Themes.dark : Themes.light
//       
//           return content
//            .background(theme.backgroundColor)
//            .foregroundColor(theme.textColor)
//    }
    
}

// A custom button style that uses the current theme's colors
struct ThemedButtonStyle: ButtonStyle {
    @EnvironmentObject var themeManager: ThemeManager
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding() // Padding around the text
            .foregroundColor(themeManager.currentTheme.buttonTextColor) // Button text color
            .background(themeManager.currentTheme.buttonBackgroundColor) // Button background color
            .cornerRadius(10) // Rounded corners
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Press effect
    }
}

// An extension to make it easier to apply the theme modifier
extension View {
    func applyTheme() -> some View {
        self.modifier(ThemedModifier())
    }
}


struct ContentView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
      
      var body: some View {
          VStack(spacing: 20) {
              Text("Hello, SwiftUI!")
                  .applyTheme() // Apply the theme to the text

              Button("Themed Button") {
                  print("Button tapped")
              }
              .buttonStyle(ThemedButtonStyle()) // Apply the themed button style

              Button("Toggle Theme") {
                  themeManager.toggleTheme() // Toggle between light and dark themes
              }
              .buttonStyle(ThemedButtonStyle()) // Apply the themed button style
          }
          .applyTheme() // Apply the theme to the entire view
      }
}

#Preview {
    ContentView().environmentObject(ThemeManager(initialTheme: Themes.light))
}
