//
//  SlidingTabsFourView 2.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 29/03/25.
//


import SwiftUI

struct SlidingTabsTwoView<Content1: View, Content2: View>: View {
    @Namespace private var animationNamespace
    @Namespace private var animationNamespace2
    @State private var selectedTab: Int
    let tabs: [String]
    let barBottomTab: Bool
    let tabTitleBackgroundHighlighter: Bool
    let isSecondarTabs : Bool
    let   showBottomLine : Bool
    let  showSeperator : Bool
    
    let tabContents: [AnyView] // ✅ Now it's an array!

    @EnvironmentObject var tokenManager : TokenManager
   
    init(
        tabs: [String],
        initialIndex: Int = 0,
        barBottomTab: Bool = false,
        tabTitleBackgroundHighlighter: Bool = true,
        isSecondarTabs : Bool = false,
        showBottomLine : Bool = true,
        showSeperator : Bool = false ,
        
        @ViewBuilder contents: () -> TupleView<(Content1, Content2)>
    ) {
        self.tabs = tabs
        self._selectedTab = State(initialValue: initialIndex)
        self.barBottomTab = barBottomTab
        self.tabTitleBackgroundHighlighter = tabTitleBackgroundHighlighter
        
        self.isSecondarTabs = isSecondarTabs
        
        self.showBottomLine = showBottomLine
        self.showSeperator = showSeperator
        
        let contentTuple = contents().value
        self.tabContents = [AnyView(contentTuple.0), AnyView(contentTuple.1)] // ✅ Convert tuple to array
    }
    
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            
            if tokenManager.hideTopTabBar == false {

                HStack(spacing: 10) {
                    ForEach(tabs.indices, id: \.self) { index in
                        
                        
                        VStack(spacing: 0) {
                            
                            
                            
                            ZStack {
                                if tabTitleBackgroundHighlighter && selectedTab == index {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue.opacity(0.2))
                                        .frame(width: 100, height: 40)
                                        .matchedGeometryEffect(id: "tabBackground", in: animationNamespace)
                                }
                                Text(tabs[index])
                                    .foregroundColor(selectedTab == index ? .blue : .gray)
                                    .fontWeight(selectedTab == index ? .bold : .regular)
                                    .frame(width: 100, height: 40)
                            }.padding(.vertical, 10)
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
                        
                        if (showSeperator) {
                            // Add separator if it's not the last tab
                            if index < tabs.count - 1 {
                                Rectangle()
                                    .frame(width: 1, height: 30) // Separator height
                                    .foregroundColor(.gray.opacity(0.5))
                                    .padding(.horizontal, 5)
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    VStack {
                        Spacer() // Pushes the border to the bottom
                        
                        if ( showBottomLine) {
                            Rectangle()
                                .frame(height: 1) // Border thickness
                                .foregroundColor( isSecondarTabs ? Color.gray.opacity(0.3) : Color .black) // Border color
                                .frame(maxWidth: .infinity) // Full width
                        }
                        
                    }
                )
            }
            
            
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
