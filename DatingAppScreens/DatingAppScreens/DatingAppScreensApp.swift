//
//  DatingAppScreensApp.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI

import UserNotifications

import GoogleSignIn


class TokenManager: ObservableObject {
    
    @AppStorage("accessToken") var accessToken: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("name") var name: String = ""
    @AppStorage("technologies") var technologies: String = "#Swift UI,"
    @AppStorage("experience") var experience: String = ""
    
    func updateAccessToken( token: String , email : String , name : String ) {
        self.accessToken = token
        self.email = email
        self.name = name;
    }
    
    func resetAccessToken () {
        self.accessToken = ""
        self.email = ""
        self.name = ""
    }
}


@main
struct DatingAppScreensApp: App {
    
    @StateObject private var tokenManager = TokenManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(tokenManager).onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
              }.onAppear {
                  GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    // Check if `user` exists; otherwise, do something with `error`
                  }
                }
        }
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
