


import SwiftUI

struct LikesScreenView: View {
    
    @State var likes : [LikesResponse] = []
    
    @EnvironmentObject private var tokenManger : TokenManager
    @EnvironmentObject private var themeManager : ThemeManager
    
    
    
    func fetchLikes() async throws {
        
        let data:LikesEncodable? = nil;
        
        let urlRequest = try createURLRequest(method : "GET" , baseURL: "\(tokenManger.localhost)/likes/get-likes", accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
        let likesResponse : [LikesResponse] = try await fetchDataArray(from: urlRequest)
        
        likes = likesResponse;
        
        print(likesResponse)
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
         
                        List {
                            
                            if ( likes.isEmpty){
                                
                                HStack {
                                    
                                    Text("No Likes to show")
                                } .listRowBackground(themeManager.currentTheme.backgroundColor)
                                    .listRowSeparatorTint(themeManager.currentTheme.navigationLinkColor)
                            }
                            
                            ForEach(likes) { like in  // Iterate over likes directly
            
                              
                                
                                NavigationLink(destination: OthersProfileView(profile: like.userFrom ?? nil , photoUrl: "\(tokenManger.serverImageURL)")) {
                                    LikeItemView(like: like, photoURL: "\(tokenManger.serverImageURL)")
                                        .onAppear {
                                            if let index = likes.firstIndex(where: { $0.id == like.id }), index == likes.count - 5 {
                                                //                                              loadMoreItems()
                                                print ("load more")
                                            }
            
                                        }
                                } .listRowBackground(themeManager.currentTheme.backgroundColor)
                                    .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                                // Custom
            
            
                            }
            
                        }
                        .scrollContentBackground(.hidden) // Removes default background
                    .background(themeManager.currentTheme.backgroundColor)
                    .listStyle(.insetGrouped)
                   
                    .accentColor(themeManager.currentTheme.primaryColor) // Global fallback
            
           }.frame(maxWidth: .infinity, maxHeight: .infinity) .navigationBarTitle("Likes" , displayMode: .inline) .background(themeManager.currentTheme.backgroundColor)
        }.background(themeManager.currentTheme.backgroundColor) // Forces it to take the full screen
           
        .onAppear(){
            
            updateNavigationBarColor()
           
            Task {
                do {
                    try await fetchLikes()
                }
                catch{
                    
                }
            }
           
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




struct LikeItemView: View {
    let like: LikesResponse
    let photoURL : String;
    
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            
            
            CachedImageView(
                url: URL(string: "\(photoURL)/\("resized-")\(like.userFrom?.photo ?? "")"),
                        width: 50,
                        height: 50,
                      
                        failureView: {
                            VStack {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                
                            }
                        },
                        storeInDisk : true,
                isCircle : true 
                    )
            
//            
//            if let imageName = like.userFrom?.photo , let url = URL(string: "\(photoURL)/\("resized-")\(imageName)")
//            {
//                AsyncImage(url: url) { phase in
//                                   switch phase {
//                                   case .empty:
//                                       ProgressView()
//                                           .frame(width: 50, height: 50)
//                                   case .success(let image):
//                                       image
//                                           .resizable()
//                                           .aspectRatio(contentMode: .fill)
//                                           .frame(width: 50, height: 50)
//                                           .clipShape(Circle())
//                                   case .failure:
//                                       Image(systemName: "person.crop.circle")
//                                           .resizable()
//                                           .aspectRatio(contentMode: .fill)
//                                           .frame(width: 50, height: 50)
//                                           .clipShape(Circle())
//                                           .foregroundColor(themeManager.currentTheme.id == "light" ? .black : .white) // Red color
//
//                                   @unknown default:
//                                       EmptyView()
//                                   }
//                               }
//                        
//                               .padding(.trailing, 8)
//            }
            VStack(alignment: .leading) {
                Text(like.userFrom?.name ?? "Unknown").foregroundColor(themeManager.currentTheme.textColor)
                    .font(.headline)
                if let technologies = like.userFrom?.technologies {
                    Text(technologies.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(themeManager.currentTheme.secondaryColor)
                }
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13)) // Standard system chevron size
                .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
             
                .background(themeManager.currentTheme.backgroundColor)
                .offset(x: 18) // Adjust horizontal position
        }
        .padding(.vertical, 4)
    }
}


struct LikesScreenView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        LikesScreenView().environmentObject(TokenManager()).environmentObject(ThemeManager())
    }
}


