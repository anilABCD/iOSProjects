//
//  DatingAppScreensApp.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI

import UserNotifications

import GoogleSignIn
import FacebookLogin



func storeDeviceNotificationToken(_ userId: String) {
    UserDefaults.standard.set(userId, forKey: "deviceNotificationToken")
}

func getDeviceNotificationToken() -> String? {
    return UserDefaults.standard.string(forKey: "deviceNotificationToken")
}



func setUserOnline(userId: String, accessToken : String)  async {
    
    
//
//    
//    let urlRequest = try createURLRequest(method : "POST" , baseURL: "\(Constants.localhost)/matches/", accessToken: accessToken, data: nil, parameters: nil)
//
//     let response: MatchesResponse = try await fetchData(from: urlRequest)
//   
//
    
    print("online executed");
    
//    guard let url = URL(string: "\(Constants.localhost)/user/\(userId)/online") else { print("bad url"); return }
    
    
    do {
       
    
    
    let data = ProfileEncodable() ;

        let urlRequest = try createURLRequest(method : "POST" , baseURL: "\(Constants.localhost)/user/\(userId)/online", accessToken: accessToken , data:data , parameters: nil)
        
        let response: Profile = try await fetchData(from: urlRequest)
    
    print(" online response" , response)
        
        
        print ( "is Online" , response.isOnline)
        
    }
    catch{
        let errorMessage = error.localizedDescription
                 print("Caught an error: \(error)")
        
        print (errorMessage)
    }
    
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error setting user online: \(error)")
//            return
//        }
//        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
//            print("User set to online successfully")
//        } else {
//            print("Failed to set user online")
//        }
//    }
//    
//    task.resume()
}

func setUserOffline(userId: String, accessToken : String) async {
    
    do {
        
    let data = ProfileEncodable() ;

        let urlRequest = try createURLRequest(method : "POST" , baseURL: "\(Constants.localhost)/user/\(userId)/offline", accessToken: accessToken , data:data , parameters: nil)
        
        let response: Profile = try await fetchData(from: urlRequest)
    
        
        print ( "is Online" , response.isOnline)
    
}
catch{
    let errorMessage = error.localizedDescription
             print("Caught an error: \(error)")
    
    print (errorMessage)
}
//    guard let url = URL(string: "\(Constants.localhost)/user/\(userId)/offline") else { return }
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error setting user offline: \(error)")
//            return
//        }
//        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
//            print("User set to offline successfully")
//        } else {
//            print("Failed to set user offline")
//        }
//    }
//    
//    task.resume()
}


class TokenManager: ObservableObject {
    
     @AppStorage("accessToken") var accessToken: String = ""
     @AppStorage("userId") var userId: String = ""
     @AppStorage("email") var email: String = ""
     @AppStorage("name") var name: String = ""
     @AppStorage("technologies") var technologies: String = ""
     @AppStorage("experience") var experience: String = ""
     @AppStorage("photo") var photo: String = ""
     @AppStorage("hobbies") var hobbies: String = ""
     @AppStorage("bio") var bio: String = ""
     @AppStorage("jobRole") var jobRole : String = ""
    
  
    @AppStorage("notificationsSettings") var notificationSettings : String = ""
    @AppStorage("locationSettings") var locationSettings : String = ""

    
    @AppStorage("smoking") var smoking: String = ""
    @AppStorage("drinking") var drinking: String = ""
    @AppStorage("dob") var dob: String = ""
    
    
    @Published var homeTabView : HomeTabEnumViews? = nil;
    @Published var shouldRefecthUnreadCount : UUID = UUID();
    
    
    @Published var nextButtonWhenRegistrationProcess : UUID = UUID();
    @Published var backButtonWhenRegistrationProcess : UUID = UUID();
    
    
    
    @Published var isMenuView : Bool = false;
    
    
    @Published var isKeyboardOpen : Bool = false;
    
    
    @Published var gotToNotificationsPage : Bool = false;
 
//    @Published  var localhost : String = "http://169.254.23.107:8000"
    @Published var localhost : String = Constants.localhost;
    
