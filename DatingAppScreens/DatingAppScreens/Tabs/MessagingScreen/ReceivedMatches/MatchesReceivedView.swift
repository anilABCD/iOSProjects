import SwiftUI
import SwiftData

struct MatchesReceivedListView: View {
    @StateObject var viewModel: MatchViewModel

    
    @EnvironmentObject var themeManager : ThemeManager
    @EnvironmentObject var tokenManager : TokenManager
    
    var body: some View {
        NavigationStack {
            
            if !viewModel.isLoading && viewModel.receivedMatches.isEmpty {
               
                VStack {
                    NoMatchesView()
                }
                
            }
        
            MatchesListView(matches: $viewModel.receivedMatches , hasMore: $viewModel.hasMore , isLoading: $viewModel.isLoading)
                
                
//                VStack {
//                    
//                    
//                    ScrollViewReader { proxy in
//                        
//                        ScrollView {
//                            LazyVStack(alignment: .leading)
//                            {
//                                
//                               
//                                
//                                
////                                ForEach(Array(viewModel.receivedMatches.enumerated()), id: \.element.id) { index, match in
////                                    if index % 2 == 0 { // Group items in pairs
////                                        HStack {
////                                            
////                                            if index == viewModel.receivedMatches.count - 5 {
////                                                
////                                                NavigationLink(destination: NoLikesView() ) {
////                                                    MatcheItemView(match: match, photoURL: "\(tokenManager.serverImageURL)")
////                                                }
////                                                .frame(maxWidth: .infinity)
////                                                .listRowBackground(themeManager.currentTheme.backgroundColor)
////                                                .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
////                                                .id(match.id)
////                                                .overlay(GeometryReader { geo in
////                                                    DispatchQueue.main.async {
////                                                        print("Dynamic overlay executed for \(match.id)")
////
////                                                        //should be added .
////                                                        //loadMoreItems()
////                                                    }
////                                                    return Color.clear
////                                                         
////                                                })
////                                                
////                                            }
////                                            else {
////                                                
////                                                NavigationLink(destination: NoLikesView()) {
////                                                    MatcheItemView(match: match, photoURL: "\(tokenManager.serverImageURL)")
////                                                }
////                                                .frame(maxWidth: .infinity)
////                                                .listRowBackground(themeManager.currentTheme.backgroundColor)
////                                                .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
////                                                .id(match.id)
////                                            }
////                                            
////                                            
////                                            if index + 1 < viewModel.receivedMatches.count {
////                                                
////                                                if ( index + 1 == viewModel.receivedMatches.count - 5 ) {
////                                                    
////                                                    
////                                                    let nextMatch = viewModel.receivedMatches[index + 1]
////                                                    
////                                                    NavigationLink(destination: NoLikesView()) {
////                                                        MatcheItemView(match: nextMatch, photoURL: "\(tokenManager.serverImageURL)")
////                                                    }
////                                                    .frame(maxWidth: .infinity)
////                                                    .listRowBackground(themeManager.currentTheme.backgroundColor)
////                                                    .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
////                                                    .id(nextMatch.id)
////                                                    .overlay(GeometryReader { geo in
////                                                        DispatchQueue.main.async {
////                                                            print("Dynamic overlay executed for \(nextMatch.id)")
////                                                            //should be implemented .
//////                                                            loadMoreItems()
////                                                        }
////                                                        return Color.clear
////                                                        
////                                                    })
////                                                    
////                                                }
////                                                else {
////                                                    let nextMatch = viewModel.receivedMatches[index + 1]
////                                                    NavigationLink(destination: NoLikesView()) {
////                                                        MatcheItemView(match: match, photoURL: "\(tokenManager.serverImageURL)")
////                                                    }
////                                                    .frame(maxWidth: .infinity)
////                                                    .listRowBackground(themeManager.currentTheme.backgroundColor)
////                                                    .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
////                                                    .id(nextMatch.id)
////                                                }
////                                            }
////                                            else {
////                                                Spacer().frame(maxWidth: .infinity)
////                                            }
////                                        }
////                                        .frame(maxWidth: .infinity)
////                                        
////                                    }
////                                }
//                                
//                                if viewModel.receivedMatches.count > 8 {
//                                    Color.clear.frame(height: 100)
//                                }
//                                
//                                
//                                if !viewModel.receivedMatches.isEmpty && viewModel.hasMore {
//                                    
//                                    HStack {
//                                        Spacer()
//                                        
//                                        if viewModel.isLoading {
//                                            ProgressView()
//                                                .padding()
//                                            
//                                            
//                                        }
//                                        Spacer()
//                                    }
//                                    
//                                }
//                                
//                            } .frame(maxHeight: .infinity , alignment: .topLeading)
//                                .background(themeManager.currentTheme.backgroundColor)
//                                .background(GeometryReader { geo in
//                                    Color.clear
//                                        
//                                })
//                                
//                            //                        .listStyle(PlainListStyle())
//                                .accentColor(themeManager.currentTheme.primaryColor)
//                                .padding(.top, 10)
//                        }
//                       
//                        
//                    }
//                }
                
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//               
//                .background(themeManager.currentTheme.backgroundColor)
            
        }
    }
}



