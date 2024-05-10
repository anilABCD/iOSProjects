//
//  ContentView.swift
//  LazyVGird
//
//  Created by Anil Kumar Potlapally on 10/05/24.
//

import SwiftUI

// Define a model for the grid items
struct GridItemModel: Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var text: String
}

// Create a sample data source
let sampleData = [
    GridItemModel(image: "star.fill", title: "Star", text: "A bright star."),
    GridItemModel(image: "heart.fill", title: "Heart", text: "A loving heart."),
    GridItemModel(image: "bolt.fill", title: "Bolt", text: "An electric bolt."),
    GridItemModel(image: "flame.fill", title: "Flame", text: "A hot flame."),
    GridItemModel(image: "leaf.fill", title: "Leaf", text: "A green leaf.")
]

// Define the SwiftUI view
struct ContentView: View {
    // Define the grid layout with two columns
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                // Loop through each item in the sample data
                ForEach(sampleData) { item in
                    VStack {
                        // Display the image with a system icon
                        Image(systemName: item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)

                        // Display the title
                        Text(item.title)
                            .font(.headline)
                            .foregroundColor(.primary)

                        // Display the text
                        Text(item.text)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                    .shadow(radius: 5)
                }
            }
            .padding() // Padding around the grid
        }
    }
}
#Preview {
    ContentView()
}
