//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI





struct MatchesScreenView : View {

    @State private var currentIndex = -1 ;
    @EnvironmentObject private var tokenManger : TokenManager
    
    @Binding var path :[MyNavigation<String>]
    
    @State private var isMenuVisible = true
 
    @State var isNewDevMatches : Bool = true;
       
    
    var body: some View {
        
        
        ZStack {
            VStack {
                
//                HStack {
//                    
//                    Image("menu").resizable().frame(width: 25, height: 25)
//                        .font(.title)
//                    
//                        .cornerRadius(4)
//                        .onTapGesture {
//                            withAnimation {
//                                isMenuVisible.toggle()
//                            }
//                            
//                            print("\(tokenManger.localhost)/\(tokenManger.photo)")
//                        }
//                    
//                    
//                    Spacer()
//                    
//                    Text("Devo").fontWeight(.bold)
//                    
//                    
//                    Spacer()
//                    
//                    Image("filter").resizable().frame(width: 25, height: 25)
//                        .font(.title)
//                    
//                    //                              .border(Color.gray, width: 2)
//                        .cornerRadius(4)
//                        .onTapGesture {
//                            print("Filter clicked")
//                            
//                            
//                            
//                        }
//                    
//                    
//                }.frame(width: UIScreen.main.bounds.width - 50).padding(.horizontal, 30)
//                
                
//                HStack ( spacing:10) {
//                    
//                    
//                    Button("New Devo"){
//                        
//                        print("new devs clicked")
//                        
//                        isNewDevMatches = true;
//                        
//                    }.padding().background( isNewDevMatches ? .green : .gray).foregroundColor(.white).cornerRadius(30).padding(.horizontal)
//                    
//                    
////                    Button("You"){
////                        
////                        print("old devs clicked")
////                        
////                        isNewDevMatches = false;
////                        
////                    }.padding().background( !isNewDevMatches ? .green : .gray).foregroundColor(.white).cornerRadius(30).padding(.horizontal)
//                }
//                
//                .frame( maxWidth: .infinity , alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(20)
                
                if isNewDevMatches {
                    
                    MatchesNewDevsView().padding(.bottom)
                    
                }
                else {
                    
                    ForYouMatches()
                    
                }
                
            }
            .frame(  maxHeight: .infinity , alignment: .topLeading )
      
            
            
//
//                Color.black.opacity( isMenuVisible ? 0.5 : 0).edgesIgnoringSafeArea(.all)
//                    .onTapGesture {
//                        withAnimation {
//                            isMenuVisible.toggle()
//                        }
//                    }
//                
//                
//   
//            
//            SideMenuView(isMenuVisible: $isMenuVisible , path: $path
//            )
        }
    }
}


struct  MatchesScreennView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        MatchesScreenView(path: $path).environmentObject(TokenManager())
    }
}



