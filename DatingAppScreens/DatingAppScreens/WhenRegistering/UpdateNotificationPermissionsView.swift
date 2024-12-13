////
////  UpdateNotificationPermissionsView.swift
////  DatingAppScreens
////
////  Created by Anil Kumar Potlapally on 08/12/24.
////
//
//import SwiftUI
//
//struct NotificationPermissionView: View {
//   
//    @State private var permissionGranted = false
//    
//    @Binding var path :[MyNavigation<String>]
//    
//    var body: some View {
//        VStack {
//            Text(permissionGranted ? "Notifications Enabled" : "Notifications Disabled")
//                .padding()
//
//            Button("Check Notification Permission") {
//                checkNotificationPermission { isGranted in
//                    permissionGranted = isGranted
//                    if !isGranted {
//                        requestNotificationPermission { granted in
//                            permissionGranted = granted
//                        }
//                    }
//                }
//            }
//        }
//        .onAppear {
//            // Check the current status when the screen appears
//            checkNotificationPermission { isGranted in
//                permissionGranted = isGranted
//            }
//        }
//    }
//
//    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            DispatchQueue.main.async {
//                completion(settings.authorizationStatus == .authorized)
//            }
//        }
//    }
//
//    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//            DispatchQueue.main.async {
//                completion(granted)
//            }
//        }
//    }
//}
//
////  UpdateNotificationPermissionsView.swift
////  DatingAppScreens
////
////  Created by Anil Kumar Potlapally on 08/12/24.
////
//
//import SwiftUI
//
//struct NotificationPermissionView: View {
//   
//    @State private var permissionGranted = false
//    
//    @Binding var path :[MyNavigation<String>]
//    
//    var body: some View {
//        VStack {
//            Text(permissionGranted ? "Notifications Enabled" : "Notifications Disabled")
//                .padding()
//
//            Button("Check Notification Permission") {
//                checkNotificationPermission { isGranted in
//                    permissionGranted = isGranted
//                    if !isGranted {
//                        requestNotificationPermission { granted in
//                            permissionGranted = granted
//                        }
//                    }
//                }
//            }
//        }
//        .onAppear {
//            // Check the current status when the screen appears
//            checkNotificationPermission { isGranted in
//                permissionGranted = isGranted
//            }
//        }
//    }
//
//    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            DispatchQueue.main.async {
//                completion(settings.authorizationStatus == .authorized)
//            }
//        }
//    }
//
//    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//            DispatchQueue.main.async {
//                completion(granted)
//            }
//        }
//    }
//}
