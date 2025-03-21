//
//  CapsuleSize.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 16/02/25.
//


import SwiftUI


// Selection Sheet View
struct SingleSelectPopUpChipSelectionSheet: View {
    let options: [String]
    
   
    @Binding var selectedOption: String?
    @Binding var selectedSize: CapsuleSize
    let showDone : Bool = false
    @EnvironmentObject private var themeManager : ThemeManager
    

    var body: some View {
        VStack {
            Text("Select an Option")
                .font(.caption2)
                .padding(.top)
                .foregroundColor(.white)
//                .modifier(ThemedTextModifier())

            ScrollView {
                WrapView(options: options, selectedOption: $selectedOption, selectedSize: $selectedSize)
                    .padding()
                
                Color.clear.frame(height: 200)
            }

            if showDone {
                Button("Done") {
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                }
                .font(.caption2)
                .padding(10)
                .frame(height: 30)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(themeManager.currentTheme.buttonColor)
                )
            }
        }
        
//        .background(
//            RoundedRectangle(cornerRadius: 10)
//                .fill( .white.opacity(0.1))
//        )

        .padding()
    }
}


//
//// Custom Auto-Wrapping View
//struct WrapView: View {
//    let options: [String]
//    @Binding var selectedOption: String?
//    @Binding var selectedSize: CapsuleSize
//
//    @EnvironmentObject private var themeManager : ThemeManager
//    
//    @State private var rows: [[String]] = []
//
//    var body: some View {
//        GeometryReader { geometry in
//            self.generateWrappedItems(in: geometry.size.width)
//        }
//        .onAppear {
//            self.arrangeItems()
//        }
//        .frame(maxHeight: calculateHeight())
//    }
//
//    private func generateWrappedItems(in totalWidth: CGFloat) -> some View {
//        VStack(alignment: .leading, spacing: 6) {
//            ForEach(rows, id: \.self) { row in
//                HStack(spacing: 6) {
//                    ForEach(row, id: \.self) { option in
//                        Text(option)
//                            .font(.system(size: selectedSize.fontSize)) // Dynamic font size
//                            .padding(.horizontal, selectedSize.padding)
//                            .padding(.vertical, selectedSize.padding / 2)
//                            .background(selectedOption == option ? .white : Color.clear)
//                            .foregroundColor(selectedOption == option ? .black : .white)
//                            .clipShape(Capsule())
//                            .overlay(
//                                    Capsule()
//                                        .stroke(Color.white, lineWidth: 1) // White border with 2px thickness
//                                )
//                            .fixedSize(horizontal: true, vertical: false) // Prevents truncation
//                            .onTapGesture {
//                                selectedOption = option
//                                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
//                            }
//                    }
//                }
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//
//    private func arrangeItems() {
//        var currentRow: [String] = []
//        var rowWidth: CGFloat = 0
//        let maxWidth = UIScreen.main.bounds.width - 40 // Adjust for padding
//
//        for option in options {
//            let optionWidth = textSize(for: option, fontSize: selectedSize.fontSize).width + selectedSize.padding * 2
//            if rowWidth + optionWidth > maxWidth - 10 {
//                rows.append(currentRow)
//                currentRow = [option]
//                rowWidth = optionWidth
//            } else {
//                currentRow.append(option)
//                rowWidth += optionWidth + 6 // Add spacing
//            }
//        }
//
//        if !currentRow.isEmpty {
//            rows.append(currentRow)
//        }
//    }
//
//    private func calculateHeight() -> CGFloat {
//        return CGFloat(rows.count * Int(selectedSize.fontSize + 12)) // Approximate row height
//    }
//
//    private func textSize(for text: String, fontSize: CGFloat) -> CGSize {
//        let font = UIFont.systemFont(ofSize: fontSize)
//        let attributes = [NSAttributedString.Key.font: font]
//        return (text as NSString).size(withAttributes: attributes)
//    }
//}

