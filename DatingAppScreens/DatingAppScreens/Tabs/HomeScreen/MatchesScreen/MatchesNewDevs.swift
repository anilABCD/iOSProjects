//
//  MatchesNewDevs.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import Foundation

import SwiftUI
import SwiftData


struct MatchesNewDevsView: View {
    
    @State private var currentIndex = 0 ;
    @State var isPopupPresented = false // 1
    @State private var selectedPerson: String = "John Doe"
    
    @Environment(\.modelContext) private var modelContext

    @State var swipeRightId : String = ""
    @State var swipeLeftId : String = ""
    
    @State var showHeartAnimation : Bool = false
    @State var showRejectedAnimation : Bool = false
  
    @State var isButtonDisabled : Bool = false;
    
    @EnvironmentObject private var tokenManger : TokenManager
    @EnvironmentObject private var themeManager : ThemeManager
    
    
    @State var loadAllImagesAfterDelay : Double = 2;
    @State var loadAllImages : Bool = false
    
    
    @State var secondProfile : Profile?
    
    @State var showHeart : Bool = false;
    @State var showRejected : Bool = false;
   
    let buttonClickDelay : Double = 0.5 ;
    
   
    init(){
        
    }
    
    
    @State private var profiles : [Profile] = [ ];
    
    func likeTheProfile(user2_id : String) async throws {
//
//        let user2_id = profiles[currentIndex].id
//        
//        print(currentIndex, user2_id)
        
        let matches = Matches(user2_id: user2_id )
    
        
        let urlRequest = try createURLRequest(method : "POST" , baseURL: "\(tokenManger.localhost)/likes/like", accessToken: tokenManger.accessToken, data: matches, parameters: nil)
        
         let response: MatchesResponse = try await fetchData(from: urlRequest)
        
    }
    
