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
    let tabs = ["Home", "Search", "Profile", "Settings", "More"]
    @State private var previousTab = 0  // To track direction

    var body: some View {
        VStack {
            // Tab Bar (Static, No Offset)
            HStack(spacing: 20) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    ZStack {
                        if selectedTab == index {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.2))
                                .frame(height: 40)
                                .matchedGeometryEffect(id: "tabBackground", in: animationNamespace)
                        }

                        Text(tabs[index])
                            .foregroundColor(selectedTab == index ? .blue : .gray)
                            .fontWeight(selectedTab == index ? .bold : .regular)
                            .padding(.horizontal, 10)
                            .matchedGeometryEffect(id: "tabText\(index)", in: animationNamespace)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            previousTab = selectedTab  // Store previous tab index
                            selectedTab = index
                        }
                    }
                }
            }
            .padding(.top, 20)

            // Step-by-Step Sliding Content View
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            ForEach(0..<tabs.count, id: \.self) { index in
                                Text("Content for \(tabs[index])")
                                    .font(.title)
                                    .padding()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(15)
                            }
                        }
                        .offset(x: -CGFloat(selectedTab) * geometry.size.width) // Moves content step by step
                        .animation(.easeInOut(duration: 0.5), value: selectedTab)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()

                    Spacer()

            Spacer()
        }
        .padding()
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
