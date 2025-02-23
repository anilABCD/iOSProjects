import SwiftUI

struct ThemedButtonStyle: ButtonStyle {
    @EnvironmentObject var themeManager: ThemeManager

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity, minHeight: 50) // Ensure button size
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        themeManager.currentTheme.buttonColor.opacity(0.9),
                        themeManager.currentTheme.buttonColor.opacity(1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(themeManager.currentTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: themeManager.currentTheme.cornerRadius)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 2) // Subtle highlight
                    .blendMode(.overlay)
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5) // Outer shadow
            .shadow(color: .white.opacity(0.3), radius: 5, x: -5, y: -5) // Inner glow effect
            .foregroundColor(.white)
            .font(themeManager.currentTheme.font)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Slight press-in effect
            .offset(y: configuration.isPressed ? 3 : 0) // Move down slightly when pressed
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
