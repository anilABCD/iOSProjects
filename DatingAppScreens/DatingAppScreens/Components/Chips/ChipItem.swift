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
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            
            if let icon = icon {
                Image("\(icon)")
                    .resizable()
                    .frame(width: 15, height: 15)
                
//                Text("icon \(icon)")
            }
            
            Text("\(text)")
                .font(.custom(themeManager.currentTheme.fontName, size: selectedSize.fontSize))
                .if(isBold) { view in
                    view.fontWeight(.bold)
                }
        }
        .padding(.horizontal, selectedSize.padding)
        .padding(.vertical, selectedSize.padding / 2)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .clipShape(Capsule())
        .fixedSize(horizontal: true, vertical: false)
       
    }
}
