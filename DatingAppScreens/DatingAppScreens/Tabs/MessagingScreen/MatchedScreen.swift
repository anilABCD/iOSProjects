


import SwiftUI

struct MatchedScreenView: View {
    
    @State var matched : [MatchedResponse] = []
    @EnvironmentObject private var tokenManger : TokenManager

    
    func fetchMatched() async throws {
        
        let data:MatchedEncodable? = nil;
        
        let urlRequest = try createURLRequest(method : "GET" , baseURL: "\(tokenManger.localhost)/matches/", accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
        let matchedResponse : [MatchedResponse] = try await fetchDataArray(from: urlRequest)
        
        matched = matchedResponse;
        
        print(matchedResponse)
    }
    
    
    var body: some View {
              NavigationView {
//                   List(likes) { like in
//                       LikeItemView(like: like , photoURL : "\(tokenManger.localhost)/images")
                       
                  List {
                      ForEach(matched) { match in  // Iterate over likes directly
                     
                          // Determine which profile to display
                          let matchProfile = (match.userOne?.id == tokenManger.userId) ? match.userTwo : match.userOne
                          
                          NavigationLink(destination: OthersProfileView(profile: matchProfile ?? nil , photoUrl: "\(tokenManger.localhost)/images")) {
                              MatchedItemView(profile : matchProfile ?? nil, photoURL: "\(tokenManger.localhost)/images")
                                  .onAppear {
                                      if let index = matched.firstIndex(where: { $0.id == match.id }), index == matched.count - 5 {
                                          //                                              loadMoreItems()
                                          print ("load more")
                                      }
                                      
                                  }
                          }
                          
                          
                      }
                      
                  }.navigationTitle("Messages")
//                           .onAppear {
//                               if index == likes.count - 5 {
//                                  loadMoreItems()
//                               }
//                           }
//                   }
                  
               }
        .onAppear(){
            Task {
                do {
                    try await fetchMatched()
                }
                catch{
                    
                }
            }
           
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


