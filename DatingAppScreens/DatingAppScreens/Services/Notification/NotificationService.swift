//
//  NotificationService.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 09/03/25.
//

import SwiftUI

func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        
        if settings.authorizationStatus == .notDetermined {
            print("Notifications Not determined yet.")
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
                
            }
        } else if settings.authorizationStatus == .authorized {
            print("Notifications authorized.")
            DispatchQueue.main.async {
                       UIApplication.shared.registerForRemoteNotifications()
                   }
            
        } else {
            print("Notification permission was denied previously.")
        }
    }
}
