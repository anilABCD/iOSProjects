//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI


struct HomeView: View {
    @State var path :[MyNavigation<String>] = []
   
    @State private var selectedTab = 0
  
    var body: some View {
        
       
            VStack {
   
                NavigationStack(path: $path) {
                    
                    MatchesScreenView(path:$path).navigationDestination(for: MyNavigation<String>.self) { view in
                        switch view.appView {
                        case .home:
                            Text("Home")
                        case .page1:
                            Text("Page 1")
                        case .page2:
                            Text("Page 2")
                        }
                    }
                }
                
                
            }.frame( maxWidth:.infinity)
            .navigationBarTitle("", displayMode: .inline)
            
       
        
        
    }
}

#Preview {
    ContentView()
}

