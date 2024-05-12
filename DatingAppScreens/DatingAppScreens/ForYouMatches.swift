//
//  ForYouMatches.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 12/05/24.
//

import Foundation
//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI





struct ForYouMatches : View {
    
    
    @State private var currentIndex = -1 ;
    
    @State private var slides: [Slide] = [
        Slide( name: "John", age: 25, imageName: "filter", heading: "experice in swiftui", experience: 4, technology: "#swiftui"),
        Slide( name: "Anil", age: 25, imageName: "menu", heading: "experice in swift", experience: 4, technology: "#swift"),
        Slide( name: "Kumar", age: 25, imageName: "filter", heading: "experice in react", experience: 4, technology: "#react"),
    ]
    
    @State var technologies : [String] = [ "#Swift UI" , "#Backend" , "#front end" ]
    
    
    var body: some View {
   
        VStack {
            HStack {
                ScrollView (.horizontal ) {
                    
                    HStack {
                        ForEach (technologies  , id: \.self) { technology in
                            
                            Text("\(technology)").onTapGesture {
                                
                                print("old devs clicked")
                                
                            }.padding(5).foregroundColor(.white).background(.blue).cornerRadius(30).font(.system(size:15))
                            
                        }
                    }
                }
            } .frame( maxWidth: UIScreen.main.bounds.width - 100)
            
            SlideshowView(slides: slides)
            
            Spacer()
        }.frame(alignment:.topLeading)
          
      
    }
     
}




struct SlideshowView: View {
    @State private var slides: [Slide]
    @State private var currentIndex = 0
    
    init(slides: [Slide]) {
        self._slides = State(initialValue: slides)
    }
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach( Array(slides.enumerated()), id: \.element.id) { index, item in
                VStack {
                    Image(item.imageName )
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
                    VStack(alignment: .leading, spacing: 10 ) {
                        
                      
                            Text("Name :")
                                .font(.headline)
                        Text("\(item.name)");
                       
                        
                        Button("Add Slide") {
                                       slides.append(    Slide( name: "hello", age: 25, imageName: "filter", heading: "experice in swiftui", experience: 4, technology: "#swiftui"))
                                   }
                        
//
//                            Text("Age:")
//                                .font(.headline)
//
//                        Text("\(profile.age)");
//
//
//                            Text("Technology :")
//                                .font(.headline)
//
//                        Text("\(profile.technology)");
//
//
//
//                            Text("Experience :")
//                                .font(.headline)
//
//                        Text("\(profile.experience)");
                 
                        
                    }
                    .frame( maxWidth:.infinity , alignment:.topLeading )
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
               .frame(maxWidth: .infinity, alignment: .top) .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())  .border(Color.brown).frame(alignment: .topLeading)
        
//        Picker(selection: $currentIndex, label: EmptyView()) {
//                   ForEach(slides.indices, id: \.self) { index in
//                       Text("\(index + 1)")
//                   }
//               }
//               .pickerStyle(SegmentedPickerStyle())
//               .padding()
    }
}


struct Slide : Identifiable {
    
    let id = UUID()
    var name: String
    var age: Int
    var imageName: String
    var heading: String
    var experience : Int ;
    var technology : String;
}



struct Person {
    var name: String
    var age: Int
}

struct perosnss: View {
    @State private var people: [Person] = [
        Person(name: "Alice", age: 30),
        Person(name: "Bob", age: 25),
        Person(name: "Charlie", age: 35)
    ]
    
    var body: some View {
        VStack {
            ForEach(people, id: \.name) { person in
                VStack {
                    Text("Name: \(person.name)")
                    Text("Age: \(person.age)")
                }
                .padding()
            }
        }
    }
}
