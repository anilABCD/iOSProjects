//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI



struct ContentView: View {
    
    @State private var selectedTab = 0
   
    var body: some View {
        
        ZStack {
            
            VStack {
                
              
                
                
                                TabView(selection: $selectedTab) {
                                   HomeView()
                                        .tabItem {
                                            Label("Matches", systemImage: "heart").background(.green)
                                        }
                                        .tag(0)
                
                                    Text("Hello")
                                        .tabItem {
                                            Label("Search", systemImage: "magnifyingglass").background(.green)
                                        }
                                        .tag(1)
                
                                    Text("Hello2")
                                        .tabItem {
                                            Label("Questions", systemImage: "plus").background(.green)
                                        }
                                        .tag(2)
                
                                    Text("Hello3")
                                        .tabItem {
                                            Label("Messages", systemImage: "message").background(.green)
                                        }
                                        .tag(3)
                
                                }
                                .accentColor(Color.green)
                
                
            }.frame( maxWidth:.infinity )
            .navigationBarTitle("", displayMode: .inline)
            
         
        }
       
    }
}

#Preview {
    ContentView()
}



