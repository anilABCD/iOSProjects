//
//  ContentView.swift
//  SwfitUIVStackHStackZStack
//
//  Created by Anil Kumar Potlapally on 06/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        
        ZStack {
            
            Image( systemName: "earbuds.case.fill")
                .resizable()
                .scaledToFit()
                .padding()
                .background(.green)
            
            VStack {
                HStack {
                    Text("Hellow World!")
                        .padding()
                        .background(Color.gray)
                    
                    Text("Helllow , chaddar !")
                        .padding()
                        .background(.orange)
                }
                
                
                HStack {
                    Text("Hellow World!")
                        .padding()
                        .background(Color.gray)
                    
                    Text("Helllow , chaddar !")
                        .padding()
                        .background(.orange)
                    
                }
            }.padding()
            
            Image(systemName: "airpodspro")
                .resizable()
                .scaledToFit()
                .foregroundColor(.yellow)
                .padding(80)
                
        }
        
    }
}

#Preview {
    ContentView()
}
