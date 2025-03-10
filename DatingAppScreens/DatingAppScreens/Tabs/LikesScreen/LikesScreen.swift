import SwiftUI


struct LoadMoreItem: Identifiable {
    let id: String
}

struct LoadMoreView: View {
    let id: String // ✅ Unique identifier each time
    var body: some View {
        HStack {
            Spacer()
            Text("Loading... \(id)")
            ProgressView()
                .padding()
            Spacer()
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .id(id) // ✅ Forces SwiftUI to create a fresh instance
    }
}


struct LikesScreenView: View {
    
    @State var likes : [LikesResponse] = []
    
    @EnvironmentObject private var tokenManger : TokenManager
    @EnvironmentObject private var themeManager : ThemeManager
    
    @State private var loadMore: [LoadMoreItem] = [LoadMoreItem(id: "0")]

   
    @State var skip : Int = 0
    @State private var isLoading = false
    @State private var hasMoreData = true
    
    @State  var lastItemID: String? = nil // Track last item's ID
    @State private var scrollOffset: CGFloat = 0

    @State var visibleItemID : String? = nil
    
    func loadMoreItems() {
        guard !isLoading && hasMoreData else { 
            print("Skip loading: isLoading = \(isLoading), hasMoreData = \(hasMoreData)")
            return 
        }
        
        print("Loading more items, current skip: \(skip)")
        
        Task {
            do {
                await try self.fetchLikes()
            } catch {
                isLoading = false
                print("Error loading more likes:", error)
            }
        }
       
        print("New skip value: \(skip)")
    }
    
