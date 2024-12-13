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
       
    @State private var currentStep = 1
    
     @State private var permissionGranted = false
    @StateObject private var locationManager = LocationManager()
    
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
                
               
                if currentStep == 1 {
       
                    VStack {
                        
                        Spacer()
                        Button("Enable Notifications") {
                            // Check the current status when the screen appears
                            checkNotificationPermission { isGranted in
                                permissionGranted = isGranted
                                if !isGranted && tokenManger.notificationSettings == "" {
                                    requestNotificationPermission { granted in
                                        permissionGranted = granted
                                        
                                        tokenManger.notificationSettings = "applied"
                                        
                                        currentStep = 2
                                    }
                                }
                                else{
                                    currentStep = 2
                                }
                            }
                        } .padding()
                            .background( Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        Spacer();
                    }
                    
                            } else if currentStep == 2 {
                                
                                VStack {
                                    Spacer()
                                    Button("Enable Location") {
                                        if !(locationManager.status == .authorizedWhenInUse || locationManager.status == .authorizedAlways ) {
                                            
                                            locationManager.requestWhenInUseAuthorization()
                                            tokenManger.locationSettings = "applied"
                                        }
                                        else{
                                            currentStep = 3;
                                        }
                                    } .padding()
                                        .background( Color.green )
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    
                                    Spacer()
                                }
                            } else if currentStep == 3 {
                                if isNewDevMatches {
                                    
                                    MatchesNewDevsView().padding(.bottom)
                                    
                                }
                                else {
                                    
                                    ForYouMatches()
                                    
                                }
                            }
                
                
            }
            
            
            
            .frame(  maxHeight: .infinity , alignment: .topLeading )
            .onAppear(){
                
                checkNotificationPermission { isGranted in
                    permissionGranted = isGranted
                    if !isGranted && tokenManger.notificationSettings == ""{
                        currentStep = 1
                        
                    }
                    else if ( ( locationManager.status == .authorizedAlways || locationManager.status == .authorizedWhenInUse ) &&  tokenManger.locationSettings == "" ) {
                        currentStep = 2
                    }
                    
                    
                }
                
                locationManager.onAuthorizationChange = { newStatus in
                   
                    if ( tokenManger.locationSettings == "" ) {
                        if ( locationManager.status == .authorizedAlways || locationManager.status == .authorizedWhenInUse ) {
                            currentStep = 3
                        }
                        else{
                            
                        }
                    }
                  
                    if ( tokenManger.locationSettings == "applied" ) {
                        currentStep = 3
                    }
                    
                   
                }

            }
      
            
            
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
    
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
               
            }
        }
    }

    func getNotificationStatus(completion: @escaping (String) -> Void) {
            let center = UNUserNotificationCenter.current()

            center.getNotificationSettings { settings in
                DispatchQueue.main.async {
                    switch settings.authorizationStatus {
                    case .notDetermined:
                        completion("Not Determined")
                    case .denied:
                        completion("Denied")
                    case .authorized:
                        completion("Authorized")
                    case .provisional:
                        completion("Provisional")
                    case .ephemeral:
                        completion("Ephemeral")
                    @unknown default:
                        completion("Unknown")
                    }
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
    
}


struct  MatchesScreennView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        MatchesScreenView(path: $path).environmentObject(TokenManager())
    }
}



