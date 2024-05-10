//
//  ContentView.swift
//  List1ImageAndText
//
//  Created by Anil Kumar Potlapally on 10/05/24.
//



import SwiftUI

// Define a simple data structure for your list items, including an image URL
struct ListItem: Identifiable {
    let id = UUID()
    let imageUrl: URL?
    let title: String
    let isFavourite : Bool?
}

// Define a sample list of items
let sampleItems = [
    ListItem(imageUrl: URL(string: "https://placehold.co/400.jpeg"), title: "Item 1", isFavourite: true ),
    ListItem(imageUrl: URL(string: "https://placehold.co/400.jpeg"), title: "Item 2", isFavourite: false),
    ListItem(imageUrl: URL(string: "https://placehold.co/400.jpeg"), title: "Item 3", isFavourite: true),
    ListItem(imageUrl: URL(string: "https://placehold.co/400.jpeg")!, title: "Item 4", isFavourite: false)

]

struct ClickableExternalImageTextListView: View {
    var items: [ListItem]

    var body: some View {
        List(items) { item in
            Button(action: {
                // Define the action to take when the image is clicked
                print("Clicked on \(item.title)")
            }) {
                HStack {
                    AsyncImage(
                        url: item.imageUrl,
                        content: { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40) // Adjust the size
                        },
                        placeholder: {
                            // Display a placeholder while the image is loading
                            ProgressView()
                        }
                    )

                    Text(item.title)
                        .font(.headline) // Set the font style
                    
                    Spacer()
                   
                    Image(systemName: item.isFavourite ?? false ? "star.fill": "star")
                }
                .padding() // Add some padding around the HStack
            }
        }
        .listStyle(PlainListStyle()) // Choose a list style
    }
}

// The ContentView for your SwiftUI app
struct ContentView: View {
    var body: some View {
           ClickableExternalImageTextListView(items: sampleItems) // Pass in the sample list of items
       }
}


#Preview {
    ContentView()
}
