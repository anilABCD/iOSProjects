//
//  ContentView.swift
//  SwiftUITabs
//
//  Created by Anil Kumar Potlapally on 08/05/24.
//

import SwiftUI

// First Tab: A simple list with a navigation title
struct HomeView: View {
    var body: some View {
        NavigationStack {
          
                List {
                    ForEach(1...10, id: \.self) { item in
                        NavigationLink("Item \(item)" , value: item)
                    }
                    
                }  .navigationDestination(for: Int.self
                ) { item in
                    
                    Text( item , format: .number )
                }
                .navigationTitle("Home")
           
        }
    }
}

// Second Tab: A search view with a simple search bar
struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        VStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if searchText.isEmpty {
                Text("No results")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(1...5, id: \.self) { item in
                        Text("Result \(item)")
                    }
                }
            }
        }
        .padding()
    }
}

// Third Tab: A profile view with some personal information
struct ProfileView: View {
    var body: some View {
        VStack {
            Image("person.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()

            Text("John Doe")
                .font(.title)
                .padding()

            Text("iOS Developer")
                .foregroundColor(.gray)

            Spacer()
        }
    }
}

// TabView setup with multiple distinct views
struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
