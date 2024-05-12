//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI





struct MatchesScreenView : View {
    
    
    @State private var currentIndex = -1 ;
    
    @State private var slides: [Slide] = [
        Slide( name: "John", age: 25, imageName: "filter", heading: "experice in swiftui", experience: 4, technology: "#swiftui"),
        Slide( name: "Anil", age: 25, imageName: "menu", heading: "experice in swift", experience: 4, technology: "#swift"),
        Slide( name: "Kumar", age: 25, imageName: "filter", heading: "experice in react", experience: 4, technology: "#react"),
    ]
  
    @State var isNewDevMatches : Bool = false;
       
    
    var body: some View {
        VStack {
            
            
            HStack ( spacing:10) {
                
                
                Button("New Devs"){
                    
                    print("new devs clicked")
                    
                    isNewDevMatches = true;
                    
                }.padding().background(.green).foregroundColor(.white).cornerRadius(30).padding(.horizontal)
                
              
                Button("For You"){
                    
                    print("old devs clicked")
                    
                    isNewDevMatches = false;
                    
                }.padding().background(.green).foregroundColor(.white).cornerRadius(30).padding(.horizontal)
            }
            
            .frame( maxWidth: .infinity , alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(20)
            
            if isNewDevMatches {
                
               MatchesNewDevsView()
                
            }
            else {
                
                ForYouMatches()
                
            }
        
        }
        .frame(  maxHeight: .infinity , alignment: .topLeading )
        .padding()
    }
}

