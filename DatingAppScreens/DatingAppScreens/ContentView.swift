//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI


struct ContentView: View {
    
    @State private var selectedTab = 0
    @EnvironmentObject private var tokenManager: TokenManager
    
    @State var path :[MyNavigation<String>] = []
   
    

  
    var body: some View {
        
        ZStack {
        
            
            VStack {
                
                if ( tokenManager.accessToken == "" || tokenManager.technologies == "" || tokenManager.photo == "" ) {
                    
                    VStack {
                        
                        NavigationStack(path: $path) {
                            
                            Group {
                                if tokenManager.accessToken.isEmpty {
                                    
                                    LoginView(path: $path)
                                } else
                                if tokenManager.photo.isEmpty {
                                    
                                    UploadYourPhotoView(path:$path)
                                    
                                } else if tokenManager.photo.isEmpty {
                                    UploadYourPhotoView(path: $path)
                                } else {
                                    LoginView(path: $path)
                                }
                            } .navigationDestination(for: MyNavigation<String>.self) { view in
                                switch view.appView {
                                case .signIn:
                                    LoginView(path:$path)
                                case .signUp:
                                    RegisterView(path:$path)
                                case .page1:
                                    UploadYourPhotoView(path: $path)
                                case .page2:
                                    Text("Page 2")
                                case .home:
                                    Text("Technologies")
                                }
                            }
                        }  .onChange(of: tokenManager.accessToken) { newValue in
                            if !newValue.isEmpty {
                                path.append(MyNavigation<String>(appView: .page1, params: Params<String>(data: "")))
                            } else {
                                path.append(MyNavigation<String>(appView: .signIn, params: Params<String>(data: "")))
                            }
                        }.onChange(of: tokenManager.photo ) { newValue in
                            if !newValue.isEmpty {
                                path.append(MyNavigation<String>(appView: .home, params: Params<String>(data: "")))
                            } else {
                                path.append(MyNavigation<String>(appView: .page1, params: Params<String>(data: "")))
                            }
                        }
                       
                        
                        
                    }.frame( maxWidth:.infinity)
                                 .navigationBarTitle("", displayMode: .inline)
                    
                } else {
                    
                    Button("Reset Token"){
                        tokenManager.resetAccessToken()
                    }
                    
                    VStack {
                        TabView(selection: $selectedTab) {
                            
                            HomeView()
                                .tabItem {
                                    Label("Matches", systemImage: "heart")
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
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let tokenManager = TokenManager()
        ContentView()
            .environmentObject(tokenManager)
    }
}
