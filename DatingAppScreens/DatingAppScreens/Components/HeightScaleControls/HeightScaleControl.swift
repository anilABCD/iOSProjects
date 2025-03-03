import SwiftUI

struct HeightScaleControl: View {
    @State private var heightInInches: Int = 66 // Default height (5'6")
    let minHeightInInches = 48  // 4 feet (4'0")
    let maxHeightInInches = 108 // 9 feet (9'0")

    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Height")
                .font(.title2)
                .fontWeight(.semibold)

            // Display Selected Height
            Text("\(heightToFeetAndInches(heightInInches))")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
                .padding(.bottom, 10)

            // Scrollable Height Scale
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(minHeightInInches...maxHeightInInches, id: \.self) { value in
                            VStack {
                                Rectangle()
                                    .fill(value % 12 == 0 ? Color.blue : Color.gray.opacity(0.5))
                                    .frame(width: value % 12 == 0 ? 3 : 1, height: value % 12 == 0 ? 35 : 20)

                                if value % 12 == 0 {
                                    Text("\(heightToFeetAndInches(value))")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.gray)
                                        .padding(.top, 5)
                                }
                            }
                            .frame(width: 25)
                        }
                    }
                    .background(GeometryReader { proxy in
                        Color.clear
                            .onAppear { updateHeight(from: proxy.frame(in: .global).minX, width: geometry.size.width) }
                            .onChange(of: proxy.frame(in: .global).minX) { newOffset in
                                updateHeight(from: newOffset, width: geometry.size.width)
                            }
                    })
                }
            }
            .frame(height: 70)
            .clipped()
            .overlay(
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 3, height: 50) // Center Indicator
            )
            .padding(.horizontal, 20)
        }
        .padding()
    }

    // Convert inches to feet & inches format
    func heightToFeetAndInches(_ inches: Int) -> String {
        let feet = inches / 12
        let remainingInches = inches % 12
        return "\(feet)'\(remainingInches)\""
    }

    // Update the height based on scroll position
    private func updateHeight(from offset: CGFloat, width: CGFloat) {
        let stepWidth: CGFloat = 25 // Width of each increment
        let centerOffset = width / 2 // Center of the screen
        let adjustedOffset = (centerOffset - offset) / stepWidth
        let newHeight = minHeightInInches + Int(round(adjustedOffset))

        let clampedHeight = max(minHeightInInches, min(maxHeightInInches, newHeight))

        if heightInInches != clampedHeight {
            heightInInches = clampedHeight
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}

struct HeightScaleControl_Previews: PreviewProvider {
    static var previews: some View {
        HeightScaleControl()
    }
}
