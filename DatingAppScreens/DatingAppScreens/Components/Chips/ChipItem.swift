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
        }
        .padding(.horizontal, selectedSize.padding)
        .padding(.vertical, selectedSize.padding / 2)
        .background(Color(hex: "#58DFF1"))
        .foregroundColor(.black)
        .clipShape(Capsule())
        .fixedSize(horizontal: true, vertical: false)
       
    }
}
