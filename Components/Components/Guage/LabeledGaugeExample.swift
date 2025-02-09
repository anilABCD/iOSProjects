//
//  LabeledGaugeExample.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//


//
//  LabeledGaugeExample.swift
//  ByExample
//
//  See LICENSE File for this project's licensing information.
//
//  Created by CodeWithChris (https://codewithchris.com)
//  Copyright © 2023 CodeWithChris. All rights reserved
//

import SwiftUI

struct LabeledGaugeExample: View {
    @State private var current = 60.0
    @State private var minValue = 0.0
    @State private var maxValue = 100.0
    
    var body: some View {
        VStack {
            
            Text("Labeled Guage Example").fontWeight(.bold)
            Gauge(value: current, in: minValue...maxValue) {
                Text("Volume")
            } currentValueLabel: {
                Text("\(Int(current))")
            } minimumValueLabel: {
                Text("\(Int(minValue))")
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
            }
        }.border(.blue)
    }
}

#Preview {
    LabeledGaugeExample()
}