    func updateAccessToken( token: String , userId: String , email : String , name : String , photo:String , technologies : String , hobbies : String , bio : String , jobRole : String ) {
     
        self.userId = userId
        self.accessToken = token
        self.photo = photo

        self.email = email
        self.name = name;
        self.technologies = technologies;
        self.hobbies = hobbies
        self.bio = bio
        self.jobRole = jobRole
        print ( "User Id" , self.userId , token , email , name , photo , bio , technologies , hobbies , jobRole )
    }
    
    func isProfileDobSmokingDrinkingEmpty() -> Bool {
        
        if( self.dob == "" || self.drinking == "" || self.smoking == "" ){
            
            return true;
        }
        
        return false
    }
    
    func updateProfileDobSmokingDrinkingEmpty( dob: String , drinking : String , smoking : String) {
        print (dob , "dob date of birth value")
        self.dob = dob;
        self.drinking = drinking
        self.smoking = smoking
        
    }
    
    
    func updatePhoto ( photo : String){
        self.photo = photo;
    }
    
    func resetAccessToken () {
        self.accessToken = ""
        self.email = ""
        self.name = ""
        self.photo = ""
        self.technologies = ""
        self.hobbies = ""
        self.dob = ""
        self.drinking = ""
        self.smoking = ""
        self.bio=""
        self.jobRole = ""
//        self.notificationSettings = "";
//        self.locationSettings = "";
    }
}

struct DeepLinkData : Equatable {
    var view: String
    var parameters: [String: String]
    
    
    static func == (lhs: DeepLinkData, rhs: DeepLinkData) -> Bool {
        return lhs.view == rhs.view && lhs.parameters == rhs.parameters
    }
}


@main
struct DatingAppScreensApp: App {
    @StateObject private var dataFetcher = DataFetcher(pollingInterval: 60) // Example with 60 seconds interval

    @State private var deepLinkData: DeepLinkData?

    @StateObject private var tokenManager = TokenManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplashScreen = true
    
    var body: some Scene {

        WindowGroup {
                        
              ZStack {
                  
                if showSplashScreen {
                               SplashScreenView()
                                   .transition(.opacity)
                                   .onAppear {
                                       DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                           withAnimation {
                                               showSplashScreen = false
                                           }
                                       }
                                   }
                }
                else
                {
                
                    ContentView(isHome: false , deepLinkData: $deepLinkData).environmentObject(tokenManager).environmentObject(dataFetcher)
                        .onOpenURL { url in
                                           // First, try to handle Google Sign-In URL
                                           if GIDSignIn.sharedInstance.handle(url) {
                                               return
                                           }
                                           // If not handled by Google, handle the URL with parameters
                                           handleURL(url)
                    
                    }.onAppear {
                                   GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                                       // Check if `user` exists; otherwise, do something with `error`
                               }
                    
                    }.transition(.opacity)
                               
                    
                }
                      
            }
            
        }
    }
    

    private func handleURL(_ url: URL) {
        // Parse the URL to determine which view to navigate to and extract parameters
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let host = components?.host else { return }
        
        // Extract query items
        var parameters: [String: String] = [:]
        components?.queryItems?.forEach { item in
            parameters[item.name] = item.value
        }
        
        deepLinkData = DeepLinkData(view: host, parameters: parameters)
        
        print ("deepLinkData" , deepLinkData)
        
    }
    
}



//
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        // Set the notification center delegate
//        UNUserNotificationCenter.current().delegate = self
////
////        // Request permission to show notifications
////        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
////            print("Permission granted: \(granted)")
////            if granted {
////                DispatchQueue.main.async {
////                    application.registerForRemoteNotifications()
////                }
////            } else if let error = error {
////                print("Request authorization failed: \(error.localizedDescription)")
////            }
////        }
//
//        return true
//    }
//    
//    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        // Convert device token to string
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//        
//        storeDeviceNotificationToken(token);
//
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register: \(error.localizedDescription)")
//    }
//
//    // MARK: - UNUserNotificationCenterDelegate Methods
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .badge, .sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        print("Received notification: \(userInfo)")
//        completionHandler()
//    }
//    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//           // Handle app becoming active
//           print("App became active")
//           // Perform operations like updating user status
//       }
//
//       func applicationDidEnterBackground(_ application: UIApplication) {
//           // Handle app entering background
//           print("App entered background")
//           // Perform operations like updating user status
//       }
//}


