//
//  TabBarExample.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//


//
//  TabBarExample.swift
//  ByExample
//
//  See LICENSE File for this project's licensing information.
//
//  Created by CodeWithChris (https://codewithchris.com)
//  Copyright © 2023 CodeWithChris. All rights reserved
//

import SwiftUI

/// TabView usage example
/// A view that switches between multiple child views using interactive
/// user interface elements.
struct TabBarExample: View {
    var body: some View {
        VStack {
            
            Text("Tab Bar Example").font(.largeTitle).fontWeight(.bold)
            
            
            TabView {
                FirstTabView()
                    .badge(2)
                    .tabItem {
                        Label("First", systemImage: "swift")
                    }
                
                SecondTabView()
                    .tabItem {
                        Label("Second", systemImage: "tray.and.arrow.down.fill")
                    }
                
                ThirdTabView()
                    .badge("!")
                    .tabItem {
                        Label("Third", systemImage: "person.crop.circle.fill")
                    }
            }
        }.frame(height: 300).border(.blue)
    }
}

struct FirstTabView: View {
    var body: some View {
        Text("First tab")
    }
}

struct SecondTabView: View {
    var body: some View {
        Text("Second tab")
    }
}

struct ThirdTabView: View {
    var body: some View {
        Text("Third tab")
    }
}

#Preview {
    TabBarExample()
}