    func unLikeTheProfile(user2_id : String) async throws {
//
//        let user2_id = profiles[currentIndex].id
//
//        print(currentIndex, user2_id)
        
        let matches = Matches(user2_id: user2_id )
    
        
        let urlRequest = try createURLRequest(method : "POST" , baseURL: "\(tokenManger.localhost)/profiles/reject/\(user2_id)", accessToken: tokenManger.accessToken, data: matches, parameters: nil)
        
         let response: MatchesResponse = try await fetchData(from: urlRequest)
        
    }
    
    
    func fetchProfiles() async throws {
        

        let profileIDs: [String] = profiles.map { $0.id }
        // Convert array to a comma-separated string
        let excludeIdsString = profileIDs

        // Example usage
        let baseURL = "\(tokenManger.localhost)/profiles"
         
        let data:MatchesFilter? = MatchesFilter(
            technologies: (tokenManger.technologies),
            minAge: "15",
            maxAge: "100",
            excludeProfileIds: excludeIdsString ,
            location: tokenManger.location
        )
         
        let urlRequest = try createURLRequest(method : "POST" , baseURL: baseURL, accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
//        self.profiles = try await fetchDataArray(from: urlRequest) + self.profiles
        // Ensure UI updates happen on the main thread
        Task {
            do {
                let newProfiles : [Profile] = try await fetchDataArray(from: urlRequest)
                
                 await ProfileService.saveProfilesToSwiftData(newProfiles, modelContext: modelContext)
                
                // Ensure UI updates with animation on the main thread
                await MainActor.run {
                    withAnimation {
                        self.profiles.insert(contentsOf: newProfiles, at: 0)
                    }
                }
                
            } catch {
                print("Error fetching profiles: \(error)")
            }
        }

//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let token = tokenManger.accessToken;
//        
//        print (token)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        do {
////            request.httpBody = try JSONEncoder().encode(data)
//        } catch {
//            print (error.localizedDescription)
//            throw error
//        }
//        
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw StringError(message: "Invalid response received")
//            }
//            
//            if httpResponse.statusCode >= 400 {
//                
//                throw StringError(message: "\(httpResponse.statusCode )" )
//            }
//            
//            do {
//                print ("decode started")
//                
//                print (data)
//                let decodedResponse = try JSONDecoder().decode([Profile].self, from: data)
//                
//                print ("decode ended")
//                
//                
////                added to display animating bar under tabs
////                if( tokenManger.isFirstTimeLoading == true ){
////                    
////                    tokenManger.isFirstTimeLoading = false;
////                }
////                else {
////                    try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds = 300,000,000 nanoseconds
////                }
////
//                
//                DispatchQueue.main.async {
//                    
//                  
//                    
//                    self.profiles = decodedResponse.reversed()
//                    
//                    isLoading=false
//                    
////                   k
//                }
//                
//            } catch {
//                
//                print (error.localizedDescription)
//                
//                throw StringError(message: "Failed to decode response data")
//            }
//        }
        
        
        
    };
    
    
    private let images = ["person.fill", "star.fill"] // Replace with your images

    @State private var isLoading: Bool = false
    
    func removeProfile(with id: String) {
        if let index = profiles.firstIndex(where: { $0.id == id }) {
            profiles.remove(at: index)
        }
    }
        
    var body: some View {
        
        ZStack {
            
            
                   if isLoading {
                      
                   } else if !profiles.isEmpty {
                       
                       VStack (spacing: 0 ) {
                           
                         
                           ZStack {
                               
                               
//                               
//                               if profiles.count >= 2 {
//                                   let index = max(profiles.count - 2, 0) // fallbacks to 0 when only one profile left
//                                   let binding = Binding(
//                                       get: { profiles[index] },
//                                       set: { profiles[index] = $0 }
//                                   )
////
//                               if let binding = Binding<Profile>($secondProfile) {
//                                   SwipeableView(
//                                       item: binding,
//                                       onSwipeRight: {
//                                           // logic
//                                       },
//                                       onSwipeLeft: {
//                                           // logic
//                                       },
//                                       shouldSwipe: false
//                                   )
//                                   .id(binding.wrappedValue.id)
//                               }
//                               }
//                               
                               
//                               
//                               if profiles.count >= 1 && isButtonDisabled {
//                                   let index = max(profiles.count - 1, 0) // fallbacks to 0 when only one profile left
//                                   let binding = Binding(
//                                       get: { profiles[index] },
//                                       set: { profiles[index] = $0 }
//                                   )
//
//                                   SwipeableView(
//                                       item: binding,
//                                       onSwipeRight: {
//                                           // logic
//                                       },
//                                       onSwipeLeft: {
//                                           // logic
//                                       },
//                                       shouldSwipe: false
//                                   ).id( profiles[index].id)
//                               }
//                               
//                               
//                               
                               if !profiles.isEmpty {
                                   ForEach(profiles.indices , id: \.self ) { index in
                                       
                                      
                                       if ( index == profiles.count - 1 || ( ( index ) == profiles.count - 2 ) )

                                       //                                            && showRejected == false && showHeart == false
                                       
                                       { // Show topmost item
                                           
                                           
                                        
                                           
                                           SwipeableView(
                                            item: $profiles[index],
                                            onSwipeRight: {
                                                
                                                
                                                // Start an asynchronous task for the network request
                                                
                                                if !profiles.isEmpty {
                                                    
                                                  
                                                    
                                                    
                                                    
                                                    withAnimation {
                                                        DispatchQueue.main.async {
                                                            swipeRightId = profiles[index].id
                                                            print ("swiperight Id: \(swipeRightId)")
                                                            removeProfile(at: index)
                                                        }
                                                    }
                                                }
                                                
                                                
                                            } ,
                                            onSwipeLeft: {
                                                
                                                //
                                                //                                                        // Start an asynchronous task for the network request
                                                //                                                                                  Task {
                                                //                                                                                      do {
                                                //                                                                                          // Call the asynchronous function with the local copy
                                                //                                                                                          try await likeTheProfile(user2_id: profiles[index].id)
                                                //                                                                                      } catch {
                                                //                                                                                          // Handle any errors here
                                                //                                                                                          print("Failed to like the profile: \(error)")
                                                //                                                                                      }
                                                //
                                                //
                                                //                                                                                  }
                                                //
                                                //                                                       withAnimation {
                                                
                                                if !profiles.isEmpty {
                                                    
                                                    swipeLeftId = profiles[index].id
                                                    
                                                    removeProfile(at: index)
                                                }
                                                
                                            } ,
                                            shouldSwipe : index == profiles.count - 1
                                            
                                           ).onAppear(){
                                               
                                               isButtonDisabled = false
                                               
                                               if (  profiles.indices.contains(index-1)
                                               ){
                                                   
                                                   secondProfile = profiles[index-1]
                                               }
                                               else {
                                                   secondProfile = nil
                                               }
                                           }
                                       }
                                       
//                                       
//                                       if ( index == profiles.count - 1 && showHeart ){
//                                           
//                                           Image(systemName: "heart.fill")
//                                               .resizable()
//                                               .scaledToFit()
//                                               .shadow(radius: 10)
//                                               .frame(width: 100, height: 100)
//                                               .foregroundColor(.pink)
//                                               .opacity(showHeartAnimation ? 1 : 0)
//                                               .scaleEffect(showHeartAnimation ? 1.2 : 0.8)
//                                               .animation(.easeInOut, value: showHeartAnimation)
//                                           
//                                       }
//                                       else
//                                       if (  index == profiles.count - 1 && showRejected ){
//                                           
//                                           Image(systemName: "xmark.circle.fill")
//                                                              .resizable()
//                                                             
//                                                              .foregroundColor(.gray)
//                                                              
//                                                              .scaledToFit()
//                                                              .shadow(radius: 3)
//                                                              .frame(width: 100, height: 100)
//                                                             
//                                                              .opacity(showRejectedAnimation ? 1 : 0)
//                                                              .scaleEffect(showRejectedAnimation ? 1.2 : 0.8)
//                                                              .animation(.easeInOut, value: showRejectedAnimation)
//                                                             
//                                       }
                                  
                                       
                                       if ( loadAllImages ) {
                                           
                                           CachedImageView(
                                            url: URL(string: "\(tokenManger.serverImageURL)/\(profiles[index].photo ?? "image.jpg")"),
                                            width: UIScreen.main.bounds.width - 25.0,
                                            height: UIScreen.main.bounds.height * 0.6,
                                            failureView: {
                                                VStack {
                                                    Color.gray
                                                        .frame(width: UIScreen.main.bounds.width - 25.0, height: UIScreen.main.bounds.height * 0.6)
                                                        .cornerRadius(20)
                                                    //
                                                    //                                                Button("Retry") {
                                                    //                                                    // Implement retry logic if needed
                                                    //                                                }
                                                    //                                                .padding()
                                                }
                                            },
                                            storeInDisk : true
                                           ).hidden()
                                       }
                                       
                                   }
                               }
                           }.frame(maxHeight:.infinity)
                           
                           HStack {
                               Button(action: swipeLeft) {
                                   Image(systemName: "xmark")
                                                      .foregroundColor(.gray) // Grey color for the X icon
                                                      .font(.system(size: 23)) // Adjust size of the icon
                                                      .frame(width: 50, height: 50) // Standard button size
                                                      .background(Color.white) // Same background for consistency
                                                      .cornerRadius(25) // Same rounded corners
                                                      .shadow(radius: 5) // Same shadow for both buttons
                               }.disabled(isButtonDisabled)
                               .padding()
                               
                               Button(action: swipeRight) {
                                   Image(systemName: "heart.fill")
                                                      .foregroundColor(.red)
                                                      .font(.system(size: 23)) // Adjust size of the icon
                                                      .frame(width: 50, height: 50) // Standard button size
                                                      .background(Color.white)
                                                      .cornerRadius(25) // Rounded corners
                                                      .shadow(radius: 5)
                                   
                               }.disabled(isButtonDisabled)
                               .padding()
                           }.frame(height: 28).padding(5).padding(.bottom , 28).background(Color.clear) // Transparent background
                           
                           
                           Color.clear.frame(height: 90)
                           
//                           // Temporary height element at the bottom (100 height)
//                           Color.clear
//                               .frame(height: 120) // This will push the content up and allow scrolling
                       }
                   } else {
                       Text("No items to display.")
                           .font(.headline)
                           .foregroundColor(.gray)
                   }
        }.frame(maxWidth: .infinity , maxHeight: .infinity).background(themeManager.currentTheme.backgroundColor)
               .edgesIgnoringSafeArea(.top)
        .popup(isPresented: $isPopupPresented) {
            ChatPopupView(isPresented: $isPopupPresented, profile: profiles[currentIndex] )
        }.overlay{
            
            isLoading ?
           VStack {
              
               ProgressView("Loading...")
               
                   .scaleEffect(1).foregroundColor(themeManager.currentTheme.primaryColor).tint(themeManager.currentTheme.primaryColor).padding(.bottom, 100)
           }
           : nil
           
           
       }
        .onChange( of : swipeRightId ) { _, newVaulue in
            
            Task {
                do {
                    
                    showHeart = true
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showHeartAnimation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + buttonClickDelay + 0.01 ) {
                        
                        showHeart = false ;
                        
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showHeartAnimation = false
                        }
                    }
                   
                    // Call the asynchronous function with the local copy
                    try await likeTheProfile(user2_id: newVaulue)
                    
                    await ProfileService.deleteProfile(by: newVaulue, from: modelContext)
               
                    
                    print ("swipeRightId \(swipeRightId) deleted")
                    
                    if ( profiles.count <= 5 ) {
                        try await fetchProfiles()
                    }
                    
                    
                  
                   
                    
                } catch {
                    // Handle any errors here
                    print("Failed to like the profile: \(error)")
                }
                
              
            }
            
        }
        .onChange( of : swipeLeftId ) { _, newVaulue in
            
            
            Task {
                do {
                    
                   
                    showRejected = true
                    
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showRejectedAnimation = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + buttonClickDelay + 0.01 ) {
                        
                        showRejected = false
                        
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showRejectedAnimation = false
                        }
                    }
                   
//                     Call the asynchronous function with the local copy
                    try await unLikeTheProfile(user2_id: newVaulue)
                    
                    await ProfileService.deleteProfile(by: newVaulue, from: modelContext)
                    
                    if ( profiles.count <= 5 ) {
                        try await fetchProfiles()
                    }
                    
                    
                } catch {
                    // Handle any errors here
                    print("Failed to unlike the profile: \(error)")
                }
                
              
            }
            
        }
        .onAppear {
            Task {
                do {
                    
                  
                    isLoading = true;
                    
                    
                    profiles = await ProfileService.fetchProfiles(from: modelContext)
                    
                    
                    if ( profiles.count == 0) {
                        
                        try await fetchProfiles()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0 ) {
                        isLoading = false
                    }

                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadAllImagesAfterDelay ) {
                        loadAllImages = true
                    }

                    
                } catch {
                    print("Failed to fetch profiles: \(error)")
                    
                    isLoading = false;
                }
            }
        }
        .background(themeManager.currentTheme.backgroundColor)
      
    }
    
    private func swipeLeft () {
        if !isButtonDisabled {
                isButtonDisabled = true
                
                // Perform your action here
                print("Button clicked!")
                
               
           
        if(!profiles.isEmpty) {
         profiles[self.profiles.count-1].leftSwipe = UUID();
            
           
            
       }
            
          
            
        }
    }
    
    private func swipeRight () {
        
        if !isButtonDisabled {
            
            isButtonDisabled = true
                
                // Perform your action here
                print("Button clicked!")
        
            if(!profiles.isEmpty) {
                profiles[self.profiles.count-1].rightSwipe = UUID();
                
           
                
            }  // Enable the button after 20ms
           
            
        }
    }
    
    private func removeProfile(at index: Int) {
            guard profiles.indices.contains(index) else { return }
        
        
        isButtonDisabled = true
           
        DispatchQueue.main.async {
            profiles.remove(at: index)
        }
    
        }
  
}

