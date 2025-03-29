//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI

// MARK: - Custom Environment Key
private struct HideTabBarKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var hideTabBar: Bool {
        get { self[HideTabBarKey.self] }
        set { self[HideTabBarKey.self] = newValue }
    }
}

extension View {
    func hideTabBar(_ hide: Bool) -> some View {
        environment(\.hideTabBar, hide)
    }
}


class DataFetcher: ObservableObject {
    @Published var data: [String] = []
    var timer: Timer?
    var pollingInterval: TimeInterval
    
    init(pollingInterval: TimeInterval) {
        self.pollingInterval = pollingInterval
//        startPolling()
    }
    
    func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true) { _ in
            self.fetchData()
        }
    }
    
    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }
    
    func sendDeviceTokenToServer(_ token: String , localhost : String , userId : String) async throws {
        guard let url = URL(string: "\(localhost)/notificatons/register-device-token") else {
               throw URLError(.badURL)
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")

           let body: [String: Any] = ["token": token, "userId": userId]
           request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

           let (data, response) = try await URLSession.shared.data(for: request)

           if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
               print("Device token successfully sent to server.")
           } else {
               print("Failed to send device token to server.")
           }
       }
    
//    For background tasks .
//    func fetchDataInBackground(completion: @escaping () -> Void) {
//           // Perform data fetching logic here (in background)
//           print("Fetching data in background...")
//           DispatchQueue.global().async {
//               // Simulate data fetching
//               DispatchQueue.main.async {
//                   self.data = ["Data 1", "Data 2", "Data 3"] // Update @Published var data
//                   completion() // Call completion handler when done
//               }
//           }
//       }
//    
    func fetchData() {
        // Replace with your data fetching logic
        print("Fetching data...")
    }
}


struct ContentView: View {
    
   
    
    @StateObject private var dataFetcher = DataFetcher(pollingInterval: 60) // Example with 60 seconds interval
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var selectedTabForIndicator = 0
    @EnvironmentObject private var tokenManager: TokenManager
    
    
    @EnvironmentObject private var networkMonitoring : NetworkMonitor
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding  var deepLinkData: DeepLinkData?
    
  
    @Namespace private var animationNamespace

    // for previewes in XCode .
    var isHome = false
    
    @State private var isTabBarHidden = true
    
    @State private var unreadChatCount = 0 ;
    
    @State var path :[MyNavigation<String>] = []
    
    @State private var isMenuVisible = false
    
    init(isHome: Bool, deepLinkData: Binding<DeepLinkData?>) {
        self.isHome = isHome
        self._deepLinkData = deepLinkData
        print (deepLinkData.wrappedValue)
        print ("Content View Deep Link Data" , self._deepLinkData.wrappedValue)
    }
    
    
    // Define the steps
     enum Step: Int {
         case stepZero = 0
         case stepOne
         case stepTwo
         case stepThree
         case stepFour
         case stepFive
         case stepSix
         case stepSeven
         case stepEight
         case stepNine
     }

    @State private var currentStep: Step = .stepZero
      @State private var transitionDirection: Edge = .trailing // Default transition direction

    
    // Navigate to the next step
        private func goToNextStep() {
            if let nextStep = Step(rawValue: currentStep.rawValue + 1) {
                withAnimation {
                    transitionDirection = .trailing // Right-to-left transition
                    currentStep = nextStep
                }
            }
        }

        // Navigate to the previous step
        private func goToPreviousStep() {
            if let previousStep = Step(rawValue: currentStep.rawValue - 1) {
                withAnimation {
                    transitionDirection = .leading // Left-to-right transition
                    currentStep = previousStep
                }
            }
        }
    
    @State private var hasLoaded: Bool = false // Track if it's the first load
    
    
    // Add observers for keyboard events
       private func addKeyboardListeners() {
           NotificationCenter.default.addObserver(
               forName: UIResponder.keyboardWillShowNotification,
               object: nil,
               queue: .main
           ) { _ in
               tokenManager.isKeyboardOpen = true
               runYourCodeOnKeyboardOpen()
           }

           NotificationCenter.default.addObserver(
               forName: UIResponder.keyboardWillHideNotification,
               object: nil,
               queue: .main
           ) { _ in
               tokenManager.isKeyboardOpen = false
           }
       }

