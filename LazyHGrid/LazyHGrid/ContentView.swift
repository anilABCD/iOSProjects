//
//  ContentView.swift
//  LazyHGrid
//
//  Created by Anil Kumar Potlapally on 10/05/24.
//
import SwiftUI

// Define a data model for the grid items
struct GridItemModel: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

// Sample data for the grid
let sampleData = [
    GridItemModel(image: "globe", title: "Globe", description: "A view of the world."),
    GridItemModel(image: "moon.fill", title: "Moon", description: "A view of the moon."),
    GridItemModel(image: "sun.max.fill", title: "Sun", description: "A view of the sun."),
    GridItemModel(image: "tornado", title: "Tornado", description: "A powerful tornado."),
    GridItemModel(image: "umbrella.fill", title: "Umbrella", description: "A protective umbrella."),
]


struct ContentView: View {
    let rows: [GridItem] = [
        GridItem(.flexible())
    ]
    
    @State private var currentIndex = 0 // Track the current index for auto-scrolling
       let autoScrollInterval: TimeInterval = 1.0 // Time interval for auto-scrolling
       let itemCount: Int = 5 // Total number of items in the scroll view

    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) { // Align items to the leading
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 20) {
                        ForEach(sampleData) { item in
                            VStack {
                                Image(systemName: item.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.blue)
                                
                                Text(item.title)
                                    .font(.headline)
                                
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                            .shadow(radius: 5)
                        }
                    }
                    .padding()
                }.frame( maxHeight: 150 )
                
                Spacer().frame(maxHeight:.infinity)
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 20) {
                        ForEach(sampleData) { item in
                            VStack {
                                Image(systemName: item.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                
                                    .foregroundColor(.blue)
                                
                                Text(item.title)
                                    .font(.headline)
                                
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                            .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
                
                VStack {
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 20) {
                            ForEach(sampleData) { item in
                                VStack {
                                    Image(systemName: item.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                    
                                    Text(item.title)
                                        .font(.headline)
                                    
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                                .shadow(radius: 5)
                            }
                        }
                        .padding()
                    }.frame( maxHeight: 150 )
                    
                }.frame( maxHeight: .infinity , alignment: .topLeading ).background(.orange)
                
            }.frame( maxHeight: .infinity , alignment: .topLeading ).background(.green)
            
        
            ScrollView(.horizontal, showsIndicators: false) { // Horizontal scroll view
                        ScrollViewReader { scrollViewProxy in
                            HStack(spacing: 20) { // Horizontal stack with spacing
                                ForEach(0..<itemCount, id: \.self) { index in
                                    Text("Item \(index)")
                                        .frame(width: 200, height: 200)
                                        .background(Color.blue.opacity(0.7))
                                        .cornerRadius(10)
                                }
                            }
                            .padding() // Padding around the content
                            .onAppear {
                                startAutoScroll(scrollViewProxy: scrollViewProxy)
                            }
                        }
                    }
            
            
        }.frame( maxHeight: .infinity ).background(.brown)
        
        
        
    }
    
    private func startAutoScroll(scrollViewProxy: ScrollViewProxy) {
           Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
               withAnimation(.easeInOut(duration: 0.5)) { // Smooth scrolling animation
                   currentIndex = (currentIndex + 1) % itemCount // Cycle through items
                   scrollViewProxy.scrollTo(currentIndex, anchor: .center) // Scroll to the current index
               }
           }
       }
    
}

#Preview {
    ContentView()
}