extension View {
    func popup<PopupContent: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> PopupContent) -> some View {
        self.modifier(Popup(isPresented: isPresented, content: content))
    }
}



struct Popup<PopupContent: View>: ViewModifier {
    let isPresented: Binding<Bool>
    let content: () -> PopupContent

    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isPresented.wrappedValue {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        self.content()
                            .frame(width: 300, height: 200)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 20)
                            .transition(.scale)
                    }
                }
            )
    }
}



struct  MatchesNewDevsView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        MatchesNewDevsView().environmentObject(TokenManager()).environmentObject(ThemeManager())
        
//        HobbiesCardView(hobbies: ["asdf","dfddf"])
    }
}


struct GrayCard: View {
    var title: String
    var content: String
    
    var body: some View {
      
            HStack ( ) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .background(.gray)
                Text(content)
                    .font(.caption)
                    .foregroundColor(.white)
                    .background(.gray)
                   
              
            }.frame( maxWidth:.infinity, alignment: .topLeading) 
            
//            .background(Color.gray.opacity(0.5))
       
    }
}

struct ChatPopupView: View {
    @Binding var isPresented: Bool
     var profile: Profile
    @State private var message: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Send a message to \(String(describing: profile.name ?? "" ))")
                .font(.headline)
            
            TextField("Enter your message", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button(action: {
                    // Handle send action
                    print("Message sent to \(String(describing: profile.name)): \(message)")
                    
                    withAnimation {
                        
                        isPresented = false
                    }
                    
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    withAnimation {
                        
                        isPresented = false
                    }
                }) {
                    Text("Cancel")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}





struct SwipeableView: View {
    @Binding var item: Profile
    let onSwipeRight: () -> Void
    let onSwipeLeft: () -> Void
    

    var shouldSwipe : Bool = true
    
    @State private var offset: CGSize = .zero
    @State private var isHidden: Bool = false
    @EnvironmentObject private var tokenManger : TokenManager
    @State private var initialDragPosition: CGPoint = .zero
    
    @EnvironmentObject private var themeManager : ThemeManager
    
    @State private var image: UIImage?
    
    @State private var rowsCount : Int = 1
    
    
    @State var showHeartAnimation : Bool = false
    @State var showRejectedAnimation : Bool = false
  
    @State var showHeart : Bool = false;
    @State var showRejected : Bool = false;
   
    
    var sizeTextInCard = 15.0
    var selectedSize : CapsuleSize = .medium
    
    var body: some View {
        
        VStack {
            ScrollView {
                VStack {
                    VStack {
                        ZStack(alignment: .bottomLeading) {
                            
                            CachedImageView(
                                        url: URL(string: "\(tokenManger.serverImageURL)/\(item.photo ?? "image.jpg")"),
                                        width: UIScreen.main.bounds.width - 25.0,
                                        height: UIScreen.main.bounds.height * 0.6,
                                        failureView: {
                                            VStack {
                                                Color.gray
                                                    .frame(width: UIScreen.main.bounds.width - 25.0, height: UIScreen.main.bounds.height * 0.6)
                                                    .cornerRadius(20)
//
//                                                Button("Retry") {
//                                                    // Implement retry logic if needed
//                                                }
//                                                .padding()
                                            }
                                        },
                                        storeInDisk : true
                                    )
                                .cornerRadius(20) // Add corner radius here
                               
                       
                               
                            // Text overlay on the image
                            VStack(alignment: .leading, spacing: 8) {
                                
                                VStack(alignment: .leading,spacing: 8) {
                                    Text(item.name ?? "Unknown Name")
                                        .font( themeManager.currentTheme.font) // Adjust as needed
                                    
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    //                                Text("Experience: \(item.experience ?? 0) years")
                                    //                                    .font( themeManager.currentTheme.subHeadLinefont)
                                    
                                    // Default system subheadline size ≈ 15pt
                                    
                                        .foregroundColor(.white)
                                    
                                    WrapViewArray(options: $item.technologies , selectedSize: .medium,backgroundColor: .white , foregroundColor: .black ).frame(maxWidth: UIScreen.main.bounds.width-25.0 )
                                        .padding(.horizontal)
                                    //
                                   
                                        HStack {
                                            if let gender = item.gender {
                                                ChipItem(text: "\(Utils.UDate.getAge(dob: item.dob)) age", selectedSize: .large, icon: "\(gender)-symbol" , isBold: true)
                                                   
                                            }

                                            if let jobRole = item.jobRole {
                                                ChipItem(text: "job role :  \(jobRole)", selectedSize: .large, icon: "jobRole2" ,
                                                         isBold: true ,
                                                
                                                         maxWidth: 200
                                                
                                                )
                                                
                                                    
                                            }
                                            
                                            Spacer()
                                        }.padding(.horizontal)
                                        
                                    HStack {
                                        if let distanceInKm = item.distanceInKm {
                                            ChipItem(text: "\(Int(distanceInKm.rounded())) km Away", selectedSize: .large ,
                                                     icon: "location-black" ,
                                                     backgroundColor: Color(hex : "#F84B00") ,
                                                     foregroundColor: .black ,
                                                     isBold : true
                                                    
                                            )
                                               
                                        }
 
                                        Spacer()
                                    }.padding(.horizontal)
                                 
                                        //                                Text("Technologies: \(item.technologies?.joined(separator: ", ") ?? "N/A")")
                                        //                                    .font( themeManager.currentTheme.subHeadLinefont)
                                        //                                    .frame(width:  UIScreen.main.bounds.width - 40.0 ,alignment: .leading) // Align text to the leading edge )
                                        //                                    .foregroundColor(.white).lineLimit(nil) // Allow multiple lines
                                        //                                    .fixedSize(horizontal: false, vertical: true) // Ensure it wraps vertically
                                        //
                                                                        
                                  
                                    
                                }
                                .padding(.bottom)
//                                else {
//                                    Text( "no gender")
//                                }
                            }
                            
                            
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            ) .cornerRadius(20) // Add corner radius here
                            
                            
                            
                            ZStack {
                                if showHeart {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 10)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.pink)
                                        .opacity(showHeartAnimation ? 1 : 0)
                                        .scaleEffect(showHeartAnimation ? 1.2 : 0.8)
                                        .animation(.easeInOut, value: showHeartAnimation)
                                }

                                if showRejected {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 3)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.black)
                                        .opacity(showRejectedAnimation ? 1 : 0)
                                        .scaleEffect(showRejectedAnimation ? 1.2 : 0.8)
                                        .animation(.easeInOut, value: showRejectedAnimation)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .zIndex(1)

                            
                            
                        }
                        .if(shouldSwipe) { view in
                            
                            view.offset(x: offset.width, y: 0)
                        }
                        .if(shouldSwipe) { view in
                            view.rotationEffect(.degrees(Double(offset.width / 20)))
                        }
                        .if(shouldSwipe) { view in
                            view.simultaneousGesture(
                                DragGesture()
                                    .onChanged { value in
                                        offset = value.translation // Move card with finger
                                        let horizontalTranslation = value.translation.width
                                        let verticalTranslation = value.translation.height
                                        
                                        
                                        if abs(horizontalTranslation) > abs(verticalTranslation) {
                                            // Horizontal swipe
                                            if horizontalTranslation > 50 {
                                                
                                                showRejected = false;
                                                    showHeart = true;
                                                
                                                showRejectedAnimation = false;
                                                showHeartAnimation = true;
                                                
                                                print("heart")
                                                
                                                return;
                                            } else if horizontalTranslation < -50 {
                                                
                                                showHeart = false;
                                                showRejected = true
                                                
                                                showHeartAnimation = false;
                                                showRejectedAnimation = true;
                                               
                                                print("rejected")
                                                return
                                            }
                                            else {
                                                
                                                showHeart = false;
                                                showRejected = false
                                                
                                                showHeartAnimation = false;
                                                showRejectedAnimation = false;
                                               
                                            }
                                            
                                            
                                        } else {
                                            // Vertical swipe
                                            if verticalTranslation < -50 {
                                                
                                                //                                            print("Up Swipe Detected")
                                                
                                            }
                                            offset = .zero
                                            
                                        }
                                        
                                    }
                                    .onEnded { value in
                                        
                                        let horizontalTranslation = value.translation.width
                                        let verticalTranslation = value.translation.height
                                        
                                        if abs(horizontalTranslation) > abs(verticalTranslation) {
                                            // Horizontal swipe
                                            if horizontalTranslation > 50 {
                                                
                                                print( "Right Swipe Detected")
                                                
                                                
                                                swipeRight()
                                                return;
                                            } else if horizontalTranslation < -50 {
                                                
                                                print("Left Swipe Detected")
                                                
                                                swipeLeft()
                                                return
                                            }
                                            
                                            offset = .zero
                                        } else {
                                            // Vertical swipe
                                            if verticalTranslation < -50 {
                                                
                                                //                                            print("Up Swipe Detected")
                                                
                                            }
                                            offset = .zero
                                            
                                        }
                                    }
                                
                            )
                        }
                        .frame(width: UIScreen.main.bounds.width - 25.0, height: UIScreen.main.bounds.height * 0.6)
                        .opacity(isHidden ? 0 : 1).padding(8)
                        
                    }
                    
                    VStack {
                        BioCardView(bio: item.bio ?? "" , sizeTextInCard: sizeTextInCard )
                        
                        AgeCardView(dob: item.dob )
                        
                        TechnologiesCardView(technologies: $item.technologies  , sizeTextInCard: sizeTextInCard )
                        
                        JobRoleCardView(jobRole: $item.jobRole  , sizeTextInCard: sizeTextInCard )
                        
                        HobbiesCardView(hobbies2: $item.hobbies , sizeTextInCard: sizeTextInCard )
                        
                        SmokingCardView(smoking: $item.smoking , sizeTextInCard: sizeTextInCard )
                        
                        
                        DrinkingCardView(drinking: $item.drinking  , sizeTextInCard: sizeTextInCard )
                        
                        
                        // Temporary height element at the bottom (100 height)
                        Color.clear
                            .frame(height: 120) // This will push the content up and allow scrolling
                        
                    }.background(themeManager.currentTheme.backgroundWithNoOpacity)
                    
//                    Text("Profile Bio:")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .fontWeight(.bold)
//                        .padding()
//                    
//                    Text( item.bio ?? "")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                        .lineLimit(nil)
//                    
                    
                    
                    
                }
                
              
                
            }.padding()
                .onChange(of: item.leftSwipe ) {
                    
                    
                    self.showRejected = true;
                    self.showRejectedAnimation = true;
                    
                    self.swipeLeft();
                    
                    
                }
                .onChange(of: item.rightSwipe ) {  

                    self.showHeart = true;
                    self.showHeartAnimation = true;
                    
                    self.swipeRight();
                    

                }
            
//            HStack {
//                Button(action: swipeLeft) {
//                    Image(systemName: "xmark")
//                                       .foregroundColor(.gray) // Grey color for the X icon
//                                       .font(.system(size: 23)) // Adjust size of the icon
//                                       .frame(width: 60, height: 60) // Standard button size
//                                       .background(Color.white) // Same background for consistency
//                                       .cornerRadius(30) // Same rounded corners
//                                       .shadow(radius: 5) // Same shadow for both buttons
//                }
//                .padding()
//                
//                Button(action: swipeRight) {
//                    Image(systemName: "heart.fill")
//                                       .foregroundColor(.red)
//                                       .font(.system(size: 23)) // Adjust size of the icon
//                                       .frame(width: 60, height: 60) // Standard button size
//                                       .background(Color.white)
//                                       .cornerRadius(30) // Rounded corners
//                                       .shadow(radius: 5)
//                    
//                }
//                .padding()
//            }.frame(height:30).padding(.bottom , 10)
            
//            Color.clear
//                .frame(height: 100)
        }
       
    }
 
  
      private func swipeLeft() {
          
          print ("swipe left called")
          
          withAnimation(.easeIn(duration: 0.2)) {
               offset = CGSize(width: -UIScreen.main.bounds.width, height: 0)
               isHidden = true
               
           }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
              onSwipeLeft()
          }
       }

       private func swipeRight() {
           
           print ("swipe right called")
           
           
           withAnimation(.easeIn(duration: 0.2)) {
               offset = CGSize(width: UIScreen.main.bounds.width, height: 0)
               isHidden = true
              
           }
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
               onSwipeRight()
           }
              
       }
    
    
      private func swipeUp() {
         // Handle natural scroll up
         withAnimation {
             offset = CGSize(width: 0, height: -200) // Scroll up behavior, adjust height as needed
         }
     }
     
     private func swipeDown() {
         // Handle natural scroll down
         withAnimation {
             offset = CGSize(width: 0, height: 200) // Scroll down behavior, adjust height as needed
         }
     }
}


