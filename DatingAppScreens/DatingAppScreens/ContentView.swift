//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI



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
    @State private var selectedTab = 0
    @EnvironmentObject private var tokenManager: TokenManager
    
    @Binding  var deepLinkData: DeepLinkData?
    
    @StateObject private var locationManager = LocationManager()
       
    var isHome = false
    
    @State private var isTabBarHidden = true

    
    @State var path :[MyNavigation<String>] = []
   
    @State private var isMenuVisible = false
    
    init(isHome: Bool, deepLinkData: Binding<DeepLinkData?>) {
           self.isHome = isHome
           self._deepLinkData = deepLinkData
        print (deepLinkData.wrappedValue)
        print ("Content View Deep Link Data" , self._deepLinkData.wrappedValue)
    }

    var body: some View {
        
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
                
                if ( !isHome && ( tokenManager.accessToken == "" || tokenManager.technologies == "" || tokenManager.photo == "" || tokenManager.hobbies == "" || tokenManager.isProfileDobSmokingDrinkingEmpty() ) ) {
                    
                    VStack {
                        
                        NavigationStack(path: $path) {
                            
                            //                            Group {
                            //
                            //
                            ////                                if tokenManager.accessToken.isEmpty {
                            ////
                            ////                                    LoginView(path: $path)
                            ////                                } else
                            ////                                if tokenManager.photo.isEmpty {
                            ////
                            ////                                    UploadYourPhotoView(path:$path)
                            ////
                            ////                                } else if tokenManager.technologies.isEmpty {
                            ////                                    UpdateTechnologyView(path: $path)
                            ////                                } else {
                            ////                                    LoginView(path: $path)
                            ////                                }
                            //                            }
                            
                            LoginView(path: $path).navigationDestination(for: MyNavigation<String>.self) { view in
                                switch view.appView {
                                case .signIn:
                                    LoginSocialView(path:$path)
                                case .signUp:
                                    RegisterView(path:$path)
                                case .page1:
                                    UploadYourPhotoView(path: $path)
                                case .page2:
                                    UpdateTechnologyNewView(path: $path)
                                case .page3:
                                    UpdateHobbiesView(path : $path)
                                case .page4 :
                                    ProfileEditorView(path : $path)
                                case .home:
                                    Text("Technologies")
                                }
                            }
                        }.onChange(of: tokenManager.accessToken) { newValue in
                           handleNavigation()                    
                            
                        }
                        .onChange(of: tokenManager.photo ) { newValue in
                            
                          handleNavigation()
                        }
                        .onChange(of: tokenManager.technologies ) { newValue in
                            
                          handleNavigation()
                            
                        }
                        .onChange(of: tokenManager.hobbies ) { newValue in
                            
                          handleNavigation()
                            
                            
                        }
                        .onChange(of: tokenManager.dob ) { newValue in
                            
                          handleNavigation()
                            
                        }
                        .onChange(of: tokenManager.drinking ) { newValue in
                            
                          handleNavigation()
                               
                        }
                        .onChange(of: tokenManager.smoking ) { newValue in
                            
                          handleNavigation()
                            
                        }
                        
                    }.frame( maxWidth:.infinity)
                        .navigationBarTitle("", displayMode: .inline)
                                            .onAppear(){
                    
//                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1 ){
                    
                                                   handleNavigation()
//                                                }
                                
                                            }
                    
                    
                } else {
                    
                    Button("Reset Token"){
                        tokenManager.resetAccessToken()
                    }
                    
                    ZStack {
                        
                        VStack {
                            if tokenManager.isMenuView == false {
                                HStack {
                                    
                                    
                                    // Temporarly Commented If Needed , I Will Add In Future , The Menu . on the left top corner.
                                    //                                    Image("menu").resizable().frame(width: 25, height: 25)
                                    //                                        .font(.title)
                                    //
                                    //                                        .cornerRadius(4)
                                    //                                        .onTapGesture {
                                    //                                            withAnimation {
                                    //                                                isMenuVisible.toggle()
                                    //                                            }
                                    //
                                    //                                            print("\(tokenManager.localhost)/\(tokenManager.photo)")
                                    //                                        }
                                    
                                    
                                    Spacer()
                                    
                                    Text("Devo").fontWeight(.bold)
                                    
                                    
                                    Spacer()
                                    
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
                                TabView(selection: $selectedTab) {
                                    
                                    HomeView().onAppear(){
                                        tokenManager.isMenuView = false
                                    }
//                                    .tabItem {
//                                        Label("", systemImage: "rectangle.stack")
//                                    }
                                    .tag(0)
                                    .background(Color.white) // Set background color of the first tab
                                    LikesScreenView()
//                                        .tabItem {
//                                            Label("", systemImage: "heart").background(.black)
//                                        }
                                    .tag(1)
                                    
                                    //                            Text("Hello2")
                                    //                                .tabItem {
                                    //                                    Label("Questions", systemImage: "plus").background(.orange)
                                    //                                }
                                    //                                .tag(2)
                                    
                                    MatchedScreenView()
//                                        .tabItem {
//                                            Label("", systemImage: "message").background(.black)
//                                        }
                                    .tag(2)
                                    
                                    UserSettingsView(path: $path)
//                                        .tabItem {
//                                            Label("", systemImage: "person").background(.black)
//                                        }
                                    .tag(3)
                                    
                                }   .id(selectedTab)  
                                    .toolbar(.hidden, for: .tabBar)
                                    .padding(.bottom , 5)
                                    .overlay(alignment: .bottom) {

                                        // Custom tab bar
                                                   HStack {
                                                       TabBarItem(imageName: "rectangle.stack", title: "", isSelected: selectedTab == 0)
                                                           .onTapGesture {
                                                               selectedTab = 0
                                                               print("Selected tab: \(selectedTab)")
                                                           }
                                                       TabBarItem(imageName: "heart", title: "", isSelected: selectedTab == 1)
                                                           .onTapGesture {
                                                               selectedTab = 1
                                                               print("Selected tab: \(selectedTab)")
                                                           }
                                                       TabBarItem(imageName: "message", title: "", isSelected: selectedTab == 2)
                                                           .onTapGesture {
                                                               selectedTab = 2
                                                               print("Selected tab: \(selectedTab)")
                                                           }
                                                       TabBarItem(imageName: "person", title: "", isSelected: selectedTab == 3)
                                                           .onTapGesture {
                                                               selectedTab = 3
                                                               print("Selected tab: \(selectedTab)")
                                                           }
                                                   }
                                                   .frame( maxWidth:.infinity)
                                                   .padding()
                                                   .background(Color.white)
                                                   .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                                        
                                                   .frame(height: 100)
                                    }
                                   
                                    .edgesIgnoringSafeArea(.bottom)
                                    
                                .edgesIgnoringSafeArea(.bottom)
                                                
                                
                              
                            }
                            .frame( maxWidth:.infinity , maxHeight: .infinity )
                            
                        }
                        
                    }
                }
                
            }.onChange(of: tokenManager.userId) { newValue in
                
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
            
            SideMenuView(selectedTab: $selectedTab, isMenuVisible: $isMenuVisible)

        }.onChange(of: scenePhase) { newPhase in
            
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
        .onChange(of: tokenManager.userId) { newValue in
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
        .onChange(of: deepLinkData) { newDeepLinkData in
           handleDeepLink()
        }
        .onAppear {
            dataFetcher.startPolling()
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // App became active
            let userId = tokenManager.userId // Replace with actual user ID
            let accessToken = tokenManager.accessToken;
            
            Task {
           
                await  setUserOnline(userId: userId , accessToken: accessToken )
              
            }
           
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            print("selected Tab : " , selectedTab )
            
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
            dataFetcher.stopPolling()
        }
    }
    
    func handleDeepLink () {
        print("deepLinkData : " , deepLinkData ?? "")
        
        if let deepLinkData = deepLinkData {
            // Navigate to the appropriate view based on deepLinkData
            switch deepLinkData.view {
            case "view1":
                selectedTab = 2
//                    View1(parameter: deepLinkData.parameters["param"] ?? "")
            case "view2":
                selectedTab = 3
//                    View2(parameter: deepLinkData.parameters["param"] ?? "")
            default:
                selectedTab = 1
            }
        }
    }
    
    
    func handleNavigation() {
        print("technologies")
        
        if tokenManager.accessToken.isEmpty {
            print("access token empty ")
            path.removeAll()
        } else if tokenManager.photo.isEmpty {
            print("photo token empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page1, params: Params<String>(data: "")))
        } else if tokenManager.technologies.isEmpty {
            print("technologies token empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page2, params: Params<String>(data: "")))
        }
        else if tokenManager.hobbies.isEmpty {
            print("hobbies token empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page3, params: Params<String>(data: "")))
        } 
        else if tokenManager.isProfileDobSmokingDrinkingEmpty() {
            print("hobbies token empty ")
            path.removeAll()
            path.append(MyNavigation<String>(appView: .page4, params: Params<String>(data: "")))
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
                   
                   RegisterView(path: $path)
                       .tabItem {
                           Label("Register", systemImage: "person.crop.circle")
                       }
                       .environmentObject(tokenManager)
                   
                   UploadYourPhotoView(path: $path)
                       .tabItem {
                           Label("Upload Photo", systemImage: "photo")
                       }
                       .environmentObject(tokenManager)
                   
                   UpdateTechnologyNewView(path: $path)
                       .tabItem {
                           Label("Update Technology", systemImage: "wrench")
                       }
                       .environmentObject(tokenManager)
            
                   
                   
                   ContentView(isHome: true, deepLinkData: $deepLinkData)
                       .tabItem {
                           Label("Home", systemImage: "house.fill")
                       }
                       .environmentObject(tokenManager)
                   
                
               }
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
                        
                        AsyncImage(url: URL(string: "\(tokenManger.localhost)/images/\(tokenManger.photo)")) { image in
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
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .foregroundColor(isSelected ? .blue : .gray)
                .frame(width: 24, height: 24) // Standard size for the icon
                .font(.system(size: 20)) // Adjust the icon size within the frame
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .gray)
        }.frame( maxWidth:.infinity )
    }
}
