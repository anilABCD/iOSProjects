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
    
    public let appView : HomeTabEnumViews;
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

enum HomeTabEnumViews {
    case home
    case page1
    case page2
    case page3
    case page4
    case page5
    case page6
    case notificationPermissionPage
    case signIn
    case signUp
}


struct HomeView: View {
    @State var path :[MyNavigation<String>] = []
   
    @State private var selectedTab = 0
    
    @EnvironmentObject private var tokenManager : TokenManager;
    @EnvironmentObject private var themeManager : ThemeManager;
  
    
     @State private var permissionGranted = false
     
    @StateObject private var locationManager = LocationManager()
      
    var body: some View {
        
       
            VStack {
   
                NavigationStack(path: $path) {
                    
                    MatchesScreenView(path:$path).background(themeManager.currentTheme.backgroundColor).navigationDestination(for: MyNavigation<String>.self) { view in
                        switch view.appView {
                        case .home:
                            Text("Page 1")
                        case .page1:
                            ProfileView(path: $path)
                        case .page2:
                            Text("Page 2")
                        case .page3:
                            Text("Page 3")
                        case .page4 :
                            Text("Page 4")
                        case .page5:
                             Text("Page 5")
                        case .page6:
                             Text("Page 6")
                        case .signIn:
                            Text("sign In")
                        case .signUp:
                            Text("sign Up")
                        case .notificationPermissionPage:
                            Text("Notification Permission Page")
                        }
                    }
                } .onAppear {
                    
                    updateNavigationBarColor()
                    
//                    // Check the current status when the screen appears
//                    checkNotificationPermission { isGranted in
//                        permissionGranted = isGranted
//                        if !isGranted {
//                            requestNotificationPermission { granted in
//                                permissionGranted = granted
//                            }
//                        }
//                    }
                }.onChange(of: tokenManager.homeTabView ) { newValue in
                    if let newValue = newValue {
                        if newValue == .page1 {
                            path.append(MyNavigation<String>(appView: .page1, params: Params<String>(data: "")))
                        }
                    } else {
                        path.append(MyNavigation<String>(appView: .signIn, params: Params<String>(data: "")))
                   }
                }
               
                
                
                
            }.background(themeManager.currentTheme.backgroundColor).frame( maxWidth:.infinity)
            .navigationBarTitle("", displayMode: .inline)
            
       
           
        
    }
    
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    
    func updateNavigationBarColor() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
           
            appearance.backgroundColor = UIColor(themeManager.currentTheme.backgroundColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor( themeManager.currentTheme.id == "light" ? .black : themeManager.currentTheme.primaryColor)] // Title color
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
}

#Preview {
    HomeView().environmentObject(TokenManager())
}

