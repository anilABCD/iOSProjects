//
//  ContentView.swift
//  SwfitUINavigationApp
//
//  Created by Anil Kumar Potlapally on 06/05/24.
//

import SwiftUI

enum AppView {
    case home
    case page1
    case page2
}

struct ContentView: View {
    @State private var path: [AppView] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(path: $path)
                .navigationDestination(for: AppView.self) { view in
                    switch view {
                    case .home:
                        HomeView(path: $path)
                    case .page1:
                        Page1View(path: $path)
                    case .page2:
                        Page2View(path: $path)
                    }
                }
        }
    }
}

struct HomeView: View {
    @Binding var path: [AppView]
    
    var body: some View {
        VStack {
            Text("Home View")
            Button("Go to Page 1") {
                path.append(.page1) // Navigate to Page 1
            }
        }
     //   .navigationBarBackButtonHidden(true) // No back button on home
    }
}

struct Page1View: View {
    @Binding var path: [AppView]
    
    var body: some View {
        VStack {
            Text("Page 1")
            Button("Go to Page 2") {
                path.append(.page2) // Navigate to Page 2
            }
            Button("Go to Home") {
                path = [] // Reset navigation stack to HomeView
            }
        }
    }
}

struct Page2View: View {
    @Binding var path: [AppView]
    
    var body: some View {
        VStack {
            Text("Page 2")
            Button("Go to Home") {
                path = [] // Reset navigation stack to HomeView
            }
        }
    }
}


//struct ContentView: View {
//    
//    @State private var path = NavigationPath()
//    
//    var body: some View {
//        
////        NavigationStack(path: $path) {
////            List {
//////                
//////                NavigationLink("Simple A", value:"ABC")
//////                NavigationLink("Simple B", value:"BBV")
////                
////                Button("Navigate to ABC"){
////                    path.append("abc")
////                }
////                Button("Navigate to BBV"){
////                    path.append("bbv")
////                }
////                Button("Navigate to XYZ"){
////                    path.append("xyz")
////                }
////                
////            }.navigationDestination(for: String.self ) { string in
////                    
////                Text(string)
////            }
////            
//            
////        }
//        
//        
//        NavigationStack ( path : $path) {
//            
//            List {
//                Section("People") {
//                    
//                    ForEach( Person.examples ) { person in
//                        
//                        NavigationLink( value : person ) {
//                            VStack (alignment:.leading){
//                                Text(person.name)
//                                Text(person.age, format: .number)
//                            }.frame(maxWidth: .infinity, alignment: .leading)
//                            
//                        }
//                    }
//                }
//            }.navigationDestination(for: Person.self) { person in
//                
//                VStack {
//                    Text(person.name)
//                    Text(person.age , format: .number)
//                }
//                  
//                
//            }
//        }
//        
////        @State private var path: [String] = ["Apple", "Banana", "Cherry"]
////
////        NavigationView {
////            // List to display and edit items
////                            List {
////                                ForEach($path.indices, id: \.self) { index in
////                                    HStack {
////                                        Text(path[index]) // Binding to edit items
////                                    }
////                                }
////                                .onDelete { indexSet in
////                                    path.remove(atOffsets: indexSet) // Delete items from the list
////                                }
////                            }
////                   .navigationTitle("Fruits") // Set the title of the navigation bar
////               }
//    }
//}

#Preview {
    ContentView()
}
