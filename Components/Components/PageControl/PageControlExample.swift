//
//  PageControlExample.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//


//
//  PageControlExample.swift
//  ByExample
//
//  See LICENSE File for this project's licensing information.
//
//  Created by CodeWithChris (https://codewithchris.com)
//  Copyright © 2023 CodeWithChris. All rights reserved
//

import SwiftUI

/// PageTabViewStyle
/// A TabViewStyle that implements a paged scrolling TabView
///
/// https://developer.apple.com/documentation/SwiftUI/PageTabViewStyle
struct PageControlExample: View {
    var body: some View {
        /// Wrap views in a TabView
        VStack {
            
            Text ("Page Control Example").fontWeight(.bold)
            
            TabView {
                Text("Tab View 1")
                Text("Tab View 2")
                Text("Tab View 3")
            }
            /// Specify the tab view style to page
            .tabViewStyle(.page)
            /// Specify the index style to page and always show in display
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }.frame(height: 400).border(.blue)
    }
}

#Preview {
    PageControlExample()
}
