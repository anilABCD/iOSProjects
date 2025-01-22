


import SwiftUI

struct LikesScreenView: View {
    
    @State var likes : [LikesResponse] = []
    @EnvironmentObject private var tokenManger : TokenManager
    
    
    
    func fetchLikes() async throws {
        
        let data:LikesEncodable? = nil;
        
        let urlRequest = try createURLRequest(method : "GET" , baseURL: "\(tokenManger.localhost)/likes/get-likes", accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
        let likesResponse : [LikesResponse] = try await fetchDataArray(from: urlRequest)
        
        likes = likesResponse;
        
        print(likesResponse)
    }
    
    
    var body: some View {
        NavigationStack {
//                   List(likes) { like in
//                       LikeItemView(like: like , photoURL : "\(tokenManger.localhost)/images")
                       
            List {
                ForEach(likes) { like in  // Iterate over likes directly
                    
                    NavigationLink(destination: OthersProfileView(profile: like.userFrom ?? nil , photoUrl: "\(tokenManger.localhost)/images")) {
                        LikeItemView(like: like, photoURL: "\(tokenManger.localhost)/images")
                            .onAppear {
                                if let index = likes.firstIndex(where: { $0.id == like.id }), index == likes.count - 5 {
                                    //                                              loadMoreItems()
                                    print ("load more")
                                }
                                
                            }
                    }
                    
                    
                }
                
            }.listStyle(PlainListStyle()).navigationBarTitle("Likes" , displayMode: .inline)  // Ensure title is within NavigationStack
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
                    try await fetchLikes()
                }
                catch{
                    
                }
            }
           
        }
    }
}




struct LikeItemView: View {
    let like: LikesResponse
    let photoURL : String;
    
    var body: some View {
        HStack {
            if let imageName = like.userFrom?.photo , let url = URL(string: "\(photoURL)/\("resized-")\(imageName)")
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
                Text(like.userFrom?.name ?? "Unknown")
                    .font(.headline)
                if let technologies = like.userFrom?.technologies {
                    Text(technologies.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}


struct LikesScreenView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        LikesScreenView().environmentObject(TokenManager())
    }
}


