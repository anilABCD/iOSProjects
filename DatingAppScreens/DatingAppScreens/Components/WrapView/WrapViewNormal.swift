//
//  CapsuleSize.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 07/03/25.
//


//
//  WrapView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 07/03/25.
//


import SwiftUI

 

// Custom Auto-Wrapping View
struct WrapViewNormal : View {
    let options: [String]
    
   var selectedSize: CapsuleSize

    @EnvironmentObject var themeManager: ThemeManager
 
    @Binding var rowsCount : Int
    
    
    var backgroundColor : Color =  Color(hex: "#002855")
    var foregroundColor : Color =  .white
    

    @State private var rows: [[String]] = []

    var body: some View {
        GeometryReader { geometry in
            self.generateWrappedItems(in: geometry.size.width)
        }
        .onAppear {
            self.arrangeItems()
        }
        .frame(maxHeight: calculateHeight())
    }

    private func generateWrappedItems(in totalWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.self) { option in
                        Text(option)
                            .font(.custom(themeManager.currentTheme.fontName, size: selectedSize.fontSize)) // Dynamic font size
                            .padding(.horizontal, selectedSize.padding)
                            .padding(.vertical, selectedSize.padding / 2)
                            .background(backgroundColor)
                            .foregroundColor(foregroundColor)
                            .clipShape(Capsule())
                            .fixedSize(horizontal: true, vertical: false) // Prevents truncation
                           
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func arrangeItems() {
        var currentRow: [String] = []
        var rowWidth: CGFloat = 0
        let maxWidth = UIScreen.main.bounds.width - 40 // Adjust for padding

        for option in options {
            let optionWidth = textSize(for: option, fontSize: selectedSize.fontSize).width + selectedSize.padding * 2
            if rowWidth + optionWidth > maxWidth - 10 {
                rows.append(currentRow)
                currentRow = [option]
                rowWidth = optionWidth
            } else {
                currentRow.append(option)
                rowWidth += optionWidth + 6 // Add spacing
            }
        }

        if !currentRow.isEmpty {
            rows.append(currentRow)
            rowsCount += 1 
        }
    }

    private func calculateHeight() -> CGFloat {
        return CGFloat(rows.count * Int(selectedSize.fontSize + 12)) // Approximate row height
    }

    private func textSize(for text: String, fontSize: CGFloat) -> CGSize {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: attributes)
    }
}

 
