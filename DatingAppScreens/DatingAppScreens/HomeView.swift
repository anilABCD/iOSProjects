//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI


class Params<T: Equatable & Hashable >: Equatable, Hashable {
    var data: T
    
    init(data: T) {
        self.data = data
    }
    
    static func == (lhs: Params<T>, rhs: Params<T>) -> Bool {
        return lhs.data == rhs.data
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
}


 // example route details
class RouteDetails : Hashable , Equatable {
    var id : String;
    var details : String;
    
    init(id: String, details: String) {
        self.id = id
        self.details = details
    }
    
    static func == (lhs: RouteDetails, rhs: RouteDetails ) -> Bool {
        return lhs.id == rhs.id && lhs.details == rhs.details
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(details)
    }
}

struct MyNavigation<T: Equatable & Hashable >: Equatable, Hashable  {
    
    public let appView : AppView;
    var params : Params<T>;
    
//    init(appView: AppView , params : Params) {
//        self.appView = appView ;
//        self.params = params ;
//    }
    
    static func == (lhs: MyNavigation, rhs: MyNavigation) -> Bool {
           return lhs.appView == rhs.appView && lhs.params == rhs.params
       }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(appView)
           hasher.combine(params)
       }
}

enum AppView {
    case home
    case page1
    case page2
}


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

