//
//  MatchedHome.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 29/03/25.
//


import SwiftUI

struct MatchedHome: View {
    
 
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
                    
                    VStack {  Text("Received").font(.title).padding()}
                    VStack { Text("Sent").font(.title).padding() }
                    
                }.navigationBarTitle("Messages" , displayMode: .inline)
                }
            }.navigationBarTitle("Messages" , displayMode: .inline)
            
        }
    }
}
 
