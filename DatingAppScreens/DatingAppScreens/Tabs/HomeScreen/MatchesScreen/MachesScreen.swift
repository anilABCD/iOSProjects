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
    @EnvironmentObject private var themeManager : ThemeManager
    @StateObject private var locationViewModel = GeoLocationViewModel()
    @Binding var path :[MyNavigation<String>]
    
    @State private var isMenuVisible = true
 
    @State var isNewDevMatches : Bool = true;
       
    @State private var currentStep : Int = 3
    
     @State private var permissionGranted = false
  
    @StateObject private var locationServiceManager = LocationServiceManager()
    @State private var permissionGrantedLocation: Bool = false
    
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
                                if  tokenManger.notificationSettings == "" {
                                    requestNotificationPermission { granted in
                                        permissionGranted = granted
                                        
                                        if ( granted ) {
                                            tokenManger.notificationSettings = "granted"
                                            
                                            DispatchQueue.main.async {
                                                       UIApplication.shared.registerForRemoteNotifications()
                                                   }
                                        }
                                        else {
                                            tokenManger.notificationSettings = "denied"
                                        }
                                        
                                        currentStep = 2
                                    }
                                }
                                
                                if tokenManger.notificationSettings == "applied" {
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
                                        if ( tokenManger.locationSettings ==  "" ) {
                                            requestLocationPermission()
                                            
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
              
                    if  tokenManger.notificationSettings == "" {
                        
                        currentStep = 1
                        
                    }
                    else if  tokenManger.locationSettings == "" {
                        
                        currentStep = 2
                        
                    }
                    else  {
                        currentStep = 3
                        
                        
                        checkNotificationPermission { isGranted in
                            permissionGranted = isGranted
                            if  tokenManger.notificationSettings == "" {
                                requestNotificationPermission { granted in
                                    permissionGranted = granted
                                    
                                    if ( granted ) {
                                        tokenManger.notificationSettings = "granted"
                                        
                                        DispatchQueue.main.async {
                                                   UIApplication.shared.registerForRemoteNotifications()
                                               }
                                    }
                                    else {
                                        tokenManger.notificationSettings = "denied"
                                    }
                                    
                                    currentStep = 2
                                }
                            }
                            
                            if tokenManger.notificationSettings == "applied" {
                                currentStep = 2
                            }
                        }
                        
                        
                        locationServiceManager.requestLocationPermission { granted in
                            
                            self.permissionGrantedLocation = granted
                            
                          
                            if granted {
                            
                                print("✅ Location permission **granted**")
                            
                                tokenManger.locationSettings = "granted";
                                
                             
                            }
                            else
                            {
                                       print("❌ Location permission **denied**")
                                
                                tokenManger.locationSettings = "denied";
                                
                                locationViewModel.fetchLocation();
                                
                            }
                            
                            DispatchQueue.main.async {
                                self.currentStep = 3
                            }
                            
                            print ( currentStep , "abcdef")
                            
                        }
                        
                        // even when complete(true/false) is not called due to settings already done .
                        tokenManger.locationSettings = "applied";
                    }
                
                
                if tokenManger.locationSettings == "granted" {
                    
                    print("start updating location")
                    locationServiceManager.startUpdatingLocation()
                }
                else {
                    locationViewModel.fetchLocation()
                }
                    
                print ( currentStep , "abcd")
                
//                locationManager.onAuthorizationChange = { newStatus in
//                   
//                    if ( tokenManger.locationSettings == "" ) {
//                        if ( locationManager.status == .authorizedAlways || locationManager.status == .authorizedWhenInUse ) {
//                            currentStep = 3
//                        }
//                        else{
//                            
//                        }
//                    }
//                  
//                    if ( tokenManger.locationSettings == "applied" ) {
//                        currentStep = 3
//                    }
//                    
//                   
//                }

            }.background(themeManager.currentTheme.backgroundColor)
      
            
            
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
        }.onChange(of: locationServiceManager.userLocation)  { _ , newValue in
            
            guard let newValue else { return }
            
            print("new location" , newValue)
            let locationString = "\(newValue.coordinate.latitude),\(newValue.coordinate.longitude)"
            tokenManger.location = locationString
            
            locationServiceManager.stopUpdatingLocation()
            
            
            
        }
        .onChange( of: locationViewModel.location ) { _ , newValue in
            
            guard let newValue else { return }
            
            print("new location geo js" , newValue)
            let locationString = "\(newValue.latitude ?? "" ),\(newValue.longitude ?? "" )"
            tokenManger.location = locationString
            
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
    
    private func requestLocationPermission() {
        
        if ( tokenManger.locationSettings == "" ) {
            locationServiceManager.requestLocationPermission { granted in
                
                self.permissionGrantedLocation = granted
                
              
                if granted {
                
                    print("✅ Location permission **granted**")
                
                    tokenManger.locationSettings = "granted";
                    
                 
                }
                else
                {
                           print("❌ Location permission **denied**")
                    
                    tokenManger.locationSettings = "denied";
                    
                    locationViewModel.fetchLocation();
                    
                }
                
                DispatchQueue.main.async {
                    self.currentStep = 3
                }
                
                print ( currentStep , "abcdef")
                
            }
            
            // even when complete(true/false) is not called due to settings already done . 
            tokenManger.locationSettings = "applied";
        }
        else{
            DispatchQueue.main.async {
                self.currentStep = 3
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
        MatchesScreenView(path: $path).environmentObject(TokenManager()).environmentObject(ThemeManager())
    }
}



