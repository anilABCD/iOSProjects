import SwiftUI

struct SlidingTabsFourView<Content: View>: View {
    @Namespace private var animationNamespace
    @State private var selectedTab: Int
    let tabs: [String]
    let barBottomTab: Bool
    let tabTitleBackgroundHighlighter: Bool
    let tabContents: [Content]
    
    init(
        tabs: [String],
        initialIndex: Int = 0,
        barBottomTab: Bool = false,
        tabTitleBackgroundHighlighter: Bool = true,
        @ViewBuilder contents: () -> TupleView<(Content, Content, Content, Content)>
    ) {
        self.tabs = tabs
        self._selectedTab = State(initialValue: initialIndex)
        self.barBottomTab = barBottomTab
        self.tabTitleBackgroundHighlighter = tabTitleBackgroundHighlighter
        
        // Convert TupleView into an array of views
        let contentTuple = contents().value
        self.tabContents = [contentTuple.0, contentTuple.1, contentTuple.2, contentTuple.3]
    }
    
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(tabs.indices, id: \.self) { index in
                    VStack(spacing: 0) {
                        ZStack {
                            if tabTitleBackgroundHighlighter && selectedTab == index {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 80, height: 40)
                                    .matchedGeometryEffect(id: "tabBackground", in: animationNamespace)
                            }
                            Text(tabs[index])
                                .foregroundColor(selectedTab == index ? .blue : .gray)
                                .fontWeight(selectedTab == index ? .bold : .regular)
                                .frame(width: 80, height: 40)
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedTab = index
                            }
                        }
                        
                        if barBottomTab {
                            if selectedTab == index {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue.opacity(0.5))
                                    .frame( width:80 ,height: 4 ).padding(0)
                                    .matchedGeometryEffect(id: "tabBackground", in: animationNamespace).background(Color.clear).padding(0)
                            }
                            else {
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.clear)
                                    .frame( width:80 ,height: 4 ).padding(0)
                                
                                
                            }
                        }
                    }
                }
            }
            .padding(.top, 20)
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(tabContents.indices, id: \.self) { index in
                        tabContents[index]
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .contentShape(Rectangle())
                    }
                }
                .offset(x: -CGFloat(selectedTab) * geometry.size.width + dragOffset)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            if !(selectedTab == 0 && value.translation.width > 0) &&
                                !(selectedTab == tabs.count - 1 && value.translation.width < 0) {
                                state = value.translation.width
                            }
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            if value.translation.width < -threshold, selectedTab < tabs.count - 1 {
                                withAnimation { selectedTab += 1 }
                            } else if value.translation.width > threshold, selectedTab > 0 {
                                withAnimation { selectedTab -= 1 }
                            }
                        }
                )
                .animation(.interactiveSpring(), value: dragOffset)
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
        }
        .padding()
    }
}
//
//struct ContentView: View {
//    var body: some View {
//        SlidingTabsView(
//            tabs: ["Home", "Search", "Profile", "Settings"],
//            barBottomTab: true,
//            tabTitleBackgroundHighlighter: true
//        ) {
//            VStack { Text("Home Content").font(.title).padding() }
//            VStack { Text("Search Content").font(.title).padding() }
//            VStack { Text("Profile Content").font(.title).padding() }
//            VStack { Text("Settings Content").font(.title).padding() }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
