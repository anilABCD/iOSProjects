


import SwiftUI


struct Item: Identifiable {
    var id = UUID()
    var name: String
    var description: String
}


struct MatchedScreenView: View {
    
    @State var matched : [MatchedResponse] = []
    @EnvironmentObject private var tokenManger : TokenManager
    
    @State private var webSocketManager = WebSocketManager(token: "" , userId: "")
    
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
        
        let urlRequest = try createURLRequest(method : "GET" , baseURL: "\(tokenManger.localhost)/matches/", accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
        let matchedResponse : [MatchedResponse] = try await fetchDataArray(from: urlRequest)
        
        matched = matchedResponse;
        
        print(matchedResponse)
    }
    
    func fetchMatchedOnline() async throws {
        
        let data:MatchedEncodable? = nil;
        
        let urlRequest = try createURLRequest(method : "GET" , baseURL: "\(tokenManger.localhost)/matches/search-matched-users", accessToken: tokenManger.accessToken , data: data, parameters: ["isOnlineQuery" : "true"] )
        
        let matchedResponse : [MatchedResponse] = try await fetchDataArray(from: urlRequest)
        
        matched = matchedResponse;
        
        print(matchedResponse)
    }
    
    
    var body: some View {
              NavigationView {
                  
           
                  
                  VStack {
                 
                      HStack{
                          Text("Messages").bold().font(.largeTitle)
                          Spacer()
                      }.padding(.horizontal).frame(height: 45)
                      
                  
                      ScrollView(.horizontal, showsIndicators: false) {
                      
                          HStack {
                          
                              ForEach(items) { item in
                             
                              
                                  VStack {
                                  
                                      Image("splashscreenlogo")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2)) // Optional: Adding a border
                                            .overlay(
                                                           Circle()
                                                               .fill(Color.green)
                                                               .frame(width: 14, height: 14)
                                                               .overlay(
                                                                   Circle().stroke(Color.white, lineWidth: 2) // Adding circular border
                                                               )
                                                               .offset(x: -1, y: -1), // Adjusting position to be near the circle
                                                           alignment: .bottomTrailing
                                                       )
                                  
                                  
                                      Text(item.name)
                                      .font(.headline)
                              }.frame(maxWidth:.infinity).padding(.horizontal, 10)
                              
                          }
                      }
                  }.frame(maxWidth:.infinity ) .padding(.horizontal)
//                   List(likes) { like in
//                       LikeItemView(like: like , photoURL : "\(tokenManger.localhost)/images")
                       
                      List {
                          ForEach(matched) { match in  // Iterate over likes directly
                              
                              // Determine which profile to display
                              let matchProfile = (match.userOne?.id == tokenManger.userId) ? match.userTwo : match.userOne
                              
                              NavigationLink(destination: ChatView(profile: matchProfile ?? nil , photoUrl: "\(tokenManger.localhost)/images", webSocketManager: webSocketManager) ) {
                                  MatchedItemView(profile : matchProfile ?? nil, photoURL: "\(tokenManger.localhost)/images")
                                      .onAppear {
                                          if let index = matched.firstIndex(where: { $0.id == match.id }), index == matched.count - 5 {
                                              //                                              loadMoreItems()
                                              print ("load more")
                                          }
                                          
                                      }
                              }
                              
                              
                          }
                      }
                      
                  }.navigationTitle("")
                   .navigationBarHidden(true) // Hides the navigation bar
                  
                  
//                           .onAppear {
//                               if index == likes.count - 5 {
//                                  loadMoreItems()
//                               }
//                           }
//                   }
                  
               }
             
           
       .onAppear()
        {
                Task {
                   do {
                    try await fetchMatched()
                    
                    webSocketManager.token = tokenManger.accessToken;
                    webSocketManager.connect()
                    
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
}




struct MatchedItemView: View {
    let profile: Profile?
    let photoURL : String;
    
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
                                       Image(systemName: "person.crop.circle.badge.exclamationmark")
                                           .resizable()
                                           .aspectRatio(contentMode: .fill)
                                           .frame(width: 50, height: 50)
                                           .clipShape(Circle())
                                   @unknown default:
                                       EmptyView()
                                   }
                               }
                               .padding(.trailing, 8)
            }
            VStack(alignment: .leading) {
                Text(profile?.name ?? "Unknown")
                    .font(.headline)
                if let technologies = profile?.technologies {
                    Text(technologies.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}


struct MatchedScreenView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        MatchedScreenView().environmentObject(TokenManager())
    }
}