struct AgeCardView: View {
    var dob: Date?
    @EnvironmentObject var themeManager : ThemeManager
    
    var age: String {
            guard let dob = dob else { return "N/A" } // Handle nil case
            let calendar = Calendar.current
            let birthYear = calendar.component(.year, from: dob)
            let currentYear = calendar.component(.year, from: Date())
            return "\(max(0, currentYear - birthYear))"
        }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Age")
                    .font(themeManager.currentTheme.headlinefont)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("\(age) years")
                    .font(.custom(themeManager.currentTheme.fontName, size: 40 ))
                    .foregroundColor( themeManager.currentTheme.subTextColor)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
            }
            .cardStyle()
//            .padding(8)
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
//            )
        }
        .padding(.horizontal, 25)
    }
}



struct DistanceCardView: View {
    var distanceInKm: Double?
    @EnvironmentObject var themeManager : ThemeManager
    
    var distance: String {
         guard let distanceInKm = distanceInKm else { return "N/A" } // Handle nil case
         return "\( Int(distanceInKm.rounded())) km away "
        }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Distance")
                    .font(themeManager.currentTheme.headlinefont)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("\(distance)")
                    .font(.custom(themeManager.currentTheme.fontName, size: 40 ))
                    .foregroundColor( themeManager.currentTheme.subTextColor)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
            }
            .cardStyle()
