


import SwiftUI


struct Item: Identifiable {
    var id = UUID()
    var name: String
    var description: String
}


struct MatchedProfilesForMessagingListScreenView: View {
    
    @State var matched : [Chat] = []
    @EnvironmentObject private var tokenManger : TokenManager
    @EnvironmentObject private var themeManager : ThemeManager
    
    @Binding var hideTabBar : Bool ;
    @StateObject  var webSocketManager = WebSocketManager(token: "" , otherUserId: "")
    
    @State private var searchText = ""
    @State private var selectedMatch: Chat?
    

    var items = [
        Item(name: "Item 1", description: "Description for Item 1"),
        Item(name: "Item 2", description: "Description for Item 2"),
        Item(name: "Item 3", description: "Description for Item 3"),
        Item(name: "Item 4", description: "Description for Item 4"),
        // Add more items to make it scrollable
        Item(name: "Item 5", description: "Description for Item 5"),
        Item(name: "Item 6", description: "Description for Item 6")
    ]
    
    func fetchMatched() async throws {
        
        let data:MatchedEncodable? = nil;
        
        print("Fetching Matches")
        
        let urlRequest = try createURLRequest(method : "GET" , baseURL: "\(tokenManger.localhost)/matches/fromMessages", accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
        do {
            
            
            let matchedResponse : [Chat] = try await fetchDataArray(from: urlRequest)
            
//            // Update the `id` for each match and modify the lastMessage text, keeping previous message content intact
//            let updatedMatches = matchedResponse.map { match -> Chat in
//                var updatedMatch = match
//                // Keep the previous message text and append new text
//                if var lastMessage = updatedMatch.lastMessage {
//                    lastMessage.text = "\(lastMessage.text ?? "") Updated Text" // Appending "Updated Text" to the previous text
//                    updatedMatch.lastMessage = lastMessage
//                }
//                
//                // Modify the `id` (appending a new suffix or generating a new unique ID)
//                updatedMatch.id = "\(match.id)-updated-\(UUID())" // Example: appending "-updated" and a UUID
//                
//                return updatedMatch
//            }
            
            
            func updateMatches() {
                for index in self.matched.indices {
                    var updatedMatch = self.matched[index]  // Create a mutable copy
                    
                    // Update the last message without modifying the match's ID
                    if var lastMessage = updatedMatch.lastMessage {
                        lastMessage.text = "\(lastMessage.text ?? "") Updated Text"  // Appending new text
                        updatedMatch.lastMessage = lastMessage
                    }
                    
                    // Assign the updated match back to the array
                    self.matched[index] = updatedMatch  // This updates the struct in the array
                }
            }
            
            DispatchQueue.main.async {
                
                self.matched = matchedResponse;
                
              
//                updateMatches() ;
                
                print("matches current" ,    self.matched )
                
            }
            
           
            
        }catch{
            // If decoding fails, print the error message
                print("Decoding failed with error: \(error)")
        }
        
       
    }
    
//    func fetchMatchedOnline() async throws {
//        
//        let data:MatchedEncodable? = nil;
//        
//        let urlRequest = try createURLRequest(method : "GET" , baseURL: "\(tokenManger.localhost)/matches/search-matched-users", accessToken: tokenManger.accessToken , data: data, parameters: ["isOnlineQuery" : "true"] )
//        
//        let matchedResponse : [Chat] = try await fetchDataArray(from: urlRequest)
//        
//        matched = matchedResponse;
//        
//        print(matchedResponse)
//    }
//    
//    
    var body: some View {
        NavigationStack {
                  
           
                  
                  VStack( spacing: 0) {
//                 
//                      HStack{
//                          Text("Messages").bold().font(.largeTitle)
//                          Spacer()
//                      }.padding(.horizontal).frame(height: 45)
                      
                      
                      
                      
                      
                                                HStack {
                                                            TextField("Search User...", text: $searchText)
                                                                .padding(10)
                                                                .padding(.leading, 35) // Space for icon
                                                                .background(Color(.systemGray6))
                                                                .cornerRadius(20)
                                                                .overlay(
                                                                    HStack {
                                                                        Image(systemName: "magnifyingglass")
                                                                            .foregroundColor(themeManager.currentTheme.secondaryColor)
                                                                            .padding(.leading, 10)
                                                                        Spacer()
                                                                        if !searchText.isEmpty {
                                                                            Button(action: { searchText = "" }) {
                                                                                Image(systemName: "xmark.circle.fill")
                                                                                    .foregroundColor(themeManager.currentTheme.secondaryColor)
                                                                            }
                                                                            .padding(.trailing, 10)
                                                                        }
                                                                    }
                                                                )
                      
                          //                                  Button(action: {
                          ////                                      performSearch()
                          //                                  }) {
                          //                                      Image(systemName: "arrow.right.circle.fill")
                          //                                          .resizable()
                          //                                          .frame(width: 30, height: 30)
                          //                                          .foregroundColor(.blue)
                          //                                  }
                          //                                  .padding(.leading, 5)
                          //                                  .shadow(radius: 3)
                                                        }
                                                .padding()
                                                .background( themeManager.currentTheme.backgroundColor)
                      
                      
                      
                      
//
                      
//                      VStack {
//                          
//                          
//                          
//                          HStack {
//                                      TextField("Search User...", text: $searchText)
//                                          .padding(10)
//                                          .padding(.leading, 35) // Space for icon
//                                          .background(Color(.systemGray6))
//                                          .cornerRadius(20)
//                                          .overlay(
//                                              HStack {
//                                                  Image(systemName: "magnifyingglass")
//                                                      .foregroundColor(themeManager.currentTheme.secondaryColor)
//                                                      .padding(.leading, 10)
//                                                  Spacer()
//                                                  if !searchText.isEmpty {
//                                                      Button(action: { searchText = "" }) {
//                                                          Image(systemName: "xmark.circle.fill")
//                                                              .foregroundColor(themeManager.currentTheme.secondaryColor)
//                                                      }
//                                                      .padding(.trailing, 10)
//                                                  }
//                                              }
//                                          )
//                                      
//    //                                  Button(action: {
//    ////                                      performSearch()
//    //                                  }) {
//    //                                      Image(systemName: "arrow.right.circle.fill")
//    //                                          .resizable()
//    //                                          .frame(width: 30, height: 30)
//    //                                          .foregroundColor(.blue)
//    //                                  }
//    //                                  .padding(.leading, 5)
//    //                                  .shadow(radius: 3)
//                                  }
//                          .padding()
//                          .background( themeManager.currentTheme.backgroundColor)
//                          
//                          
//                          ScrollView(.horizontal, showsIndicators: false) {
//                              
//                              HStack(alignment: .top, spacing: 4) { // Add spacing between items if needed
//                                  
//                                  
//                                  
//                                  if self.matched.count == 0 {
//                                      Text("No Online Members").modifier(ThemedTextModifier())
//                                  }
//                                  
//                                  ForEach(self.matched, id: \.id) { match in
//                                      
//                                      
//                                      
//                                      // Determine which profile to display
//                                      let onlineProfile = match.participants.first
//                                      
//                                      let photoUrl = URL(string: "\(tokenManger.serverImageURL)/\("resized-")\(onlineProfile?.photo ?? "" )" )
//                                      
//                                      
//                                      if (( onlineProfile?.isOnline ) != nil &&
//                                          
//                                          onlineProfile?.isOnline == true
//                                      ) {
//                                          
//                                          
//                                          NavigationLink(destination: ChatView(profile: onlineProfile ?? nil , photoUrl: "\(tokenManger.serverImageURL)/" , onBackAction: {
//                                              Task {
//                                                  do {
//                                                      try await fetchMatched()
//                                                  }catch{
//                                                      
//                                                  }
//                                              }
//                                          }, hideTabBar : $hideTabBar, webSocketManager: webSocketManager) .navigationBarBackButtonHidden(true) ,// Hides the back button in ChatView
//                                                         
//                                                         tag: match,
//                                                         selection: $selectedMatch
//                                          ) {
//                                              
//                                              VStack {
//                                                  
//                                                  AsyncImage(url: photoUrl) { phase in
//                                                      switch phase {
//                                                      case .empty:
//                                                          ProgressView()
//                                                              .frame(width: 50, height: 50)
//                                                      case .success(let image):
//                                                          image
//                                                              .resizable()
//                                                              .aspectRatio(contentMode: .fill)
//                                                              .frame(width: 50, height: 50)
//                                                              .clipShape(Circle())
//                                                      case .failure:
//                                                          Image(systemName: "person.crop.circle")
//                                                              .resizable()
//                                                              .aspectRatio(contentMode: .fill)
//                                                              .frame(width: 50, height: 50)
//                                                              .clipShape(Circle())
//                                                      @unknown default:
//                                                          EmptyView()
//                                                      }
//                                                  }
//                                                  .padding(.trailing, 8)
//                                                  .overlay(
//                                                    Circle()
//                                                        .fill(Color.green)
//                                                        .frame(width: 14, height: 14)
//                                                        .overlay(
//                                                            Circle().stroke(Color.white, lineWidth: 2) // Adding circular border
//                                                        )
//                                                        .offset(x: -1, y: -1), // Adjusting position to be near the circle
//                                                    alignment: .bottomTrailing
//                                                  )
//                                                  
//                                                  
//                                                  Text(onlineProfile?.name?.prefix(10) ?? "" )
//                                                      .font(.headline).foregroundColor(themeManager.currentTheme.textColor)
//                                              }.frame(maxWidth:.infinity)
//                                              
//                                          }
//                                          
//                                          
//                                      }
//                                      
//                                  }
//                              }.padding(.top , 10)
//                                  .background( themeManager.currentTheme.backgroundColor)
//                              
//                          } .background( themeManager.currentTheme.backgroundColor)
//                          
//                          
//                          
//                              Divider()// Full-width divider
//                              .frame(height: 1) // Adds a blue border with a width of 2 // Adjust height as needed
//                                  
//                          
//                          
//                      }.frame(maxWidth:.infinity ) .padding(.horizontal)// Adds a blue border with a width of 2
//                          .background( themeManager.currentTheme.backgroundColor)
//                      
                     
                         
//                   List(likes) { like in
//                       LikeItemView(like: like , photoURL : "\(tokenManger.localhost)/images")
                       
                      List {
                          
                          
                          if self.matched.count == 0 {
                              Text("No Online Members").modifier(ThemedTextModifier()) .listRowBackground(themeManager.currentTheme.backgroundColor)
                          }
                          
                          ForEach(matched) { match in  // Iterate over likes directly
                              
                              // Determine which profile to display
                              let matchProfile = match.participants.first
                              
                              NavigationLink(destination: ChatView( chatId: match.id , profile: matchProfile ?? nil , photoUrl: "\(tokenManger.serverImageURL)/", onBackAction: {
                                  Task {
                                      do {
                                          try await fetchMatched()
                                      }catch{
                                          
                                      }
                                  }
                              }, hideTabBar: $hideTabBar, webSocketManager: webSocketManager)  // Hides the back button in ChatView
                              
                              ) {
                                  MatchedItemView(profile : matchProfile ?? nil , photoURL: "\(tokenManger.serverImageURL)/", lastMessage : match.lastMessage , unreadCounts: match.unreadCounts , userId: tokenManger.userId )
                                      .onAppear {
                                          if let index = matched.firstIndex(where: { $0.id == match.id }), index == matched.count - 5 {
                                              //                                              loadMoreItems()
                                              print ("load more")
                                          }
                                          
                                      }
                              }
                              .listRowBackground(themeManager.currentTheme.backgroundColor)
                              
                              //Custom
                              
//                              Text("\(match.unreadCounts)")
                          }
                      }
                      .scrollContentBackground(.hidden)
                      .background(themeManager.currentTheme.backgroundColor)
                      .listStyle(PlainListStyle())
      //                .edgesIgnoringSafeArea(.all)
                      .accentColor(themeManager.currentTheme.primaryColor) // Global fallback
                      
                  } .navigationBarTitle("Messages" , displayMode: .inline)
                  
                  
//                           .onAppear {
//                               if index == likes.count - 5 {
//                                  loadMoreItems()
//                               }
//                           }
//                   }
                  
        }.onChange(of: webSocketManager.refreshChatList ) { _, value in
            
            Task {
                do {
                    try await fetchMatched()
                }
                catch{
                   
                }
            }
            
        }.onChange(of: webSocketManager.newMessage ) { _, value in
            
            tokenManger.shouldRefecthUnreadCount = UUID();
            
        }.onAppear()
        {
            updateNavigationBarColor();
            
                Task {
                   do {
                    try await fetchMatched()
                       
//                     tokenManger.shouldRefecthUnreadCount = UUID();
//                    
//                    webSocketManager.token = tokenManger.accessToken;
//                       
//                    webSocketManager.userId = tokenManger.userId;
//                       
//                       DispatchQueue.main.async {
//                           webSocketManager.connect()
//                       }
                    
                 }
                 catch{
                    
                 }
             }
           
        }
        .onDisappear {
            
            print("On Dissepear")
            
            self.webSocketManager.disconnect()
        }
    }
    
    
    func updateNavigationBarColor() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
           
        appearance.backgroundColor = UIColor(themeManager.currentTheme.cardBackgroundColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor( themeManager.currentTheme.id == "light" ? .black : themeManager.currentTheme.primaryColor)] // Title color
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
}




struct MatchedItemView: View {
    let profile: Profile?
    let photoURL : String;
    let lastMessage : LastMessage?
    let unreadCounts : [String:Int]?
    let userId : String
    
