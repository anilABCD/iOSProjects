//
//  SheetExample.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//


//
//  SheetExample.swift
//  ByExample
//
//  See LICENSE File for this project's licensing information.
//
//  Created by CodeWithChris (https://codewithchris.com)
//  Copyright © 2023 CodeWithChris. All rights reserved
//

import SwiftUI

/// sheet(isPresented:onDismiss:content:) Modifier
/// Presents a sheet when a binding to a Boolean value that you provide is true.
///
/// https://developer.apple.com/documentation/SwiftUI/View/sheet(isPresented:onDismiss:content:)
struct SheetExample: View {
    @State private var sheetShown = false
    
    var body: some View {
        /// Show sheet upon button tap
       
        VStack {
            
            Text("Sheet Example")
            
            Button("Show Agreement") {
                sheetShown = true
            }
            .sheet(isPresented: $sheetShown) {
                VStack {
                    Text("Agreement")
                    /// Dismiss sheet upon button tap
                    Button("Dismiss") {
                        sheetShown = false
                    }
                }
            }
        }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .border(Color.blue)

    }
        
}

#Preview {
    SheetExample()
}
