//
//  WrapView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 07/03/25.
//


import SwiftUI

// Enum for Capsule Sizes
enum CapsuleSize: CaseIterable {
    case small, medium, large
    
    var fontSize: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }
    
    var padding: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 8
        case .large: return 12
        }
    }
}


// Custom Auto-Wrapping View
struct WrapView: View {
    let options: [String]
    @Binding var selectedOption: String?
    @Binding var selectedSize: CapsuleSize

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
                            .font(.system(size: selectedSize.fontSize)) // Dynamic font size
                            .padding(.horizontal, selectedSize.padding)
                            .padding(.vertical, selectedSize.padding / 2)
                            .background(selectedOption == option ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedOption == option ? .white : .black)
                            .clipShape(Capsule())
                            .fixedSize(horizontal: true, vertical: false) // Prevents truncation
                            .onTapGesture {
                                selectedOption = option
                            }
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

// Custom shape for rounding specific corners
struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
