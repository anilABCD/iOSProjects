//
//  ToastView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 03/03/25.
//


import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
    }
}
