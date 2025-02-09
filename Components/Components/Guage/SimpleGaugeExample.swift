//
//  SimpleGaugeExample.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//


//
//  SimpleGaugeExample.swift
//  ByExample
//
//  See LICENSE File for this project's licensing information.
//
//  Created by CodeWithChris (https://codewithchris.com)
//  Copyright © 2023 CodeWithChris. All rights reserved
//

import SwiftUI

/// Gauge
/// A view that shows a value within a range
///
/// https://developer.apple.com/documentation/swiftui/gauge
struct SimpleGaugeExample: View {
    @State private var batteryLevel = 0.4
    
    var body: some View {
        VStack {
            
            Text("Simple Gauge Example").fontWeight(.bold)
            Gauge(value: batteryLevel) {
                Text("Battery Level")
            }
            
        }.border(.blue)
    }
}

#Preview {
    SimpleGaugeExample()
}