       // Remove observers when the view disappears
       private func removeKeyboardListeners() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }

       // Custom code to run when the keyboard opens
       private func runYourCodeOnKeyboardOpen() {
           print("Keyboard is now open. Running custom code.")
           // Add your custom logic here
       }
    
    
    func countChatsWithUnreadMessages () async
    {
        
      
        let baseURL = "\(tokenManager.localhost)/messages/countChatsWithUnreadMessages"
        let accessToken = tokenManager.accessToken
        
        do {
            let request = try createURLRequest(
                method: "GET",
                baseURL: baseURL,
                accessToken: accessToken,
                data: Optional<Data>.none, // No body data for GET request
                parameters: [:]
            )
            

                do {
                    let unreadChatCount: UnreadChatCountResponse = try await fetchData(from: request)
                    
                    print ("Unread chat count : \(unreadChatCount.count)")
                    DispatchQueue.main.async {
                       
                        self.unreadChatCount = unreadChatCount.count;
                         
                    }
                } catch {
                    
                }
        } catch {
            
        }
        
    }
    
    
    var body: some View {
        
        VStack {
         
            
//            HeightScaleControl()
            
            ZStack {
                
                
                VStack {
                    
                    //                VStack {
                    //                           if let location = locationManager.location {
                    //                               Text("Latitude: \(location.coordinate.latitude)")
                    //                               Text("Longitude: \(location.coordinate.longitude)")
                    //                           } else {
                    //                               Text("Fetching location...")
                    //                           }
                    //                       }
                    //                       .onAppear {
                    //                           locationManager.startUpdatingLocation()
                    //                       }
                    //                       .onDisappear {
                    //                           locationManager.stopUpdatingLocation()
                    //                       }
                    
                    
                    if ( !isHome  && ( tokenManager.accessToken == "" ) ) {  // && ( tokenManager.accessToken == "") ) {
                        
                        LoginView()
                        
                    }
                    else if ( !isHome && ( tokenManager.accessToken == "" || tokenManager.gender == "" || tokenManager.technologies == "" || tokenManager.photo == "" || ( tokenManager.isAdditionalPhotosAdded == false ) || tokenManager.hobbies == "" || tokenManager.dob.isEmpty || tokenManager.bio == "" || tokenManager.jobRole == "" || tokenManager.isProfileDobSmokingDrinkingEmpty() ) ) {
                        
                         
                        // Display the view for the current step
                                   ZStack {
                                       
                                       VStack {
                                           
                                           ThemeToggleButton()
                                           
                                           
                                           // Custom top "Previous" button
                                           if( currentStep != .stepZero ) {
                                               HStack {
                                                   
                                                   
                                                   Button(action: goToPreviousStep) {
                                                       HStack {
                                                           Image(systemName: "chevron.left") // Standard left arrow
                                                           Text("Previous")
                                                       }
                                                       .font(.body)
                                                       .foregroundColor(currentStep == .stepZero ? .gray : .blue) // Disable look
                                                   }
                                                   .disabled(currentStep == .stepZero) // Disable the button on the first step
                                                   
                                                   Spacer() // Push to the left
                                               }
                                               
                                               //                                               Text("Step \(currentStep.rawValue) of 5") // Step indicator
                                               //                                                   .font(.headline)
                                               
                                               .padding()
                                               .background(themeManager.currentTheme.backgroundColor) // Background for contrast
                                           }
                                           else{
                                               
                                               HStack {
                                                   
                                                   
                                                   Button(action: goToPreviousStep) {
                                                       HStack {
                                                           Image(systemName: "chevron.left") // Standard left arrow
                                                           Text("Previous")
                                                       }
                                                       .font(.body)
                                                       .foregroundColor(currentStep == .stepZero ? .gray : .blue) // Disable look
                                                   }
                                                   .disabled(currentStep == .stepZero) // Disable the button on the first step
                                                   
                                                   Spacer() // Push to the left
                                               }
                                               
                                               //                                               Text("Step \(currentStep.rawValue) of 5") // Step indicator
                                               //                                                   .font(.headline)
                                               
                                               .padding()
                                               .background(themeManager.currentTheme.backgroundColor) // Background for contrast
                                               .opacity(0);
                                           }
                                           
                                           
                                           
                                           // Step progress bar
                                           HStack(spacing: 8) {
                                               ForEach(0...9, id: \.self) { step in
                                                   Rectangle()
                                                       .fill(currentStep.rawValue >= step ? Color.blue : Color.gray.opacity(0.5)) // Blue if completed, gray otherwise
                                                       .frame(height: 10)
                                               }
                                           }
                                           .padding(.horizontal)
                                           .padding(.top)
                                           
                                           
                                           VStack {
                                               if currentStep == .stepZero {
                                                   UploadYourPhotoView(showNextButton: true)
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                               } else if currentStep == .stepOne {
                                                   UploadYourAdditionalPhotosView(showNextButton: true)
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                               } else if currentStep == .stepTwo {
                                                   
                                                   UpdateGenderView( showNextButton : true )
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                                 
                                               }  else if currentStep ==  .stepThree  {
                                                   UpdateHobbiesView(showNextButton: true)
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                               }  else if currentStep ==  .stepFour  {
                                                   UpdateDOBView(showNextButton: true)
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                               } else if currentStep ==  .stepFive  {
                                                   UpdateDescribeYourselfView(showNextButton: true)
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                               } else if currentStep ==  .stepSix {
                                                   UpdateJobRole2View(showNextButton: true)
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                               }
                                               else if currentStep ==  .stepSeven {
                                                   UpdateSmokingView(showNextButton: true)
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                               }
                                               else if currentStep ==  .stepEight {
                                                   UpdateDrinkingView(showNextButton: true)
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                               }
                                               else if currentStep == .stepNine {
                                                   UpdateTechnologyNewView( showNextButton : true )
                                                       .transition(hasLoaded ? .asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity) : .identity)
                                               }
                                               
                                           }  .animation(hasLoaded ? .easeInOut : nil, value: currentStep) // Apply animation only after the first load
                                       }
                                      
//                                       else if currentStep == .stepThree {
//                                           StepThreeView()
//                                               .transition(.asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity))
//                                       }
                                   }
                                   .onAppear {
                                     
                                       
                                       //should be compulsory outside of dispatch Queue so that animation do not occureon on hasLoaded .
                                       handleNavigation()
                                       
                                       
                                       // Delay hasLoaded by 1 millisecond to prevent immediate animations
                                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                           hasLoaded = true
                                       }
                                     
                                   }
                                   .onChange(of: tokenManager.nextButtonWhenRegistrationProcess) {  _ , newValue in
                                       goToNextStep()
                                   }
                                   .onChange(of: tokenManager.accessToken) { _ , newValue in
                                       handleNavigation()
                                       
                                   }  
                                   .onChange(of: tokenManager.photo ) { _ , newValue in
                                       
//                                       goToNextStep()
                                   }
                                   .onChange(of: tokenManager.technologies ) { _ , newValue in
                                       
//                                       goToNextStep()
                                       
                                   }
                                   .onChange(of: tokenManager.hobbies ) { _ , newValue in
                                       
//                                       goToNextStep()
                                       
                                   }
                                   .onChange(of: tokenManager.dob ) { _ , newValue in
                                       
//                                       goToNextStep()
                                       
                                   }
                                   .onChange(of: tokenManager.drinking ) { _ , newValue in
                                       
//                                       handleNavigation()
                                       
                                   }
                                   .onChange(of: tokenManager.smoking ) { _ , newValue in
                                       
//                                       handleNavigation()
                                       
                                   }
                                   .onChange(of: tokenManager.bio ) { _ , newValue in
                                       
//                                       handleNavigation()
                                       
                                   }
                                   .onChange(of: tokenManager.jobRole ) { _ , newValue in
                                       
                                       handleNavigation()
                                       
                                   }
                        
                    } else if ( !isHome && ( tokenManager.accessToken == "" || tokenManager.technologies == "" || tokenManager.photo == "" || tokenManager.hobbies == "" || tokenManager.isProfileDobSmokingDrinkingEmpty() || tokenManager.bio == "" || tokenManager.jobRole == "" ) ) {
                        
                        
                        
                    }
                    else {
                     
                        
                        ZStack {
                            
                            VStack {
                                if tokenManager.isMenuView == false {
                                    HStack {
                                        
                                       
//                                        
                                        Image("40")
                                            .resizable()
                                            .frame(width: 80, height: 50)
                                            .background( themeManager.currentTheme.id == "light" ? Color.white : .black )
                                            .rotationEffect(Angle.degrees(13))
                                        
//
                                        
                                        Spacer()
                                        
                                        ThemeToggleButton()
                                        
                                       
                                        
                                        Image("filter").resizable().frame(width: 25, height: 25)
                                            .font(.title)
                                        
                                        //                              .border(Color.gray, width: 2)
                                            .cornerRadius(4)
                                            .onTapGesture {
                                                print("Filter clicked")
                                                
                                                
                                                
                                            }
                                        
                                        
                                    }.frame(width: UIScreen.main.bounds.width - 50).padding(.horizontal, 30)
                                }
                                
                                VStack {
                                    
                                    
                                    
                                    
                                    TabView(selection: $tokenManager.selectedTab) {
                                        
                                        HomeView().onAppear(){
                                            tokenManager.isMenuView = false
                                             
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                                                        for family in UIFont.familyNames {
                                                            print(family)
                                                        }
                                                    })
                                               
                                        }
                                        //                                    .tabItem {
                                        //                                        Label("", systemImage: "rectangle.stack")
                                        //                                    }
                                        .tag(0)
                                        .background(themeManager.currentTheme.backgroundColor) // Set background color of the first tab
                                        LikesScreenView().onAppear(){
                                            tokenManager.isMenuView = true
                                        } .background(themeManager.currentTheme.backgroundColor) // Set background color of the first tab
                                        //                                        .tabItem {
                                        //                                            Label("", systemImage: "heart").background(.black)
                                        //                                        }
                                            .tag(1)
                                        
                                        //                            Text("Hello2")
                                        //                                .tabItem {
                                        //                                    Label("Questions", systemImage: "plus").background(.orange)
                                        //                                }
                                        //                                .tag(2)
                                        
                                        MatchedHome().onAppear(){
                                            tokenManager.isMenuView = true
                                        } .background(themeManager.currentTheme.backgroundColor) // Set background color of the first tab
                                        //                                        .tabItem {
                                        //                                            Label("", systemImage: "message").background(.black)
                                        //                                        }
                                            .tag(2)
                                        
                                        UserSettingsView().onAppear(){
                                            tokenManager.isMenuView = true
                                        } .background(themeManager.currentTheme.backgroundColor) // Set background color of the first tab
                                        //                                        .tabItem {
                                        //                                            Label("", systemImage: "person").background(.black)
                                        //                                        }
                                            .tag(3)
                                        
                                    }.id(tokenManager.selectedTab)     .padding(.bottom , 5)
                                        .toolbar(.hidden, for: .tabBar)
                                        .padding(.bottom, -100) // Adjust bottom padding to compensate for space occupied by the tab bar
                                        .overlay(alignment: .bottom ) {
                                            
                                            if( !tokenManager.hideTabBar) {
                                                // Custom tab bar
                                                HStack {
                                                    Spacer()
                                                    
                                                    VStack {
                                                        TabBarItem(imageName: "rectangle.stack", title: "", isSelected: tokenManager.selectedTab == 0)
                                                            .onTapGesture {
                                                                tokenManager.selectedTab = 0
//                                                                withAnimation(.spring()) {
//                                                                    selectedTabForIndicator = 0
//                                                                                           }
                                                                print("Selected tab: \(tokenManager.selectedTab)")
                                                            }
                                                        
//                                                        if selectedTabForIndicator == 0 {
//                                                            RoundedRectangle(cornerRadius: 2)
//                                                                .fill(Color.blue)
//                                                                .frame(width: 40, height: 4)
//                                                                .matchedGeometryEffect(id: "indicator", in: animationNamespace)
//                                                        } else {
//                                                            Spacer().frame(height: 4)  // Keeps layout stable
//                                                        }
                                                    }
                                                    
                                                    VStack {
                                                        TabBarItem(imageName: "heart", title: "", isSelected: tokenManager.selectedTab == 1)
                                                            .onTapGesture {
                                                                tokenManager.selectedTab = 1
//                                                                withAnimation(.spring()) {
//                                                                    selectedTabForIndicator = 1
//                                                                                           }
                                                                print("Selected tab: \(tokenManager.selectedTab)")
                                                            }
//                                                        if selectedTabForIndicator == 1 {
//                                                            RoundedRectangle(cornerRadius: 2)
//                                                                .fill(Color.blue)
//                                                                .frame(width: 40, height: 4)
//                                                                .matchedGeometryEffect(id: "indicator", in: animationNamespace)
//                                                        } else {
//                                                            Spacer().frame(height: 4)  // Keeps layout stable
//                                                        }
                                                    }
                                                    
                                                    VStack {
                                                        TabBarMessageItem(imageName: "message", title: "", isSelected: tokenManager.selectedTab == 2 , notificationCount: unreadChatCount )
                                                        .onTapGesture {
                                                            tokenManager.selectedTab = 2
//                                                            withAnimation(.spring()) {
//                                                                selectedTabForIndicator = 2
//                                                                                       }
                                                            print("Selected tab: \(tokenManager.selectedTab)")
                                                        }
                                                    
//                                                        if selectedTabForIndicator == 2 {
//                                                            RoundedRectangle(cornerRadius: 2)
//                                                                .fill(Color.blue)
//                                                                .frame(width: 40, height: 4)
//                                                                .matchedGeometryEffect(id: "indicator", in: animationNamespace)
//                                                        } else {
//                                                            Spacer().frame(height: 4)  // Keeps layout stable
//                                                        }
                                                    }
                                                    
                                                    VStack {
                                                        TabBarItem(imageName: "person", title: "", isSelected: tokenManager.selectedTab == 3)
                                                        .onTapGesture {
                                                            tokenManager.selectedTab = 3
//                                                            withAnimation(.spring()) {
//                                                                selectedTabForIndicator = 3
//                                                                                       }
                                                            print("Selected tab: \(tokenManager.selectedTab)")
                                                        }
                                                        
//                                                        if selectedTabForIndicator == 3 {
//                                                            RoundedRectangle(cornerRadius: 2)
//                                                                .fill(Color.blue)
//                                                                .frame(width: 40, height: 4)
//                                                                .matchedGeometryEffect(id: "indicator", in: animationNamespace)
//                                                        } else {
//                                                            Spacer().frame(height: 4)  // Keeps layout stable
//                                                        }
                                                    }
                                                    
                                                    
                                                    Spacer()
                                                }
                                                
                                                .padding()
                                                .background(themeManager.currentTheme.tabsBackgroundColor)
                                                .shadow(color: themeManager.currentTheme.primaryColor.opacity(0.1), radius: 10, x: 0, y: -5)
//                                                .overlay(
//                                          
//                                                        GeometryReader { geo in
//                                                                      RoundedRectangle(cornerRadius: 3)
//                                                                          .frame(width: 40, height: 3) // Fixed width to align with icons
//                                                                          .foregroundColor(.blue)
//                                                                          .offset(
//                                                                            x: (CGFloat(selectedTab) * ( geo.size.width - 44.0 ) / CGFloat(4)) + (geo.size.width / CGFloat(4) / 2) - 0.0,
//                                                                                          y: 12 // Adjust the vertical position if needed
//                                                                                      )
//                                                                          .animation(.spring(), value: selectedTab) // Apply animation directly here
//                                                                  }
//                                                                   .frame(height: 3)
//                                                                   
//                                                               )
//
                                              
                                                .frame(height: 100) .frame(  maxWidth: UIScreen.main.bounds.width)
                                            }
                                            
                                        }
                                    
                                    
                                        .edgesIgnoringSafeArea(.bottom)
                                    
                                    
                                    
                                }
                                .frame( maxWidth:.infinity , maxHeight: .infinity )
                                
                            } .frame( maxWidth:.infinity , maxHeight: .infinity )
                            
                        }
                    }
                    
                }.onChange(of: tokenManager.userId) { _ , newValue in
                    
                    // App became active
                    let userId = tokenManager.userId // Replace with actual user ID
                    let accessToken = tokenManager.accessToken
                    
                    Task {
                        
                        await    setUserOnline(userId: userId , accessToken: accessToken )
                        
                        
                    }
                    
                    
                    
                }
                
                
                Color.black.opacity( isMenuVisible ? 0.5 : 0).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isMenuVisible.toggle()
                        }
                    }
                
                SideMenuView(selectedTab: $tokenManager.selectedTab, isMenuVisible: $isMenuVisible)
                
            }.onChange(of: scenePhase) { _ , newPhase in
                
                print("Scene phase changed to: \(newPhase)")
                if newPhase == .active {
                    
                    // totodo : completed.
                    // when on change userId , there i need to update the userId to online .
                    
                    // App became active
                    let userId = tokenManager.userId // Replace with actual user ID
                    let accessToken = tokenManager.accessToken;
                    Task {
                        
                        await    setUserOnline(userId: userId , accessToken: accessToken )
                        
                    }
                } else if newPhase == .background {
                    // App entered background
                    let userId = tokenManager.userId // Replace with actual user ID
                    let accessToken = tokenManager.accessToken;
                    Task {
                        
                        await  setUserOffline(userId: userId , accessToken: accessToken )
                        
                    }
                }
                
            }
            .onChange(of: tokenManager.userId) { _ , newValue in
                Task {
                    do {
                        
                        print("OnChange toke.userId")
                        
                        // Replace "your_device_token_here" with the actual token
                        try await dataFetcher.sendDeviceTokenToServer(getDeviceNotificationToken() ?? "" , localhost: tokenManager.localhost , userId: tokenManager.userId)
                        
                        print ( "Device Notification Token" , getDeviceNotificationToken() ?? "No Device Notification Token" )
                        
                    } catch {
                        print("Failed to send device token: \(error)")
                    }
                    
                }
            }
            .onChange(of: deepLinkData) { _ , newDeepLinkData in
                handleDeepLink()
            }
            .onChange(of : tokenManager.shouldRefecthUnreadCount) { _, newValue in
                
                Task {
                    await countChatsWithUnreadMessages();
                }
            }
            .onAppear {
                
               
                dataFetcher.startPolling()
                
                Task {
                    await countChatsWithUnreadMessages();
                }
                
                // adding keyboardlisteners .
                addKeyboardListeners() ;
                
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                // App became active
                let userId = tokenManager.userId // Replace with actual user ID
                let accessToken = tokenManager.accessToken;
                
                Task {
                    
                    await  setUserOnline(userId: userId , accessToken: accessToken )
                    
                }
                
                ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                
                print("selected Tab : " , tokenManager.selectedTab )
                
                Task {
                    do {
                        // Replace "your_device_token_here" with the actual token
                        try await dataFetcher.sendDeviceTokenToServer(getDeviceNotificationToken() ?? "" , localhost: tokenManager.localhost , userId: tokenManager.userId)
                        
                        print ( "Device Notification Token" , getDeviceNotificationToken() ?? "No Device Notification Token" )
                        
                    } catch {
                        print("Failed to send device token: \(error)")
                    }
                    
                }
                
                
               
            }
            .onDisappear {
                dataFetcher.stopPolling();
                
                // removing keyboardlisteners .
                removeKeyboardListeners();
            }
        }.background(themeManager.currentTheme.backgroundColor)
            .overlay{
                if !networkMonitoring.isConnected {
                
                    VStack {
                    
                        Image(systemName: "wifi.exclamationmark") // SF Symbol
                                        .font(.system(size: 50))
                                        .foregroundColor(.red)
                        
                        
                        
                        Text("No Internet Connection")
                                        .font(.headline)
                                        .foregroundColor(.red)
                        
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .padding()
                           
                }
            }
}
    
    func handleDeepLink () {
        print("deepLinkData : " , deepLinkData ?? "")
        
        if let deepLinkData = deepLinkData {
            // Navigate to the appropriate view based on deepLinkData
            switch deepLinkData.view {
            case "view1":
                tokenManager.selectedTab = 2
//                    View1(parameter: deepLinkData.parameters["param"] ?? "")
            case "view2":
                tokenManager.selectedTab = 3
//                    View2(parameter: deepLinkData.parameters["param"] ?? "")
            default:
                tokenManager.selectedTab = 1
            }
        }
    }
    
    
    func handleNavigation() {
        print("technologies")
        
        
        if ( !( tokenManager.photo1.isEmpty || tokenManager.photo2.isEmpty || tokenManager.photo3.isEmpty || tokenManager.photo4.isEmpty ) ){
            tokenManager.isAdditionalPhotosAdded = true;
        }
        
        if tokenManager.accessToken.isEmpty {
            print("access token empty ")
            path.removeAll()
        } else if tokenManager.photo.isEmpty {
            print("photo  empty ")
            
            self.currentStep = .stepZero ;
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page1, params: Params<String>(data: "")))
        }
        else if tokenManager.isAdditionalPhotosAdded == false {
           print("photo  empty ")
           
            self.currentStep = .stepOne ;
           path.removeAll()
           path.append(MyNavigation<String>(appView: .page1, params: Params<String>(data: "")))
       }
        else if tokenManager.gender.isEmpty {
            print("technologies  empty ")
            self.currentStep = .stepTwo
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page2, params: Params<String>(data: "")))
        }
        else if tokenManager.hobbies.isEmpty {
            
            self.currentStep = .stepThree
            
            print("hobbies  empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page3, params: Params<String>(data: "")))
        } 
        else if tokenManager.dob.isEmpty {
            
            
            self.currentStep = .stepFour
            
            
            print("hobbies  empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page4, params: Params<String>(data: "")))
        }
        else if tokenManager.bio.isEmpty {
            
            
            self.currentStep = .stepFive
            
            
            print("bio  empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page5, params: Params<String>(data: "")))
        }
        else if tokenManager.jobRole.isEmpty {
            
            
            self.currentStep = .stepSix
            
            
            print("jobRole  empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page6, params: Params<String>(data: "")))
        }
        else if tokenManager.smoking.isEmpty {
            
            
            self.currentStep = .stepSeven
            
            
            print("jobRole  empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page6, params: Params<String>(data: "")))
        }
        else if tokenManager.drinking.isEmpty {
            
            
            self.currentStep = .stepEight
            
            
            print("jobRole  empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page6, params: Params<String>(data: "")))
        }
        else if tokenManager.technologies.isEmpty {
            print("technologies  empty ")
            self.currentStep = .stepNine
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page2, params: Params<String>(data: "")))
        }
        else {
            path.removeAll()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    @StateObject static var tokenManager :TokenManager = TokenManager()
    
    @State static var deepLinkData: DeepLinkData? = nil
    
    init(){
        
    
    }
    
    static var previews: some View {
      
        TabView {
            ContentView(isHome: false, deepLinkData: $deepLinkData)
                       .tabItem {
                           Label("Home", systemImage: "house")
                       }
                       .environmentObject(tokenManager)
                   
                   RegisterView()
                       .tabItem {
                           Label("Register", systemImage: "person.crop.circle")
                       }
                       .environmentObject(tokenManager)
                   
                   UploadYourPhotoView( )
                       .tabItem {
                           Label("Upload Photo", systemImage: "photo")
                       }
                       .environmentObject(tokenManager)
                   
                   UpdateTechnologyNewView( )
                       .tabItem {
                           Label("Update Technology", systemImage: "wrench")
                       }
                       .environmentObject(tokenManager)
            
                   
                   
                   ContentView(isHome: true, deepLinkData: $deepLinkData)
                       .tabItem {
                           Label("Home", systemImage: "house.fill")
                       }
                       .environmentObject(tokenManager)
                   
                
        } .environmentObject(ThemeManager())
//
//        RegisterView(path: $path)
//            .tabItem {
//                Label("Register", systemImage: "person.crop.circle")
//            }
//            .environmentObject(tokenManager)
//        
//        UploadYourPhotoView(path: $path)
//            .tabItem {
//                Label("Upload Photo", systemImage: "photo")
//            }
//            .environmentObject(tokenManager)
//        
//        UpdateTechnologyNewView(path: $path)
//            .tabItem {
//                Label("Update Technology", systemImage: "wrench")
//            }
//            .environmentObject(tokenManager)
//        
//        ContentView(isHome: true)
//            .tabItem {
//                Label("Home", systemImage: "house.fill")
//            }
//            .environmentObject(tokenManager)
    }
}

struct SideMenuView: View {
    
    @Binding var selectedTab : Int;
    let menuItems = [
        "Profile", "Edit Profile", "My Coins", "Power Ups", "Notifications",
        "Saved Posts", "Personalities", "Personality Database", "Settings"
    ]
    
    @Binding var isMenuVisible: Bool
    //    @Binding var path :[MyNavigation<String>]
    @EnvironmentObject private var tokenManger : TokenManager
    var body: some View {
        
        
        GeometryReader { geometry in
            
            ScrollView {
                VStack {
                    
                    
                    
                    //                    VStack ( alignment :.center) {
                    //
                    //                        Text("Devos").font(.subheadline)
                    //
                    //                        AsyncImage(url: URL(string: "\(tokenManger.localhost)/images/\(tokenManger.photo)")) { image in
                    //                            image
                    //                                .resizable()
                    //                                .aspectRatio(contentMode: .fill)
                    //                        } placeholder: {
                    //                            ProgressView()
                    //                        }
                    //                        .frame(width: 100, height: 100 )
                    //                        .clipShape(Circle()) // Apply circle clipping to the image
                    //                        .overlay(Circle().stroke(Color.white, lineWidth: 0)) // Add a white stroke around the circle
                    //                        .shadow(radius: 8).padding(.horizontal) // Add a shadow effect to the circl
                    //                        Text( tokenManger.name != "" ? " " + tokenManger.name  : "No Name").padding(.horizontal)
                    //                    }
                    //
                    HStack {
                        
                        AsyncImage(url: URL(string: "\(tokenManger.serverImageURL)/\(tokenManger.photo)")) { image in
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.trailing, 10)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .leading) {
                            Text(tokenManger.name)
                                .font(.headline)
                            Text(tokenManger.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(tokenManger.technologies)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        //                              Button(action: {}) {
                        //                                  Text("INVITE")
                        //                                      .font(.caption)
                        //                                      .padding(6)
                        //                                      .background(Color.blue)
                        //                                      .foregroundColor(.white)
                        //                                      .cornerRadius(15)
                        //                              }
                        
                    }
                    .padding(.vertical , 30)
                    
                    // Menu Items
                    VStack(alignment: .leading, spacing: 15) {
                        
                        Text("Profile")
                            .foregroundColor(Color(red: 0.2, green:0.2, blue:0.2))
                            .padding(.vertical, 3)
                            .onTapGesture {
                                
                                if(selectedTab != 0){
                                    selectedTab = 0
                                }
                                
                                if(selectedTab == 0)
                                {
                                    tokenManger.homeTabView = .home
                                    
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1 ) {
                                    
                                        tokenManger.homeTabView = .page1
                              
                                    }
                                
                                
                                isMenuVisible = false
                               }
                                
                                
//                                if(selectedTab == 1)
//                                {
//                                    
//                                  isMenuVisible = false
//                               }
//                                
//                                if(selectedTab == 2)
//                                {
//                                    
//                                  isMenuVisible = false
//                               }
//                                
//                                if(selectedTab == 3)
//                                {
//                                    
//                                  isMenuVisible = false
//                               }
                            }
                        
                        Text("Coins")
                            .foregroundColor(Color(red: 0.2, green:0.2, blue:0.2))
                            .padding(.vertical, 3)
                        
                    }.frame(maxWidth:.infinity , alignment: .topLeading)
                    
                    
                    
                }
            }.padding()
                .frame(width: geometry.size.width / 1.3 , alignment: .center)
                .background(Color.white)
                .offset(x: isMenuVisible ? 0 : -geometry.size.width / 1.3 )
            Spacer()
        }
        .frame(maxWidth: 600, alignment: .leading)
        

    }
    
    // Bring MenuView to the front
    
    

    
    // Function to determine destination view for each menu item
    func destinationForMenuItem(_ item: String) -> some View {
        switch item {
        case "Profile":
            return AnyView(HomeView())
        case "Edit Profile":
            return AnyView(Text("Edit Profile"))
        // Add cases for other menu items
        default:
            return AnyView(Text("Default View"))
        }
    }
}


struct View1: View {
    var parameter: String

    var body: some View {
        Text("View 1 with parameter: \(parameter)")
            .padding()
    }
}

struct View2: View {
    var parameter: String

    var body: some View {
        Text("View 2 with parameter: \(parameter)")
            .padding()
    }
}

 


struct TabBarItem: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    
    @EnvironmentObject private var themeManager : ThemeManager
    
    var body: some View {
        VStack {
            Image(systemName: isSelected ? "\(imageName).fill" : imageName)
                .foregroundColor(isSelected ? themeManager.currentTheme.buttonColor : .gray)
                .frame(width: 40, height: 40) // Standard size for the icon
                .font(.system(size: 20)) // Adjust the icon size within the frame
//                .shadow(color: isSelected ? Color.blue : Color.clear, radius: isSelected ? 6 : 0, x: 0, y: 2) // Shadow effect when selected
                               
            Text("")
                .font(.caption)
                .foregroundColor(isSelected ? themeManager.currentTheme.buttonColor : .gray)
        }.frame( maxWidth:.infinity )
    }
}



struct TabBarMessageItem: View {
   let imageName: String
   let title: String
   let isSelected: Bool
   let notificationCount: Int // Number to display in the notification bubble
   
   @EnvironmentObject private var themeManager : ThemeManager
    
   var body: some View {
       VStack {
           // Icon with notification bubble
           ZStack(alignment: .topTrailing) {
               Image(systemName: isSelected ? "\(imageName).fill" : imageName)
                   .foregroundColor(isSelected ? themeManager.currentTheme.buttonColor : .gray)
                   .frame(width: 40, height: 40)
                   .font(.system(size: 20))
//                   .shadow(color: isSelected ? Color.blue : Color.clear, radius: isSelected ? 6 : 0, x: 0, y: 2) // Shadow effect when selected
               
               
               // Notification bubble
               if notificationCount > 0 {
                   Text("\(notificationCount)")
                       .font(.system(size: 12, weight: .bold))
                       .foregroundColor(.white)
                       .padding(5)
                       .background(Color.red)
                       .clipShape(Circle())
                       .offset(x: 10, y: -10) // Adjust the position of the bubble
               }
           }
           
           // Title
           Text(title)
               .font(.caption)
               .foregroundColor(isSelected ? .blue : .gray)
       }
       .frame(maxWidth: .infinity)
   }
}
