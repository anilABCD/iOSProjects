//
//  ListSeparatorHidden.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//


//
//  ListSeparatorHidden.swift
//  ByExample
//
//  See LICENSE File for this project's licensing information.
//
//  Created by CodeWithChris (https://codewithchris.com)
//  Copyright © 2023 CodeWithChris. All rights reserved
//

import SwiftUI

struct ListSeparatorHidden: View {
    let fruits = ["Apple", "Banana", "Coconut"]
    
    var body: some View {
        
        VStack {
            
            Text("List Separator Hidden").fontWeight(.bold)
            
            List(fruits, id: \.self) { fruit in
                Text(fruit)
                    .listRowSeparator(.hidden)
            }
            
        }.frame(height: 300).border(.blue)
    }
}

#Preview {
    ListSeparatorHidden()
}
