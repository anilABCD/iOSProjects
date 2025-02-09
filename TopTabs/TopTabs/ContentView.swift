//
//  ContentView.swift
//  TopTabs
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//

import SwiftUI
struct MatchedGeometrySlidingTabs: View {
    @Namespace private var animationNamespace
    @State private var selectedTab = 0
    let tabs = ["Home", "Search", "Profile", "Settings"]
    @State private var previousTab = 0  // To track direction
    @GestureState private var dragOffset: CGFloat = 0
    
    @State var barBottomTab = false;
    @State var tabTitleBackgroundHighlighter = true ;
    
    
    var body: some View {
        VStack {
            // Tab Bar (Static, No Offset)
            HStack(spacing: 10) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    
                    VStack(alignment: .leading, spacing: 0) {  // Set spacing to 0

                        
                        
                        ZStack {
                            
                            if tabTitleBackgroundHighlighter {
                                if selectedTab == index {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue.opacity(0.2))
                                        .frame( width:80 ,height: 40 ).padding(0)
                                        .matchedGeometryEffect(id: "tabBackground", in: animationNamespace).padding(0)
                                }
                            }
                            
                            Text(tabs[index])
                                .foregroundColor(selectedTab == index ? .blue : .gray)
                                .fontWeight(selectedTab == index ? .bold : .regular)
                                .padding(0)
                                .frame( width:80 ,height: 40 ).padding(0)
                            //                            .matchedGeometryEffect(id: "tabText\(index)", in: animationNamespace)
                        }.frame(height: 40)  // Ensures it doesn’t expand beyond text height
                           
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                previousTab = selectedTab  // Store previous tab index
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
                        
                    }.frame(alignment: .top).padding(0)
                }
            }
            .padding(.top, 20)

            // Step-by-Step Sliding Content View
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            ForEach(0..<tabs.count, id: \.self) { index in
                                
                                VStack ( spacing : 20 ) {
                                    
                                    
                                    Rectangle()
                                        .fill(Color(
                                            red: Double.random(in: 0...1),
                                            green: Double.random(in: 0...1),
                                            blue: Double.random(in: 0...1)
                                        ))
                                        .frame(height: 100)
                                        .padding()

                                    
                                    Text("Content for \(tabs[index])")
                                        .font(.title)
                                        .padding()
                                       
                                        .background(Color.blue.opacity(0.1))
                                    
                                        .cornerRadius(15)
                                    
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width:300, height: 300)
                                        .opacity(0.1)
                                        
                                     
                                } .frame(width: geometry.size.width, height: geometry.size.height) .contentShape(Rectangle()) // Ensures gesture detection is contained
                            }
                        }
                        .offset(x: -CGFloat(selectedTab) * geometry.size.width + dragOffset) // Move in real-time
                        .gesture(
                           
                                               DragGesture()
                                                   .updating($dragOffset, body: { value, state, _ in
                                                       let isAtStart = selectedTab == 0 && value.translation.width > 0 // Prevent right swipe on first tab
                                                       let isAtEnd = selectedTab == tabs.count - 1 && value.translation.width < 0 // Prevent left swipe on last tab
                                                       if !isAtStart && !isAtEnd {
                                                           state = value.translation.width
                                                       }
                                                   })
                                                   .onEnded { value in
                                                       let threshold: CGFloat = 50 // Minimum swipe distance
                                                       if value.translation.width < -threshold, selectedTab < tabs.count - 1 { // Swipe left (next)
                                                           moveTab(forward: true)
                                                       } else if value.translation.width > threshold, selectedTab > 0 { // Swipe right (previous)
                                                           moveTab(forward: false)
                                                       }
                                                   }
                                           )
                                        
                        .animation(.interactiveSpring(), value: dragOffset)  // Smooth real-time drag
                                       .animation(.easeInOut(duration: 0.3), value: selectedTab)  // Smooth snapping
                                       .clipped() // 🔥 Ensures no elements peek into adjacent tabs
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                   

                    Spacer()

            Spacer()
        }
        .padding()
    }
    
    // Function to handle swipe gestures
    private func moveTab(forward: Bool) {
        previousTab = selectedTab
        
        withAnimation {
            if forward {
                selectedTab = (selectedTab + 1) % tabs.count // Move forward, wrap around
            } else {
                selectedTab = (selectedTab - 1 + tabs.count) % tabs.count // Move backward, wrap around
            }
        }
    }
    
    // Function to determine animation direction
    private func shouldMoveForward() -> Bool {
        return (selectedTab > previousTab) || (previousTab == tabs.count - 1 && selectedTab == 0)
    }
}

struct ContentView: View {
    var body: some View {
         
        VStack {
            MatchedGeometrySlidingTabs()
            
         
        }
    }
}


 


#Preview {
    ContentView()
}