//            .padding(8)
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
//            )
        }
        .padding(.horizontal, 25)
    }
}




struct BioCardView: View {
    var bio: String = ""
    
    @EnvironmentObject var themeManager : ThemeManager
    
    var sizeTextInCard = 30.0
    
    var body: some View {
        
        VStack {
            VStack(alignment: .leading, spacing: 4) { // Reduce spacing
                Text("About Me")
                    .font(themeManager.currentTheme.headlinefont)
                               .fontWeight(.bold)
                               .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.9)) // Modern white tint
                               .padding(.horizontal, 10)
                               .padding(.top, 10)
                               .frame(maxWidth: .infinity, alignment: .leading)
                           
                           Text(bio)
                    .font(themeManager.currentTheme.subHeadLinefont)
                               .foregroundColor( themeManager.currentTheme.subTextColor)
                               .lineLimit(nil)
                               .padding(.horizontal, 10)
                               .padding(.bottom, 10)
            }
            .padding(8) // Reduce padding
            .cardStyle()
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 14)
//                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
//                    )
        }.padding(.horizontal, 25)
           
    }
    
}

struct TechnologiesCardView: View {
    @Binding var technologies: [String]?
   
    var sizeTextInCard = 30.0
    
    @EnvironmentObject var themeManager : ThemeManager
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var rowsCount:Int = 0

    
    var body: some View {
        
//        let formattedTechnologies = technologies.map { "#\($0)" }
//        
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Technologies")
                    .font(themeManager.currentTheme.headlinefont)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                WrapViewArray (options: $technologies, selectedSize: .large)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .padding(.bottom, 10)
                
//                LazyVGrid(columns: columns, spacing: 15) {
//                    ForEach(technologies, id: \.self) { tech in
//                Text(technologies.joined(separator: ", ")).lineLimit(nil) // Allows unlimited lines
//                
//                            .font(.system(size: sizeTextInCard))
//                            .foregroundColor( themeManager.currentTheme.subTextColor)
//                            .padding(.horizontal, 10)
//                            .padding(.bottom, 10)
////                    }
////                }
               
            }
            .cardStyle()
            
//            .padding(8) // Reduce padding
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
//            )
        }.padding(.horizontal, 25)
    }
}

