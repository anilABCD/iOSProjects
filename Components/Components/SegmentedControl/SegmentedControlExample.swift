//
//  SegmentedControlExample.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//


//
//  SegmentedControlExample.swift
//  ByExample
//
//  See LICENSE File for this project's licensing information.
//
//  Created by CodeWithChris (https://codewithchris.com)
//  Copyright © 2023 CodeWithChris. All rights reserved
//

import SwiftUI

/// Picker
/// A control for selecting from a set of mutually exclusive values.
///
/// https://developer.apple.com/documentation/swiftui/picker
struct SegmentedControlExample: View {
    @State private var selectedColor: Color = .red
    
    var body: some View {
        VStack {
            
            Text("Segmented Control Example").font(.largeTitle)
            
            Text("Select Background Color")
            /// Add a Picker, and set its picker style to `.segmented`
            Picker("Background Color", selection: $selectedColor) {
                /// The tag will change the value of `$selectedColor`
                /// upon selection
                Text("Red").tag(Color.red)
                Text("Green").tag(Color.green)
                Text("Blue").tag(Color.blue)
            }
            /// Set it's style with the picker style modifier
            .pickerStyle(.segmented)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(selectedColor)
        .border(.blue)
    }
}

#Preview {
    SegmentedControlExample()
}
