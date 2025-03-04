//
//  CardStyle.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 01/03/25.
//


import SwiftUI

struct CardStyle: ViewModifier {
    
    @EnvironmentObject private var themeManager : ThemeManager
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(themeManager.currentTheme.cardBackgroundColor)
            .foregroundColor(.gray)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.3), radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
           
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}



struct TempViewToTestCardStyle: View {
    var hobbies: [String] = []
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Hobbies")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(hobbies, id: \.self) { hobby in
                        Text(hobby)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(.white)
//                            .background(
//                                LinearGradient(
//                                    gradient: Gradient(colors: [Color.green, Color.blue]),
//                                    startPoint: .topLeading,
//                                    endPoint: .bottomTrailing
//                                )
//                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 10).padding(.vertical, 10)
            }
            .if(true) { view in
                   view.cardStyle()
               }
            
        }.padding(.horizontal, 25)
    }
}
