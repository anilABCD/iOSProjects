//
//  MatchesNewDevs.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import Foundation

import SwiftUI


struct MatchesNewDevsView: View {
    
    @State private var currentIndex = 0 ;
    @State var isPopupPresented = false // 1
    @State private var selectedPerson: String = "John Doe"
    
    
  
    @EnvironmentObject private var tokenManger : TokenManager
    @EnvironmentObject private var themeManager : ThemeManager
    
    init(){
        
    }
    
    
    @State private var profiles : [Profile] = [ ];
    
    func likeTheProfile(user2_id : String) async throws {
//
//        let user2_id = profiles[currentIndex].id
//        
//        print(currentIndex, user2_id)
        
        let matches = Matches(user2_id: user2_id )
    
        
        let urlRequest = try createURLRequest(method : "POST" , baseURL: "\(tokenManger.localhost)/matches/", accessToken: tokenManger.accessToken, data: matches, parameters: nil)
        
         let response: MatchesResponse = try await fetchData(from: urlRequest)
        
    }
    
    func fetchProfiles() async throws {
        

        let profileIDs: [String] = profiles.map { $0.id }
        // Convert array to a comma-separated string
        let excludeIdsString = profileIDs.joined(separator: ",")

        // Example usage
        let baseURL = "\(tokenManger.localhost)/profiles"
         
        let data:MatchesFilter? = MatchesFilter(
            technologies: (tokenManger.technologies),
            minAge: "20",
            maxAge: "35",
            excludeProfileIds: excludeIdsString
        )
         
        let urlRequest = try createURLRequest(method : "POST" , baseURL: baseURL, accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
        self.profiles = try await fetchDataArray(from: urlRequest);
        
       
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
        
    var body: some View {
        
        ZStack {
            
            
                   if isLoading {
                       ProgressView("Loading...")
                           .scaleEffect(1.5)
                   } else if !profiles.isEmpty {
                       
                       VStack (spacing: 0 ) {
                           
                           
                           ZStack {
                               
                               ForEach(profiles.indices , id: \.self ) { index in
                                   
                                   if index == profiles.count - 1 { // Show topmost item
                                       
                                       
                                       
                                       SwipeableView(
                                        item: $profiles[index],
                                        onSwipeRight: {
                                            
                                            
                                            // Start an asynchronous task for the network request
                                            Task {
                                                do {
                                                    // Call the asynchronous function with the local copy
                                                    try await likeTheProfile(user2_id: profiles[index].id)
                                                } catch {
                                                    // Handle any errors here
                                                    print("Failed to like the profile: \(error)")
                                                }
                                                
                                                withAnimation {
                                                    removeProfile(at: index)
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
                                            removeProfile(at: index)
                                            
                                            
                                        }
                                        
                                       )
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
                               }
                               .padding()
                               
                               Button(action: swipeRight) {
                                   Image(systemName: "heart.fill")
                                                      .foregroundColor(.red)
                                                      .font(.system(size: 23)) // Adjust size of the icon
                                                      .frame(width: 50, height: 50) // Standard button size
                                                      .background(Color.white)
                                                      .cornerRadius(25) // Rounded corners
                                                      .shadow(radius: 5)
                                   
                               }
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
        }.frame(maxWidth: .infinity).background(themeManager.currentTheme.backgroundColor)
               .edgesIgnoringSafeArea(.top)
        .popup(isPresented: $isPopupPresented) {
            ChatPopupView(isPresented: $isPopupPresented, profile: profiles[currentIndex] )
        }
        .onAppear {
            Task {
                do {
                    
                  
                    isLoading = true;
                    try await fetchProfiles()
                    isLoading = false;
                    
                } catch {
                    print("Failed to fetch profiles: \(error)")
                    
                    isLoading = false;
                }
            }
        }
        .background(themeManager.currentTheme.backgroundColor)
      
    }
    
    private func swipeLeft () {
        
        if(!profiles.isEmpty) {
         profiles[self.profiles.count-1].leftSwipe = UUID();
       }
    }
    
    private func swipeRight () {
        
        if(!profiles.isEmpty) {
            profiles[self.profiles.count-1].rightSwipe = UUID();
        }
    }
    
    private func removeProfile(at index: Int) {
            guard profiles.indices.contains(index) else { return }
            profiles.remove(at: index)
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
        MatchesNewDevsView().environmentObject(TokenManager())
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
    @State private var offset: CGSize = .zero
    @State private var isHidden: Bool = false
    @EnvironmentObject private var tokenManger : TokenManager
    @State private var initialDragPosition: CGPoint = .zero
    var body: some View {
        
        VStack {
            ScrollView {
                VStack {
                    VStack {
                        ZStack(alignment: .bottomLeading) {
                            // Use AsyncImage to load remote images
                            
                            
                            AsyncImage(url: URL(string: "\(tokenManger.localhost)/images/\(item.photo ?? "image.jpg")")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
                                case .success(let image):
                                    image
                                        .resizable()
                                    
                                        .frame(width: UIScreen.main.bounds.width - 25.0, height: UIScreen.main.bounds.height * 0.6)
                                    
                                        .offset(x: offset.width, y: 0)
                                        .cornerRadius(20) // Add corner radius here
                                        .rotationEffect(.degrees(Double(offset.width / 20)))
                                    
                                    //                                           .gesture(
                                    //                                            DragGesture()
                                    //                                                                                      .onChanged { gesture in
                                    //                                                                                          // Track the initial position of the drag
                                    //                                                                                          if initialDragPosition == .zero {
                                    //                                                                                              initialDragPosition = gesture.startLocation
                                    //                                                                                          }
                                    //
                                    //                                                                                          // Update the offset with both x and y translations
                                    //                                                                                          offset = gesture.translation
                                    //                                                                                      }
                                    //                                                                                      .onEnded { gesture in
                                    //                                                                                          let swipeThreshold: CGFloat = 50 // Threshold to detect swipe
                                    //
                                    //                                                                                          // Handle horizontal swipe (left or right)
                                    //                                                                                          if abs(gesture.translation.width) > swipeThreshold {
                                    //                                                                                              if gesture.translation.width > 0 {
                                    //                                                                                                  swipeRight() // Swipe Right
                                    //                                                                                              } else {
                                    //                                                                                                  swipeLeft() // Swipe Left
                                    //                                                                                              }
                                    //                                                                                          }
                                    //                                                                                          // Handle vertical swipe (up or down)
                                    //                                                                                          else if abs(gesture.translation.height) > swipeThreshold {
                                    //                                                                                              if gesture.translation.height < 0 {
                                    //                                                                                                  swipeUp() // Swipe Up
                                    //                                                                                              } else {
                                    //                                                                                                  swipeDown() // Swipe Down
                                    //                                                                                              }
                                    //                                                                                          } else {
                                    //                                                                                              // If it's not a meaningful swipe, reset the offset
                                    //                                                                                              withAnimation {
                                    //                                                                                                  offset = .zero
                                    //                                                                                              }
                                    //                                                                                          }
                                    //                                                                                      }
                                    //                                   )
                                case .failure:
                                    Color.gray // Fallback for failed loading
                                    
                                        .frame(width: UIScreen.main.bounds.width - 25.0, height: UIScreen.main.bounds.height * 0.6)
                                    
                                        .offset(x: offset.width, y: 0)
                                        .cornerRadius(20) // Add corner radius here
                                        .rotationEffect(.degrees(Double(offset.width / 20)))
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            // Text overlay on the image
                            VStack(alignment: .leading, spacing: 8) {
                                
                                Text(item.name ?? "Unknown Name")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Text("Experience: \(item.experience ?? 0) years")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                Text("Technologies: \(item.technologies?.joined(separator: ", ") ?? "N/A")")
                                    .font(.subheadline)
                                    .frame(width:  UIScreen.main.bounds.width - 40.0 ,alignment: .leading) // Align text to the leading edge )
                                    .foregroundColor(.white).lineLimit(nil) // Allow multiple lines
                                    .fixedSize(horizontal: false, vertical: true) // Ensure it wraps vertically
                                
                            }
                            .padding(8)
                            
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            ) .cornerRadius(20) // Add corner radius here
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
                        .opacity(isHidden ? 0 : 1).padding(8)
                        
                    }
                    
                  
                    BioCardView(bio: item.bio ?? "" )
                    
                    AgeCardView(dob: item.dob  )
                    
                    TechnologiesCardView(technologies: item.technologies ?? [])
                    
                    JobRoleCardView(jobRole: item.jobRole ?? "")
                    
                    HobbiesCardView(hobbies: item.hobbies ?? [])
                    
                    SmokingCardView(smoking: item.smoking ?? "" )
                    
                    DrinkingCardView(drinking: item.drinking ?? "" )
                    
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
                
                
                // Temporary height element at the bottom (100 height)
                Color.clear
                    .frame(height: 120) // This will push the content up and allow scrolling
                
            }.padding()
                .onChange(of: item.leftSwipe ) { _ in
                    
                    self.swipeLeft();
                    
                    
                }
                .onChange(of: item.rightSwipe ) { _ in
                    
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
           withAnimation(.easeIn(duration: 0.5)) {
               offset = CGSize(width: -UIScreen.main.bounds.width, height: 0)
               isHidden = true
               
           }
          onSwipeLeft()
       }

       private func swipeRight() {
           withAnimation(.easeIn(duration: 0.5)) {
               offset = CGSize(width: UIScreen.main.bounds.width, height: 0)
               isHidden = true
              
           }
           onSwipeRight()
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
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("\(age) years")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color.white.opacity(0.85))
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
            }
            .padding(8)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .padding(.horizontal, 25)
    }
}



struct BioCardView: View {
    var bio: String = ""
    
    var body: some View {
        
        VStack {
            VStack(alignment: .leading, spacing: 4) { // Reduce spacing
                Text("About Me")
                               .font(.headline)
                               .fontWeight(.bold)
                               .foregroundColor(Color.white.opacity(0.9)) // Modern white tint
                               .padding(.horizontal, 10)
                               .padding(.top, 10)
                               .frame(maxWidth: .infinity, alignment: .leading)
                           
                           Text(bio)
                               .font(.subheadline)
                               .foregroundColor(Color.white.opacity(0.85))
                               .lineLimit(nil)
                               .padding(.horizontal, 10)
                               .padding(.bottom, 10)
            }
            .padding(8) // Reduce padding
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
        }.padding(.horizontal, 25)
    }
    
}

struct TechnologiesCardView: View {
    var technologies: [String] = ["Swift", "UI/UX Design", "Cloud Computing", "SwiftUI", "iOS Development", "React", "Machine Learning", "DevOps", "Xcode", "Firebase"]
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Technologies")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(technologies, id: \.self) { tech in
                        Text(tech.dropFirst())
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 10).padding(.vertical, 10)
            }
            
            .padding(8) // Reduce padding
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }.padding(.horizontal, 25)
    }
}

struct HobbiesCardView: View {
    var hobbies: [String] = []
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Hobbies")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(hobbies, id: \.self) { hobby in
                        Text(hobby.dropFirst())
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 10).padding(.vertical, 10)
            }
            
            .padding(8)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }.padding(.horizontal, 25)
    }
}

struct SmokingCardView: View {
    var smoking: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) { // Reduce spacing
                Text("Smoking")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    
                    Spacer()
                    
                    Text(smoking.isEmpty ? "Not Specified" : smoking)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 15)
                        .background(getGradient(for: smoking)) // Dynamic background
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    
                    Spacer()
                }.padding(.vertical, 10)
            }
            .padding(8) // Reduce padding
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
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
    var drinking: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) { // Reduce spacing
                Text("Drinking")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.9)) // Modern white tint
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Spacer()
               
                Text(drinking.isEmpty ? "Not Specified" : drinking)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(getGradient(for: drinking)) // Dynamic background
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    
                    Spacer()
                }.padding(.vertical, 10)
            }
            .padding(8) // Reduce padding
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
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
    var jobRole: String = ""

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Job Role")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)

                
                HStack {
                    
                    Spacer()
                    
                    Text(jobRole.isEmpty ? "Not Specified" : jobRole)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 15)
                        .background(getGradient(for: jobRole)) // Dynamic gradient based on job level
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    
                    Spacer()
                }
            }
            .padding(8) // Reduce padding
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
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
