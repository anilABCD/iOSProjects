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
import SwiftData


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
    
    // Computed property for accessToken
        var accessToken: String {
            get {
                (try? getToken() ?? "") ?? ""  // ✅ Safe unwrapping
            }
            set {
                do {
                    try saveToken(newValue)
                } catch {
                    print("Error saving token: \(error)")
                }
            }
        }

     @AppStorage("userId") var userId: String = ""
     @AppStorage("email") var email: String = ""
     @AppStorage("name") var name: String = ""
     @AppStorage("technologies") var technologies: String = ""
     @AppStorage("experience") var experience: String = ""
     @AppStorage("photo") var photo: String = ""
    
     @AppStorage("photo1") var photo1: String = ""
     @AppStorage("photo2") var photo2: String = ""
     @AppStorage("photo3") var photo3: String = ""
     @AppStorage("photo4") var photo4: String = ""
    
    // Store location as a string in AppStorage (latitude,longitude)
      @AppStorage("location") var location : String = ""
    
     @AppStorage("gender") var gender: String = ""
    
     @AppStorage("hobbies") var hobbies: String = ""
     @AppStorage("bio") var bio: String = ""
     @AppStorage("jobRole") var jobRole : String = ""
    
  
    @AppStorage("notificationsSettings") var notificationSettings : String = ""
    @AppStorage("locationSettings") var locationSettings : String = ""

    
    @AppStorage("smoking") var smoking: String = ""
    @AppStorage("drinking") var drinking: String = ""
    @AppStorage("dob") var dob: String = ""
    
    @AppStorage("isAdditionalPhotosAdded") var isAdditionalPhotosAdded: Bool = false
    
    @Published var homeTabView : HomeTabEnumViews? = nil;
    @Published var shouldRefecthUnreadCount : UUID = UUID();
    
    
    @Published var nextButtonWhenRegistrationProcess : UUID = UUID();
    @Published var backButtonWhenRegistrationProcess : UUID = UUID();
    

    @Published var isMenuView : Bool = false;
    
 
    @Published var isKeyboardOpen : Bool = false;
    
    
    @Published var gotToNotificationsPage : Bool = false;
 
//    @Published  var localhost : String = "http://169.254.23.107:8000"
    @Published var localhost : String = Constants.localhost;
    
    @Published var serverImageURL : String = Constants.serverImageURL;
    
    func updateAccessToken( token: String , userId: String , email : String , name : String , photo:String , technologies : String , hobbies : String , bio : String , jobRole : String , dob : String , smoking : String , drinking : String , photo1 : String , photo2 : String , photo3: String , photo4 : String , gender: String ) {
        
        saveToken(token)
     
        self.userId = userId
        self.accessToken = token
        self.photo = photo

        self.email = email
        self.name = name;
        self.technologies = technologies;
        self.hobbies = hobbies
        self.bio = bio
        self.jobRole = jobRole
        
        self.dob = dob
        self.drinking = drinking
        self.smoking = smoking
        
        self.photo1 = photo1
        self.photo2 = photo2
        self.photo3 = photo3
        self.photo4 = photo4
        
        self.gender = gender
        
        print ( "User Id" , self.userId , token , email , name , photo , bio , technologies , hobbies , jobRole )
    }
    
    func isProfileDobSmokingDrinkingEmpty() -> Bool {
        
        if( self.dob == "" || self.drinking == "" || self.smoking == "" ){
            
            return true;
        }
        
        return false
    }
    
    
    func updateDob( dob: String ) {
        print (dob , "dob date of birth value")
        self.dob = dob;
    }
    
    
    func updateSmoking(   smoking : String) {
        
        self.smoking = smoking
        
    }
    
    func updateDrinking(   drinking : String) {
        
        self.drinking = drinking
        
    }
    
    func updatePhoto ( photo : String){
        self.photo = photo;
    }
    
    func updatePhoto1 ( photo : String){
        self.photo1 = photo;
    }
    
    func updatePhoto2 ( photo : String){
        self.photo2 = photo;
    }
    
    func updatePhoto3 ( photo : String){
        self.photo3 = photo;
    }
    
    func updatePhoto4 ( photo : String){
        self.photo4 = photo;
    }
    
  
    func setIsAdditionalPhotosAdded ()  {
        
        self.isAdditionalPhotosAdded = true ;
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
        
        self.photo1 = ""
        self.photo2 = ""
        self.photo3 = ""
        self.photo4 = ""
        
        self.gender = ""
        
        self.location = ""
        
        UserDefaults.standard.set(nil, forKey: "lastUpdateTime")
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
    
    
    var sharedModelContainer: ModelContainer = {
         let schema = Schema([ProfileEntity.self]) // Register both
         let container = try! ModelContainer(for: schema)
         return container
     }()
     
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
      
    @State private var deepLinkData: DeepLinkData?

    @StateObject private var tokenManager = TokenManager()
    
    @StateObject private var themeManager = ThemeManager()

    @StateObject private var networkMonitor = NetworkMonitor()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplashScreen = true
    
    var body: some Scene {

        WindowGroup {
                        
              ZStack {
                  
                if showSplashScreen {
                               SplashScreenView()
                                   .transition(.opacity)
                                   .onAppear {
                                       
                                       if !hasLaunchedBefore {
                                                       deleteToken() // Clear Keychain on first launch after reinstall
                                                       hasLaunchedBefore = true
                                       }
                                      
                                       tokenManager.location = ""
                                       
                                       DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                           withAnimation {
                                               showSplashScreen = false
                                           }
                                       }
                                   }
                }
                else
                {
                
                    ContentView(isHome: false , deepLinkData: $deepLinkData).environmentObject(tokenManager).environmentObject(dataFetcher).environmentObject(themeManager) .environmentObject(networkMonitor).modelContainer(sharedModelContainer)
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
//
//