struct MatcheItemView: View {
    let match: MatchEntity
    let photoURL : String;
    
    
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tokenManager : TokenManager
    
    var body: some View {
        ZStack {
            
            if let matchedUser = match.getOtherParticipant(currentUserID: tokenManager.userId) {
              
                
                VStack(alignment: .leading) {
                   
                    HStack {
                        
                        CachedImageView(
                            url: URL(string: "\(photoURL)/\(matchedUser.photo ?? "")"),
                            width: 180,
                            height: 240,
                            
                            failureView: {
                                VStack {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(themeManager.currentTheme.id == "light" ? Color.blue : Color.white )
                                    
                                        .frame(width: 180, height: 240)
                                        .background(.black)
                                        .cornerRadius( 20)
                                    
                                    
                                    
                                } .frame(width: 180, height: 240)
                            },
                            storeInDisk : true
                            
                        )
                    }.frame(height: 240)
                    
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
                }.frame(maxWidth: .infinity, alignment: .topLeading) // Ensure it stays top-leading
                
                VStack(alignment: .leading) {
                    Spacer() // Pushes content to the bottom
                    
                    
                    HStack {
                        
                        
                        Text("Age : \( Utils.UDate.getAge(dob:  matchedUser.dob ))") .font(themeManager.currentTheme.headlinefont).fontWeight(.bold).foregroundColor(.white)
                        
                        Spacer()
                        //                    Text(like.userFrom?.name ?? "Unknown").foregroundColor(.black)
                        //                        .font(themeManager.currentTheme.subHeadLinefont).fontWeight(.bold)
                        //                    if let technologies = like.userFrom?.technologies {
                        //                        Text(technologies.joined(separator: ", "))
                        //                            .font(themeManager.currentTheme.subHeadLinefont)
                        //                            .foregroundColor(.black).fontWeight(.bold)
                        //                    }
                    }.padding(.horizontal , 30)
                    //                .background(.white.opacity(0.3))
                }.frame(height: 240)
                .frame(maxWidth: .infinity, alignment: .topLeading) // Ensure it stays top-leading
            }
           
//            Image(systemName: "chevron.right")
//                .font(.system(size: 13)) // Standard system chevron size
//                .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
//
//                .background(themeManager.currentTheme.backgroundColor)
//                .offset(x: 18) // Adjust horizontal position
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // Ensure ZStack fully respects top-leading
            .padding(.horizontal,20)
           
       
    }
}



struct MatchRowView: View {
    let match: MatchEntity

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Match ID: \(match.id)")
                    .font(.headline)

                Text("Status: \(match.status)")
                    .foregroundColor(.gray)

                if let matchedUser = match.getOtherParticipant(currentUserID: "currentUserID") {
                    Text("Matched with: \(matchedUser.name)")
                        .foregroundColor(.blue)
                }
            }
            Spacer()
            Text("\(match.updatedAt, style: .date)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
