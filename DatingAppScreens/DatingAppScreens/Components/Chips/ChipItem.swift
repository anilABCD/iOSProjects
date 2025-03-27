//
//  ChipItem.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 12/03/25.
//


import SwiftUI

struct ChipItem : View {
    let text: String
    let selectedSize: CapsuleSize
    var icon : String? = nil

    var backgroundColor : Color = Color(hex: "#58DFF1")
    var foregroundColor : Color = .black
    var isBold : Bool = false
    var isSystemIcon :Bool = false
    var maxWidth : CGFloat? = 100.0
    
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            
            if let icon = icon {
                
                if ( self.isSystemIcon ) {
                    Image(systemName: icon) // SF Symbol for location
                               .font(.largeTitle) // Adjust size
                               .foregroundColor(.red) // Change color
                }
                else {
                    Image("\(icon)")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
//                Text("icon \(icon)")
            }
            
            Text("\(text)")
                .font(.custom(themeManager.currentTheme.fontName, size: selectedSize.fontSize))
                .if(isBold) { view in
                    view.fontWeight(.bold)
                }
                .frame(maxWidth: maxWidth, alignment: .leading) // Max width set to 100 pixels
        }
        .padding(.horizontal, selectedSize.padding)
        .padding(.vertical, selectedSize.padding / 2)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .clipShape(Capsule())
        .fixedSize(horizontal: true, vertical: false)
       
    }
}
