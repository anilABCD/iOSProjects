//
//  ActivityCard.swift
//  swiftuiHealthKit
//
//  Created by Anil Kumar Potlapally on 09/05/24.
//

import Foundation

import SwiftUI

struct ActivityCard : View {
    
    
    var body: some View {
      
        ZStack{
            
            Color( uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack (spacing:20) {
                HStack(alignment: .top , spacing: 5) {
                    VStack {
                        Text("Daily Steps")
                            .font(.system(size: 16))
                        Text("Goal : 10,000")
                            .font(.system(size: 12))
                    }
                    Spacer()
                    
                    Image ( systemName: "figure.walk")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            
                Text("6,235")
                    .font(.system(size: 24))
                
                
                
            }.padding()
             
        }.padding()
    }
}