    func fetchLikes() async throws {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        
        let data:LikesEncodable? = nil;
        
        let urlRequest = try createURLRequest(method : "GET" , baseURL: "\(tokenManger.localhost)/likes/get-likes?skip=\(skip)", accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
        let likesResponse : [LikesResponse] = try await fetchDataArray(from: urlRequest)
        
        DispatchQueue.main.async {
            if likesResponse.isEmpty {
                hasMoreData = false
            } else {
                likes = likes + likesResponse
                
                skip = skip + 10 ;
            
                loadMore = [LoadMoreItem(id: skip.description)]
                
            }
            isLoading = false
        }
        
        print(likesResponse)
    }
    
    
    func setLastId(){
        lastItemID = likes.last?.id
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    List {
                        if (likes.isEmpty) {
                            HStack {
                                Text("No Likes to show")
                            }
                            .listRowBackground(themeManager.currentTheme.backgroundColor)
                            .listRowSeparatorTint(themeManager.currentTheme.navigationLinkColor)
                        }
                        
                        ForEach(Array(likes.enumerated()), id: \.element.id) { index, like in
                            
                            
                            if ( index == likes.count - 5 ){
                                NavigationLink(destination: OthersProfileView(profile: like.userFrom ?? nil, photoUrl: "\(tokenManger.serverImageURL)")) {
                                    LikeItemView(like: like, photoURL: "\(tokenManger.serverImageURL)")
                                }
                                .listRowBackground(themeManager.currentTheme.backgroundColor)
                                .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                                .id(like.id) // Add id for scroll tracking
                                .overlay(GeometryReader { geo in  // ✅ Use overlay instead of background
                                    
                                    DispatchQueue.main.async {
                                                   print("Dynamic overlay executed for \(like.id)")
                                                   
                                        loadMoreItems()
                                            
                                     }
                                    
                                    return Color.clear
                                        .preference(key: VisibleItemKey.self, value: like.id)
                                })
                            }
                            else {
                                NavigationLink(destination: OthersProfileView(profile: like.userFrom ?? nil, photoUrl: "\(tokenManger.serverImageURL)")) {
                                    LikeItemView(like: like, photoURL: "\(tokenManger.serverImageURL)")
                                }
                                .listRowBackground(themeManager.currentTheme.backgroundColor)
                                .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                                .id(like.id) // Add id for scroll tracking
                               
                            }
                        }

//                        
//                        ForEach(loadMore) { item in
//                            LoadMoreView(id :item.id)
//                            .id(item.id)
//                            .overlay(GeometryReader { geo in
//                                
//                                DispatchQueue.main.async {
//                                               print("Dynamic overlay executed for \(item.id)")
//                                               
//                                    loadMoreItems()
//                                        
//                                           }
//                                
//                                return Color.clear
//                                    .preference(key: VisibleItemKey.self, value: item.id) // ✅ Tracks visibility
//                            })
//                        }
//                        
//                        if !likes.isEmpty && hasMoreData {
//     
//                            HStack {
//                                Spacer()
//                                Text("Loading\(skip)")
//                                
//                                if isLoading {
//                                    ProgressView()
//                                        .padding()
//                                    
//                                   
//                                }
//                                Spacer()
//                            }
//                            .id("loadMore-\(skip)")// ✅ Forces SwiftUI to recreate when `skip` changes
//                            .listRowBackground(themeManager.currentTheme.backgroundColor)
//                            .listRowSeparator(.hidden)
//                            .overlay(GeometryReader { geo in  // ✅ Use overlay instead of background
//                                Color.clear
//                                    .preference(key: VisibleItemKey.self, value: "loadMore-\(skip)")
//                            })
//                        }
                        
                        if ( likes.count > 8 ) {
                            Color.clear.frame(height:100)
                        }
                        
                    }
                    .scrollContentBackground(.hidden)
                    .background(themeManager.currentTheme.backgroundColor)
                    .background(GeometryReader { geo in
                                    Color.clear
                                        .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .global).minY)
                                })
                    .onPreferenceChange(ScrollOffsetKey.self) { newOffset in
                               scrollOffset = -newOffset
                               
                        print("scroll changed")
                           }
//                    .background(GeometryReader { geo -> Color in
//                        
//                             
//                        print("backgroundchanged")
//                                    DispatchQueue.main.async {
//                                        let contentHeight = geo.size.height
//                                        let scrollOffset = geo.frame(in: .global).maxY
//                                        let screenHeight = UIScreen.main.bounds.height
//                                        print("for loading data entered")
//                                        if scrollOffset < screenHeight + 50 && !likes.isEmpty && hasMoreData  { // Load when near bottom
//                                            
//                                            print("has more data ")
//                                            
//                                            if let lastItemID = lastItemID {
//                                                if let id = likes.last?.id {
//                                                    
//                                                    if ( lastItemID != id){
//                                                        
//                                                        print("loadmore data called")
//                                                        
//                                                        loadMoreItems()
//                                                        self.setLastId()
//                                                    }
//                                                    
//                                                }
//                                            }
//                                            else {
//                                                loadMoreItems()
//                                                self.setLastId()
//                                            }
//                                            
//                                         
//                                        }
//                                        print("for loading data exited")
//                                    }
//                                    return Color.clear
//                                })
                    .listStyle(PlainListStyle())
                    .accentColor(themeManager.currentTheme.primaryColor)
                 
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("Likes", displayMode: .inline)
            .background(themeManager.currentTheme.backgroundColor)
             
        }
        .background(themeManager.currentTheme.backgroundColor)
        .onPreferenceChange(ScrollOffsetKey.self) { newOffset in
            
            print("New offset:\(newOffset)")
            
                    scrollOffset = newOffset
                    
                }
        .onPreferenceChange(VisibleItemKey.self) { newID in
            visibleItemID = newID
            print("visual item id \(visibleItemID)")
            checkForLoadMore()
           
                  
             }
        .onAppear {
            updateNavigationBarColor()
            Task {
                do {
                    try await fetchLikes()
                } catch {
                    print("Error loading initial likes:", error)
                }
            }
        }
    }
    
    private func checkForLoadMore() {
        
        
        
            if visibleItemID == "loadMore-\(skip)", hasMoreData, lastItemID != likes.last?.id {
               
                loadMoreItems()
                lastItemID = likes.last?.id
            }
        }
    
    // ✅ PreferenceKey to track scroll offset
    struct ScrollOffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
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


// ✅ PreferenceKey to Track Visible Items
struct VisibleItemKey: PreferenceKey {
    static var defaultValue: String? = nil
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
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
                                    .foregroundColor(themeManager.currentTheme.id == "light" ? Color.black : Color.white )
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


