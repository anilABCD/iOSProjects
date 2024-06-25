//
//  MessagingScreen.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 21/06/24.
//

import Foundation
import SwiftUI


struct ChatView: View {
    @EnvironmentObject private var tokenManger : TokenManager
    
    
    @ObservedObject private var webSocketManager = WebSocketManager(token: "")
    @State private var newMessage: String = ""
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(webSocketManager.messages, id: \.self) { message in
                        Text(message)
                            .padding(10)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    self.webSocketManager.sendMessage(self.newMessage)
                    self.newMessage = ""
                }) {
                    Text("Send")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
            .padding()
        }
        .onAppear(){
            webSocketManager.token = tokenManger.accessToken;
            webSocketManager.connect()
        }
        .navigationBarTitle("Chat")
        .onDisappear {
            self.webSocketManager.disconnect()
        }
    }
}
