//
//  ContentView.swift
//  SwfitUINavigationApp
//
//  Created by Anil Kumar Potlapally on 06/05/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        
//        NavigationStack(path: $path) {
//            List {
////                
////                NavigationLink("Simple A", value:"ABC")
////                NavigationLink("Simple B", value:"BBV")
//                
//                Button("Navigate to ABC"){
//                    path.append("abc")
//                }
//                Button("Navigate to BBV"){
//                    path.append("bbv")
//                }
//                Button("Navigate to XYZ"){
//                    path.append("xyz")
//                }
//                
//            }.navigationDestination(for: String.self ) { string in
//                    
//                Text(string)
//            }
//            
            
//        }
        
        
        NavigationStack ( path : $path) {
            
            List {
                Section("People") {
                    
                    ForEach( Person.examples ) { person in
                        
                        NavigationLink( value : person ) {
                            VStack (alignment:.leading){
                                Text(person.name)
                                Text(person.age, format: .number)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                    }
                }
            }.navigationDestination(for: Person.self) { person in
                
                VStack {
                    Text(person.name)
                    Text(person.age , format: .number)
                }
                  
                
            }
        }
        
//        @State private var path: [String] = ["Apple", "Banana", "Cherry"]
//
//        NavigationView {
//            // List to display and edit items
//                            List {
//                                ForEach($path.indices, id: \.self) { index in
//                                    HStack {
//                                        Text(path[index]) // Binding to edit items
//                                    }
//                                }
//                                .onDelete { indexSet in
//                                    path.remove(atOffsets: indexSet) // Delete items from the list
//                                }
//                            }
//                   .navigationTitle("Fruits") // Set the title of the navigation bar
//               }
    }
}

#Preview {
    ContentView()
}
