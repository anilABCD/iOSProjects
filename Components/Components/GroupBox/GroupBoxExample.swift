//
//  GroupBoxExample.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//

import SwiftUI

struct GroupBoxExample: View {
    
    @State private var userAgreed = false
    
    var body: some View {
        
        VStack {
            
            Text(" Group Box Example ").fontWeight(.bold)
            
            GroupBox(label:
                        Label("Terms of Use", systemImage: "building.columns")
                .padding(.vertical)
            ) {
                ScrollView(.vertical, showsIndicators: true) {
                    Text(agreementText)
                        .font(.footnote)
                }
                .frame(height: 250)
                Toggle(isOn: $userAgreed) {
                    Text("I agree to the above terms")
                }
            }
            .padding()
        }.border(.blue)
    }
}

var agreementText = """
GroupBox Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
"""
