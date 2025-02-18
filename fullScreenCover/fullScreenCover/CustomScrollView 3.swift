import SwiftUI

struct CustomScrollView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var containerHeight: CGFloat = 0
    @State private var showScrollbar: Bool = false

    var body: some View {
        GeometryReader { geo in
            let containerHeight = geo.size.height

            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        ForEach(0..<50, id: \.self) { index in
                            Text("Item \(index)")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .background(
                        GeometryReader { contentGeo in
                            Color.clear
                                .onAppear {
                                    self.contentHeight = contentGeo.size.height
                                }
                        }
                    )
                    .background(ScrollViewOffsetListener(offset: $scrollOffset, contentHeight: contentHeight, containerHeight: containerHeight))
                    
                    Color.clear.frame(height: 50)
                }
                .scrollIndicators(.hidden) // Hide default scrollbar
                .overlay(
                    CustomScrollbar(
                        scrollOffset: scrollOffset,
                        contentHeight: contentHeight,
                        containerHeight: containerHeight,
                        showScrollbar: $showScrollbar
                    )
                    .frame(width: 10)
                    .offset(x: -10), // Position scrollbar at center-right
                    alignment: .trailing
                )
                .onAppear {
                    self.containerHeight = containerHeight
                    showScrollbar = true
                }
                .onChange(of: scrollOffset) { _ in
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                        showScrollbar = false
//                    }
                }
            }
        }
    }
}

// Tracks Scroll Offset and Detects When Fully Scrolled
struct ScrollViewOffsetListener: View {
    @Binding var offset: CGFloat
    let contentHeight: CGFloat
    let containerHeight: CGFloat

    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                .onPreferenceChange(ScrollOffsetKey.self) { newValue in
                    let maxScrollOffset = -(contentHeight - containerHeight)
                    
                    if newValue >= 0 {
                        offset = 0 // Fully at the top
                    } else if newValue <= maxScrollOffset {
                        offset = maxScrollOffset // Fully at the bottom
                    } else {
                        offset = newValue // Scrolling
                    }
                }
        }
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Custom Scrollbar with Top, Middle, and Bottom Activation
struct CustomScrollbar: View {
    let scrollOffset: CGFloat
    let contentHeight: CGFloat
    let containerHeight: CGFloat
    @Binding var showScrollbar: Bool

    var activeIndex: Int {
        let maxScrollOffset = -(contentHeight - containerHeight )

        print( abs( scrollOffset) + 50  , abs(maxScrollOffset))
        if scrollOffset == 0 {
            return 0 // Top active
        } else if  abs( scrollOffset) + 100  >= abs(maxScrollOffset)  {
            return 2 // Bottom active
        } else {
            return 1 // Middle active
        }
    }

    var body: some View {
        if contentHeight > containerHeight && showScrollbar {
            VStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    
                        // Top & Bottom Rounded Rectangles
                        RoundedRectangle(cornerRadius: 5)
                        .fill(index == activeIndex ? Color.blue.opacity(0.9) : Color.gray.opacity(0.4))
                            .frame(width: 10, height: index == activeIndex ? 50 : 10)
                            .animation(.easeInOut(duration: 0.2), value: activeIndex)
                           
                }
            }
            .transition(.opacity)
        }
    }
}

struct CustomScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CustomScrollView()
    }
}
