//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI





struct MatchesScreenView : View {
    
    
    @State private var currentIndex = -1 ;
    
    @Binding var path :[MyNavigation<String>]
    
    @State private var isMenuVisible = false
 
    @State var isNewDevMatches : Bool = true;
       
    
    var body: some View {
        
        
        ZStack {
            VStack {
                
                HStack {
                    
                    Image("menu").resizable().frame(width: 25, height: 25)
                        .font(.title)
                    
                        .cornerRadius(4)
                        .onTapGesture {
                            withAnimation {
                                isMenuVisible.toggle()
                            }
                        }
                    
                    
                    Spacer()
                    
                    Text("Devo").fontWeight(.bold)
                    
                    
                    Spacer()
                    
                    Image("filter").resizable().frame(width: 25, height: 25)
                        .font(.title)
                    
                    //                              .border(Color.gray, width: 2)
                        .cornerRadius(4)
                        .onTapGesture {
                            print("Filter clicked")
                            
                            
                            
                        }
                    
                    
                }.frame(width: UIScreen.main.bounds.width - 50).padding(.horizontal, 30)
                
                
                HStack ( spacing:10) {
                    
                    
                    Button("New Devo"){
                        
                        print("new devs clicked")
                        
                        isNewDevMatches = true;
                        
                    }.padding().background( isNewDevMatches ? .green : .gray).foregroundColor(.white).cornerRadius(30).padding(.horizontal)
                    
                    
//                    Button("You"){
//                        
//                        print("old devs clicked")
//                        
//                        isNewDevMatches = false;
//                        
//                    }.padding().background( !isNewDevMatches ? .green : .gray).foregroundColor(.white).cornerRadius(30).padding(.horizontal)
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
            
            

                Color.black.opacity( isMenuVisible ? 0.5 : 0).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isMenuVisible.toggle()
                        }
                    }
                
                
   
            
            SideMenuView(isMenuVisible: $isMenuVisible , path: $path
            )
        }
    }
}



struct SideMenuView: View {
    @Binding var isMenuVisible: Bool
    @Binding var path :[MyNavigation<String>]
    var body: some View {
         
            GeometryReader { geometry in
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Button("Home"){
                            path = [  MyNavigation<String>(appView: .home, params: Params<String>(data: "hello"))]
                        }
                    }
                    .padding()
                    .frame(width: geometry.size.width / 2 , alignment: .center)
                    .background(Color.white)
                    .offset(x: isMenuVisible ? 0 : -geometry.size.width / 2 )
                    Spacer()
                }
            }
            .frame(maxWidth: 600, alignment: .leading)
        
    }
}
