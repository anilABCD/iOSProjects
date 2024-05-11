//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI


struct MatchesScreenView : View {
    
    @State private var profiles = [
           Profile(name: "John", age: 30, imageName: "menu", heading: "Profile 1"),
           Profile(name: "Alice", age: 25, imageName: "filter", heading: "Profile 2"),
           Profile(name: "Bob", age: 35, imageName: "menu", heading: "Profile 3")
    ];
    
    @State private var currentIndex = -1 ;
    
    
    
    @State var isNewDevMatches : Bool = true;
       
    
    var body: some View {
        VStack {
            
            
            HStack ( spacing:50) {
                
                
                Button("New Devs"){
                    
                    print("new devs clicked")
                    
                    isNewDevMatches = true;
                    
                }.padding().background(.green).foregroundColor(.white).cornerRadius(30)
                
                
                
                Button("Old Devs") {
                    
                    print("old devs clicked")
                    
                    isNewDevMatches = false;
                    
                }.padding().background(.green).foregroundColor(.white).cornerRadius(30)
                
                
            }.frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            if isNewDevMatches {
                
               MatchesNewDevsView()
                
            }
            else {
                
                Text("Hello")
                
            }
        
        }
        .frame( maxHeight: .infinity , alignment: .topLeading )
        .padding()
    }
}

