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
        
        HStack {
            
            Image("menu").resizable().frame(width: 25, height: 25)
                          .font(.title)
                    
//                              .border(Color.gray, width: 2)
                          .cornerRadius(4)
                          .onTapGesture {
                              print("Menu clicked")
                          }
            
            
            Spacer()
            
            Text("Devo").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
           
            
            Spacer()
            
            Image("filter").resizable().frame(width: 25, height: 25)
                          .font(.title)
                    
//                              .border(Color.gray, width: 2)
                          .cornerRadius(4)
                          .onTapGesture {
                              print("Filter clicked")
                          }
            
            
        }.padding()
        
        
        TabView(selection: $selectedTab) {
            MatchesScreenView()
                .tabItem {
                    Label("Matches", systemImage: "heart").background(.green)
                }
                .tag(0)
            
            Text("Hello")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass").background(.green)
                }
                .tag(1)
            
            MatchesScreenView()
                .tabItem {
                    Label("Questions", systemImage: "plus").background(.green)
                }
                .tag(2)
            
            MatchesScreenView()
                .tabItem {
                    Label("Messages", systemImage: "message").background(.green)
                }
                .tag(3)
            
        }.accentColor(Color.green)

    }
}

#Preview {
    ContentView()
}
