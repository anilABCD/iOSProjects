//
//  MatchedHome.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 29/03/25.
//


import SwiftUI

struct MatchedHome: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var tokenManager : TokenManager
    
    var body: some View {
        VStack {
            
            SlidingTabsTwoView(
                tabs: ["Messages", "Requests"] ,
                barBottomTab: false ,
                tabTitleBackgroundHighlighter: true ,
                isSecondarTabs : true  ,
                showBottomLine : true ,
                showSeperator : false
            ) {
                
                VStack { MatchedProfilesForMessagingListScreenView() }
                VStack {  SlidingTabsTwoView(
                    tabs: ["Received", "Sent"] ,
                    barBottomTab: false ,
                    tabTitleBackgroundHighlighter: false  ,
                    isSecondarTabs : true ,
                    showBottomLine : false ,
                    showSeperator : true
                ) {
                    
                    MatchesReceivedListView(viewModel: MatchViewModel(modelContext: modelContext , accessToken: tokenManager.accessToken))
                    VStack { Text("Sent").font(.title).padding() }
                    
                }.navigationBarTitle("Messages" , displayMode: .inline)
                }
            }.navigationBarTitle("Messages" , displayMode: .inline)
            
        }
    }
}
 