struct HobbiesCardView: View {
    @Binding var hobbies2: [String]?
    
    var sizeTextInCard = 30.0
    
    @EnvironmentObject var themeManager : ThemeManager
    
    
    @State var hobbies : [String] = []
    
    @State var rowsCount:Int = 1

    
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
//        let formattedHobbies = hobbies2.map { "#\($0)" }
//        
        
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Hobbies")
                    .font(themeManager.currentTheme.headlinefont)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
         
                WrapViewArray (options: $hobbies2, selectedSize: .large )
                    .padding(.horizontal, 10)
                    .padding(.bottom , 10)
                   
                
////                LazyVGrid(columns: columns, spacing: 15) {
////                    ForEach(hobbies, id: \.self) { hobby in
//                Text(hobbies.joined(separator: ", ")).lineLimit(nil) // Allows unlimited lines
//                            .font(.system(size: sizeTextInCard))
//                            .foregroundColor( themeManager.currentTheme.subTextColor )
//                            .padding(.horizontal, 10)
//                            .padding(.bottom, 10)
////                    }
////                }
//                .padding(.horizontal, 10).padding(.vertical, 10)
                
               
            }
           
            .cardStyle()
            
//            .padding(8)
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
//            )
        }.padding(.horizontal, 25)
//            .onAppear(){
//                self.hobbies = hobbies2 + ["aasdfasdfdsafaf", "asdfasdfasdf" , "dfdfdfdfdf" , "asdfasdfasdf"]
//            }
    }
}