    @EnvironmentObject var themeManager: ThemeManager
    
    // Function to format the time from a timestamp
        func formatTime(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a" // 12-hour format with AM/PM
            return formatter.string(from: date)
        }
    
    var body: some View {
        HStack {
            if let imageName = profile?.photo , let url = URL(string: "\(photoURL)/\("resized-")\(imageName)")
            {
                AsyncImage(url: url) { phase in
                                   switch phase {
                                   case .empty:
                                       ProgressView()
                                           .frame(width: 50, height: 50)
                                   case .success(let image):
                                       image
                                           .resizable()
                                           .aspectRatio(contentMode: .fill)
                                           .frame(width: 50, height: 50)
                                           .clipShape(Circle())
                                   case .failure:
                                       Image(systemName: "person.crop.circle")
                                           .resizable()
                                           .aspectRatio(contentMode: .fill)
                                           .frame(width: 50, height: 50)
                                           .clipShape(Circle())
                                           .foregroundColor(themeManager.currentTheme.id == "light" ? .black : .white) // Red color

                                   @unknown default:
                                       EmptyView()
                                   }
                               }
                               .padding(.trailing, 8)
            }
            VStack(alignment: .leading) {
                
                HStack {
                    Text(profile?.name ?? "Unknown")
                        .font(.headline).foregroundColor(themeManager.currentTheme.textColor)
//                    if let technologies = profile?.technologies {
//                        Text(" ( \(technologies.joined(separator: ", ")) )")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
                    
                    Spacer()
                    
//                    Text("unread count number \(unreadCounts?[ userId] ?? 0 )")
//                        .font(.caption2) // Small font size for badge
//                        .foregroundColor(.white) // White text color
//                        .padding(6) // Small padding for a compact circle
//                        .background(Circle().fill(Color.blue)) // Blue circle background
//                        .frame(minWidth: 20, minHeight: 20) // Ensure consistent circular shape
//                        .offset(y: 5)

                    
                    if let unreadCount = unreadCounts?[ userId ] , unreadCount > 0 {
                        Text("\(unreadCount)")
                            
                            .font(.caption2) // Small font size for badge
                            .foregroundColor(themeManager.currentTheme.textColor)
                            .padding(6) // Small padding for a compact circle
                            .background(Circle().fill(Color.blue)) // Blue circle background
                            .frame(minWidth: 20, minHeight: 20) // Ensure consistent circular shape
                            .offset(y: 5)
                    }
                    
//                    Text(unreadCounts?[profile?.id ?? ""] ?? 0 > 0 ? "\(unreadCounts?[profile?.id ?? ""]!)" : "")
                }
                
                if let text = lastMessage?.text , let timestamp = lastMessage?.timestamp {
                    HStack {
                        Text(text)
                            .font(.subheadline)
                            .foregroundColor(themeManager.currentTheme.secondaryColor)
                        
                        Spacer()
                        
                        
                        
                        Text(timestamp, style: .time)
                            .font(.caption2)
                            .foregroundColor(.gray)
                        
                        
                    }
                }
                
                if let imageUrl = lastMessage?.image , let timestamp = lastMessage?.timestamp {
                    HStack {
                        Image( systemName: "camera.fill").font(.subheadline)
                            .foregroundColor(themeManager.currentTheme.id == "light" ? .black : .white) // Red color
                        Spacer()
                        
                        
                        
                        Text(timestamp, style: .time)
                            .font(.caption2)
                            .foregroundColor(themeManager.currentTheme.secondaryColor)
                        
                        
                    }
                }
                
            }
        }
        
    }
}


struct MatchedScreenView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
    @State static var hideTabBar :Bool = false;
    static var previews: some View {
        MatchedProfilesForMessagingListScreenView( hideTabBar : $hideTabBar).environmentObject(TokenManager())
    }
}



