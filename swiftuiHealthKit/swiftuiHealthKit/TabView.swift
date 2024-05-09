//
//  BeAvtiveTabView.swift
//  swiftuiHealthKit
//
//  Created by Anil Kumar Potlapally on 09/05/24.
//

import Foundation

import SwiftUI

struct BeActiveTabView : View {
    
    @EnvironmentObject var manager : HealthManager;
    @State var selectedTab  = "Home"
    
    
    var body: some View {
        TabView(selection: $selectedTab ) {
            
            HomeView()
                .tabItem { Image( systemName: "house") }.tag(0)
            
            HomeView()
                .tabItem {  Image( systemName: "person") }.tag(1)
        }
    }
    
}
