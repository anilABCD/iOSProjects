//
//  DatingAppScreensApp.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI

import UserNotifications

import GoogleSignIn


func storeDeviceNotificationToken(_ userId: String) {
    UserDefaults.standard.set(userId, forKey: "deviceNotificationToken")
}

func getDeviceNotificationToken() -> String? {
    return UserDefaults.standard.string(forKey: "deviceNotificationToken")
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
    
    @AppStorage("smoking") var smoking: String = ""
    @AppStorage("drinking") var drinking: String = ""
    @AppStorage("dob") var dob: String = ""
    
    
    @Published var homeTabView : HomeTabEnumViews? = nil;
    
    
    @Published var isMenuView : Bool = false;
 
//    @Published  var localhost : String = "http://169.254.23.107:8000"
    @Published var localhost : String = Constants.localhost;
    
    func updateAccessToken( token: String , userId: String , email : String , name : String , photo:String , technologies : String , hobbies : String ) {
     
        self.userId = userId
        self.accessToken = token
        self.photo = photo

        self.email = email
        self.name = name;
        self.technologies = technologies;
        self.hobbies = hobbies ;
        
        print ( "User Id" , self.userId , token , email , name , photo)
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
                
                    ContentView(isHome: false , deepLinkData: $deepLinkData).environmentObject(tokenManager).environmentObject(dataFetcher).onOpenURL { url in
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

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Set the notification center delegate
        UNUserNotificationCenter.current().delegate = self

        // Request permission to show notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Permission granted: \(granted)")
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Request authorization failed: \(error.localizedDescription)")
            }
        }

        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert device token to string
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        storeDeviceNotificationToken(token);

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error.localizedDescription)")
    }

    // MARK: - UNUserNotificationCenterDelegate Methods

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Received notification: \(userInfo)")
        completionHandler()
    }
}
