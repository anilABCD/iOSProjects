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
struct WrapViewArray : View {
    @Binding var options: [String]?
    
   var selectedSize: CapsuleSize

    @EnvironmentObject var themeManager: ThemeManager
  
    var backgroundColor : Color =  Color(hex: "#002855")
    var foregroundColor : Color =  .white
    var maxWidth : CGFloat = 80.0

    @State private var rows: [[String]] = []

    var body: some View {
        GeometryReader { geometry in
            self.generateWrappedItems(in: geometry.size.width)
        }
        .onAppear {
            self.arrangeItems()
        }
        .onChange(of: options) { _  , newValue in
            
            self.arrangeItems()
        }
        .frame(height: calculateHeight())
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
        let maxWidth = UIScreen.main.bounds.width - maxWidth // Adjust for padding

         if let options = options {
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
            }
        }
        
    }

    private func calculateHeight() -> CGFloat {
        guard !rows.isEmpty else { return 0 } // If no rows, height is 0

           let rowHeight = selectedSize.fontSize + 12 // Approximate row height
           let totalSpacing = CGFloat(rows.count - 1) * 6 // Spacing between rows

           return CGFloat(rows.count) * rowHeight + totalSpacing
    }

    private func textSize(for text: String, fontSize: CGFloat) -> CGSize {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: attributes)
    }
}

 

// Custom Auto-Wrapping View
struct WrapViewSingle : View {
    @Binding var option: String?
    
   var selectedSize: CapsuleSize

    @EnvironmentObject var themeManager: ThemeManager
  
    var backgroundColor : Color =  Color(hex: "#002855")
    var foregroundColor : Color =  .white
    var maxWidth : CGFloat = 80.0

    @State private var rows: [[String]] = []

    var body: some View {
        GeometryReader { geometry in
            self.generateWrappedItems(in: geometry.size.width)
        }
        .onAppear {
            self.arrangeItems()
        }
        .onChange(of: option ) { _ , newValue in
            
            self.arrangeItems()
        }
        .frame(height: calculateHeight())
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
        let maxWidth = UIScreen.main.bounds.width - maxWidth // Adjust for padding

        if let option = option {
            
            for option in [option] {
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
            }
        }
    }

    private func calculateHeight() -> CGFloat {
        guard !rows.isEmpty else { return 0 } // If no rows, height is 0

           let rowHeight = selectedSize.fontSize + 12 // Approximate row height
           let totalSpacing = CGFloat(rows.count - 1) * 6 // Spacing between rows

           return CGFloat(rows.count) * rowHeight + totalSpacing
    }

    private func textSize(for text: String, fontSize: CGFloat) -> CGSize {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: attributes)
    }
}

 
