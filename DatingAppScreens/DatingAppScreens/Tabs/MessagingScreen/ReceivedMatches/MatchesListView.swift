import SwiftUI

struct MatchesListView: View {
    
    @Binding var matches: [MatchEntity]
    @Binding var hasMore: Bool
    @Binding var isLoading: Bool
    
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tokenManager: TokenManager
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(Array(matches.enumerated()), id: \ .element.id) { index, match in
                            if index % 2 == 0 { // Group items in pairs
                                HStack {
                                    
                                    if index == matches.count - 5 {
                                        
                                        NavigationLink(destination: NoLikesView() ) {
                                            MatcheItemView(match: match, photoURL: "\(tokenManager.serverImageURL)")
                                        }
                                        .frame(maxWidth: .infinity)
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
                                    else {
                                        
                                        NavigationLink(destination: NoLikesView()) {
                                            MatcheItemView(match: match, photoURL: "\(tokenManager.serverImageURL)")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .listRowBackground(themeManager.currentTheme.backgroundColor)
                                        .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                                        .id(match.id)
                                    }
                                    
                                    
                                    if index + 1 < matches.count {
                                        
                                        if ( index + 1 == matches.count - 5 ) {
                                            
                                            
                                            let nextMatch = matches[index + 1]
                                            
                                            NavigationLink(destination: NoLikesView()) {
                                                MatcheItemView(match: nextMatch, photoURL: "\(tokenManager.serverImageURL)")
                                            }
                                            .frame(maxWidth: .infinity)
                                            .listRowBackground(themeManager.currentTheme.backgroundColor)
                                            .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                                            .id(nextMatch.id)
                                            .overlay(GeometryReader { geo in
                                                DispatchQueue.main.async {
                                                    print("Dynamic overlay executed for \(nextMatch.id)")
                                                    //should be implemented .
//                                                            loadMoreItems()
                                                }
                                                return Color.clear
                                                
                                            })
                                            
                                        }
                                        else {
                                            let nextMatch = matches[index + 1]
                                            NavigationLink(destination: NoLikesView()) {
                                                MatcheItemView(match: match, photoURL: "\(tokenManager.serverImageURL)")
                                            }
                                            .frame(maxWidth: .infinity)
                                            .listRowBackground(themeManager.currentTheme.backgroundColor)
                                            .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                                            .id(nextMatch.id)
                                        }
                                    }
                                    else {
                                        Spacer().frame(maxWidth: .infinity)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                            }
                        }
                        
                        if matches.count > 8 {
                            Color.clear.frame(height: 100)
                        }
                        
                        if !matches.isEmpty &&  hasMore {
                            HStack {
                                Spacer()
                                if  isLoading {
                                    ProgressView().padding()
                                }
                                Spacer()
                            }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .background(themeManager.currentTheme.backgroundColor)
                    .accentColor(themeManager.currentTheme.primaryColor)
                    .padding(.top, 10)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeManager.currentTheme.backgroundColor)
    }
    
   
}

