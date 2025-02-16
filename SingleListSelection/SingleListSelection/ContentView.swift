import SwiftUI

struct SingleSelectionPopup: View {
    let options = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew", "Kiwi", "Lemon", "Mango", "Orange", "Peach", "Pineapple", "Strawberry", "Watermelon"]

    @State private var selectedOption: String? = nil
    @State private var showSheet = false
    @State private var selectedSize: CapsuleSize = .medium  // Default size

    var body: some View {
        VStack {
     
            Text(selectedOption ?? "Select an option")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .onTapGesture {
                    showSheet.toggle()
                }

            Picker("Size", selection: $selectedSize) {
                Text("Small").tag(CapsuleSize.small)
                Text("Medium").tag(CapsuleSize.medium)
                Text("Large").tag(CapsuleSize.large)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
          
        }
        .sheet(isPresented: $showSheet) {
            SelectionSheet(options: options, selectedOption: $selectedOption, selectedSize: $selectedSize)
        }
    }
}

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

// Selection Sheet View
struct SelectionSheet: View {
    let options: [String]
    @Binding var selectedOption: String?
    @Binding var selectedSize: CapsuleSize

    var body: some View {
        VStack {
            Text("Select an Option")
                .font(.caption2)
                .padding(.top)

            ScrollView {
                WrapView(options: options, selectedOption: $selectedOption, selectedSize: $selectedSize)
                    .padding()
            }

            Button("Done") {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
            }
            .font(.caption2)
            .padding(40)
        }
        .padding()
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

struct SingleSelectionPopup_Previews: PreviewProvider {
    static var previews: some View {
        SingleSelectionPopup()
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            SingleSelectionPopup()
        }
        .padding()
    }
}

 
