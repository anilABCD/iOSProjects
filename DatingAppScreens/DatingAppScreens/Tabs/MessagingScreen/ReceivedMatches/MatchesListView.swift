



import SwiftUI

struct MatchesListView: View {
    
    @Binding var matches: [MatchEntity]
    @Binding var hasMore: Bool
    @Binding var isLoading: Bool
    
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tokenManager: TokenManager
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(matches.enumerated()), id: \ .element.id) { index, match in
              
                            VStack {
                                
//                                Text(match.id)
                                NavigationLink(destination: NoLikesView()) {
                                    MatcheItemView(match: match, photoURL: "\(tokenManager.serverImageURL)")
                                }
                                
                                    
                                    .listRowBackground(themeManager.currentTheme.backgroundColor)
                                    .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                                    .id(match.id)
                                    .overlay(GeometryReader { geo in
                                        DispatchQueue.main.async {
                                            print("Dynamic overlay executed for \(match.id)")
                                            
                                            //should be added .
                                            //loadMoreItems()
                                        }
                                        return Color.clear
                                        
                                    })
                                
                            }
                         
                            
//                            if !matches.isEmpty &&  hasMore {
//                                HStack {
//                                    Spacer()
//                                    if  isLoading {
//                                        ProgressView().padding()
//                                    }
//                                    Spacer()
//                                }
//                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .topLeading)
                        .background(themeManager.currentTheme.backgroundColor)
                        .accentColor(themeManager.currentTheme.primaryColor)
                        .padding(.top, 10)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeManager.currentTheme.backgroundColor)
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                
                print("sent requests")
            
                for item in matches.filter({$0.type == "sent"}) {
                    print(item.id)
                }
                
            }

        }
    }
      
}

