import SwiftUI
import SwiftData

struct MatchesReceivedListView: View {
    @StateObject var viewModel: MatchViewModel

    
    @EnvironmentObject var themeManager : ThemeManager
    @EnvironmentObject var tokenManager : TokenManager
    
    var body: some View {
        NavigationStack {
            
            if !viewModel.isLoadingReceived && viewModel.receivedMatches.isEmpty {
               
                VStack {
                    NoMatchesView()
                }
                
            }
        
            MatchesListView(matches: $viewModel.receivedMatches , hasMore: $viewModel.hasMoreReceived , isLoading: $viewModel.isLoadingReceived)
            
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
              
//                NavigationLink(destination: OthersProfileView(othersProfile: matchedUser , photoUrl: "\(tokenManager.serverImageURL)") ) {
                    
                    ZStack {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                VStack {
//                                    Text("\(matchedUser.photo ?? "")").lineLimit(10)
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
                                }
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
//                }
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