struct SmokingCardView: View {
    @Binding var smoking: String?
    var sizeTextInCard = 30.0
    @EnvironmentObject var themeManager : ThemeManager
    
    
    @State var rowsCount:Int = 0

    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) { // Reduce spacing
                Text("Smoking")
                    .font(themeManager.currentTheme.headlinefont)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                WrapViewSingle (option: $smoking, selectedSize: .large  )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .padding(.bottom, 10)
                
//                HStack {
//                    
//                    Text(smoking.isEmpty ? "Not Specified" : smoking)
//                        .font(.system(size: sizeTextInCard))
//                        .foregroundColor( themeManager.currentTheme.subTextColor )
//                        .padding(.horizontal, 10)
//                        .padding(.bottom, 10)
//                    
//                    Spacer()
//                }.padding(.vertical, 10)
            }
            .cardStyle()
//            .padding(8) // Reduce padding
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
//            )
        }.padding(.horizontal, 25)
    }
    
    /// Function to determine background gradient based on smoking status
    private func getGradient(for smoking: String) -> LinearGradient {
        switch smoking {
        case "Never":
            return LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.teal]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "Occasionally":
            return LinearGradient(
                gradient: Gradient(colors: [Color.orange, Color.yellow]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "Regularly":
            return LinearGradient(
                gradient: Gradient(colors: [Color.red, Color.orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "Trying to Quit":
            return LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.black.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct DrinkingCardView: View {
    @Binding var drinking: String?
    var sizeTextInCard = 30.0
    @EnvironmentObject var themeManager : ThemeManager
    
    
    @State var rowsCount:Int = 0

    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) { // Reduce spacing
                Text("Drinking")
                    .font(themeManager.currentTheme.headlinefont)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
               
                
                
                WrapViewSingle (option: $drinking
                                , selectedSize: .large )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .padding(.bottom, 10)
                
//                
//                HStack {
//                  
//                Text(drinking.isEmpty ? "Not Specified" : drinking)
//                        .font(.system(size: sizeTextInCard))
//                        .foregroundColor( themeManager.currentTheme.subTextColor )
//                        .padding(.horizontal, 10)
//                        .padding(.bottom, 10)
//                    Spacer()
//                }.padding(.vertical, 10)
                
            }.cardStyle()
//            .padding(8) // Reduce padding
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
//            )
        }.padding(.horizontal, 25)
    }
    
    /// Function to determine background gradient based on drinking status
    private func getGradient(for drinking: String) -> LinearGradient {
        switch drinking {
        case "Never":
            return LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.teal]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "Socially":
            return LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "Occasionally":
            return LinearGradient(
                gradient: Gradient(colors: [Color.orange, Color.yellow]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "Frequently":
            return LinearGradient(
                gradient: Gradient(colors: [Color.red, Color.pink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.black.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}


struct JobRoleCardView: View {
    @Binding var jobRole: String?
    var sizeTextInCard = 30.0
    
    @EnvironmentObject var themeManager : ThemeManager
    @State var rowsCount:Int = 0

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Job Role")
                    .font(themeManager.currentTheme.headlinefont)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
               
                WrapViewSingle (option: $jobRole, selectedSize: .large )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .padding(.bottom, 10)
                
//                HStack {
//               
//                    Text(jobRole.isEmpty ? "Not Specified" : jobRole)
//                        .font(.system(size: sizeTextInCard))
//                        .foregroundColor( themeManager.currentTheme.subTextColor )
//                        .padding(.horizontal, 10)
//                        .padding(.bottom, 10)
//                        .padding(.horizontal, 10).padding(.vertical, 10)
//                    Spacer()
//                }
            }
           
            .cardStyle()
//            .padding(8) // Reduce padding
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
//            .overlay(
//                RoundedRectangle(cornerRadius: 14)
//                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
//            )
        }.padding(.horizontal, 25)
    }

    /// Function to determine background gradient based on job level
    private func getGradient(for jobRole: String) -> LinearGradient {
        switch jobRole.lowercased() {
        case "intern":
            return LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "junior level":
            return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "mid level":
            return LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "senior level":
            return LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "lead level":
            return LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "manager":
            return LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "director":
            return LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "vice president":
            return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "chief technology officer (cto)", "chief information officer (cio)", "chief product officer (cpo)", "chief operating officer (coo)":
            return LinearGradient(gradient: Gradient(colors: [Color.gray, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "chief executive officer (ceo)":
            return LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}


//
//Vstack 
//{
//    TabView(selection: $currentIndex) {
//        ForEach(profiles.indices, id: \.self) { index in
//            VStack {
//               
//                ScrollView  {
//                    
//                    VStack {
//                        
//                        ZStack {
//                            GeometryReader { geometry in
//                                   AsyncImage(url: URL(string: "\(tokenManger.localhost)/images/\(profiles[index].photo ?? "image.jpg")")) { image in
//                                       image
//                                           .resizable()
//                                           .scaledToFill()
//                                           .frame(width: geometry.size.width, height: UIScreen.main.bounds.height * 0.60 )
//                                           .clipped()
//                                           .cornerRadius(10)
//                                     
////                                                   .overlay(
////                                                                      RoundedRectangle(cornerRadius: 20)
////                                                                          .stroke(Color.clear, lineWidth: 0)
////                                                                          .shadow(color: Color.blue.opacity(0.7), radius: 10, x: 0, y: 0)
////                                                                  )
////                                                                  .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 0)
////
//                                       
//                                   } placeholder: {
//                                       ProgressView()
//                                           .frame(width: geometry.size.width, height: UIScreen.main.bounds.height * 0.60  )
//                                   }
//                               }
//                            
//                            VStack( alignment: .leading , spacing: 5 ) {
//                                
//                                Spacer().frame(maxHeight:.infinity)
//                               
////                                        VStack{
////                                            Spacer()
//                                GrayCard(title: "Name", content: profiles[index].name ?? "")
//                                                 
//                                 
//                                    GrayCard(title: "Experience", content: "\(profiles[index].experience ?? 0)")
//                                                 
//                                    GrayCard(title: "Technology", content: profiles[index].technologies?.joined(separator: ", ") ?? "")
//                                                 
//                                 
//                                  
//                                    
////                                        }
////                                        .frame( maxHeight: .infinity, alignment: .leading)
////                                        .padding()
////
////
//                                    .cornerRadius(10)
////                                        .shadow(radius: 2)
//                                //                                }
//                                //                                .padding()
//                                
//                             
//                            }.frame(maxWidth : .infinity, maxHeight: .infinity, alignment: .bottomLeading)
//                                .padding()
//                        }.background(Color.blue.opacity(0.01))
//                        
//                             
//                    } .frame(height:  UIScreen.main.bounds.height * 0.60  ).padding()
//
////                                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible())], spacing: 20) {
////
////
//                      
//                    Text("Profile Headline:")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .fontWeight(.bold)
//                        .padding()
//                }.scrollIndicators(.hidden)
//                
//                Spacer()
//                
//                HStack(spacing: 30) {
//                    Button(action: {
//                        withAnimation(.easeInOut(duration: 1.0)) {
//                            currentIndex = min (currentIndex + 1 , profiles.count - 1 )
//                            
//                        }
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .font(.largeTitle)
//                    } .disabled(currentIndex == profiles.count)
//                        .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .clipShape(Circle())
//                    
//                    Button(action: {
//                      
//                        
//                        // Print the current index
//                           print(currentIndex)
//                           
//                           // Create a local copy of the current index
//                           let currentIndex2 = currentIndex
//                           
//                           // Update currentIndex immediately for UI responsiveness
//                           withAnimation(.easeInOut(duration: 1.0)) {
//                               currentIndex = min(currentIndex + 1, profiles.count - 1)
//                           }
//                           
//                           // Start an asynchronous task for the network request
//                           Task {
//                               do {
//                                   // Call the asynchronous function with the local copy
//                                   try await likeTheProfile(currentIndex: currentIndex2)
//                               } catch {
//                                   // Handle any errors here
//                                   print("Failed to like the profile: \(error)")
//                               }
//                           }
//                       
//                        
//                    }) {
//                        Image(systemName: "checkmark.circle.fill")
//                            .font(.largeTitle)
//                        
//                       
//                        
//                    }
//                    .disabled(currentIndex == profiles.count)
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .clipShape(Circle())
//                    
////                            Button(action: {
////
////                                withAnimation {
////                                                 isPopupPresented = true
////                                             }
////                            }) {
////                                Image(systemName: "message.fill")
////                                    .font(.title)
////
////
////                            }
////                            .padding()
////                            .background(Color.blue)
////                            .foregroundColor(.white)
////                            .clipShape(Circle())
//                 
//
//                }
//                .padding(.horizontal)
//                
//               
//            }
//            .tag(index)
//        }.gesture(DragGesture().onChanged { _ in }) // Disable swipe gestures
//    }
//    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never /* turn of dot page index buttons */))
//
//}
