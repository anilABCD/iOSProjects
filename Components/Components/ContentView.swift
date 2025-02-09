//
//  ContentView.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        ScrollView {
           
            TextInputTypeExample()
               
            GroupBoxExample()
            
            PageControlExample()
            
            SheetExample()
            
            TextExample()
            
            ColorPickerExample()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
