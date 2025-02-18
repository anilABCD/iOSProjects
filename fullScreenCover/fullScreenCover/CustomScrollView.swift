////
////  CustomScrollView.swift
////  fullScreenCover
////
////  Created by Anil Kumar Potlapally on 18/02/25.
////
//
//
//import SwiftUI
//
//struct CustomScrollView: View {
//    @State private var scrollOffset: CGFloat = 0
//    @State private var contentHeight: CGFloat = 0
//    @State private var containerHeight: CGFloat = 0
//    @State private var showScrollbar: Bool = false
//
//    var body: some View {
//        GeometryReader { geo in
//            let containerHeight = geo.size.height
//
//            ScrollView {
//                VStack {
//                    ForEach(0..<50, id: \.self) { index in
//                        Text("Item \(index)")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.blue.opacity(0.2))
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                    }
//                }
//                .background(
//                    GeometryReader { contentGeo in
//                        Color.clear
//                            .onAppear {
//                                self.contentHeight = contentGeo.size.height
//                            }
//                    }
//                )
//                .background(ScrollViewOffsetListener(offset: $scrollOffset))
//            }
//            .scrollIndicators(.hidden) // Hide default scrollbar
//            .overlay(
//                CustomScrollbar(
//                    scrollOffset: scrollOffset,
//                    contentHeight: contentHeight,
//                    containerHeight: containerHeight,
//                    showScrollbar: $showScrollbar
//                )
//                .frame(width: 6)
//                .offset(x: -10), // Adjusts scrollbar position to center-right
//                alignment: .trailing
//            )
//            .onAppear {
//                self.containerHeight = containerHeight
//            }
//            .onChange(of: scrollOffset) { _ in
//                showScrollbar = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    showScrollbar = false
//                }
//            }
//        }
//    }
//}
//
//// Tracks Scroll Offset
//struct ScrollViewOffsetListener: View {
//    @Binding var offset: CGFloat
//
//    var body: some View {
//        GeometryReader { geo in
//            Color.clear
//                .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
//                .onPreferenceChange(ScrollOffsetKey.self) { newValue in
//                    self.offset = newValue
//                }
//        }
//    }
//}
//
//struct ScrollOffsetKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
//
//// Custom Scrollbar with Three Lines
//struct CustomScrollbar: View {
//    let scrollOffset: CGFloat
//    let contentHeight: CGFloat
//    let containerHeight: CGFloat
//    @Binding var showScrollbar: Bool
//
//    let maxScrollbarMovement: CGFloat = 100 // Maximum scrollbar movement distance
//
//    var activeIndex: Int {
//        let scrollableHeight = contentHeight - containerHeight
//        guard scrollableHeight > 0 else { return 0 }
//
//        let progress = -scrollOffset / scrollableHeight
//
//        // Determine active scrollbar level
//        if progress <= 0.33 {
//            return 0 // Top active
//        } else if progress <= 0.66 {
//            return 1 // Middle active
//        } else {
//            return 2 // Bottom active
//        }
//    }
//
//    var body: some View {
//        if contentHeight > containerHeight && showScrollbar {
//            VStack(spacing: 8) {
//                ForEach(0..<3, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 2)
//                        .fill(index == activeIndex ? Color.gray.opacity(0.9) : Color.gray.opacity(0.4))
//                        .frame(width: 6, height: 20) // Three separate lines
//                        .animation(.easeInOut(duration: 0.2), value: activeIndex)
//                }
//            }
//            .transition(.opacity)
//        }
//    }
//}
//
//struct CustomScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomScrollView()
//    }
//}
