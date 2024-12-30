//
//  WebSocketManager.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 21/06/24.
//

import Foundation

import SocketIO

class WebSocketManager: ObservableObject {
    @Published var messages: [[String: Any]] = []
    @Published private var manager: SocketManager?
    @Published var token : String = ""
    private var socket: SocketIOClient!
    
    @Published var userId : String = ""
    
    @Published var loclhost : String = "" ;
    
    init(token:String , userId:String) {
       
        self.token = token;
        self.userId = userId
    }
    
    func connect () {
        guard let url = URL(string: "\(Constants.localhost)/peerjs/") else { return }
                // Corrected to use SocketIOClientOption for connectParams
        var config: SocketIOClientConfiguration = [.log(true), .compress]
       
        
        config.insert(.extraHeaders(["Authorization": "Bearer \(token)"]))
        
        manager = SocketManager(socketURL: url, config: config)
        
        
        

        
        socket = manager?.defaultSocket
        
        socket.on(clientEvent: .connect) { _, _ in
            print("WebSocket connected")
            
            self.registerUser(userId: self.userId)
        }
        
       
        
        socket.connect()
        
        
        socket.on("newMessage") { data, _ in
            
            print ("message from socket" , data)
            
            if let messageData = data as? [[String: Any]] {
                       for item in messageData {
                           if let sender = item["sender"] as? String,
                              let text = item["text"] as? String  , let timestampString = item["timestamp"] as? String{
                               DispatchQueue.main.async {
                                   self.messages.append(["sender": sender, "text": text , "timestamp" : timestampString ])
                                   print(self.messages)
                               }
                           }
                       }
                   }
            else{
                print("no message")
            }
            
            
        }
    }
    
    func registerUser( userId: String ) {
        socket.emit("registerUser", self.userId )
    }
    
    func joinChat( chatId: String ) {
        
        print ("join chat" , chatId)
        socket.emit("joinChat", chatId )
    }
    
    func sendMessage(_ newMessageText: String , chatId : String , senderId : String) {
//        socket.emit("sendMessage", message )
      
               guard !newMessageText.isEmpty else { return }

               let messageData: [String: Any] = [
                   "chatId": chatId,
                   "sender": senderId,
                   "text": newMessageText
               ]

        socket.emit( "sendMessage", messageData)
              
           
    }
    
    func disconnect() {
        if let socket = socket {
            socket.disconnect()
        } else {
            print("Socket is nil, cannot disconnect")
        }

    }
}
