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
        
        
        socket.on("message") { data, _ in
            
            print ("message from socket" , data)
            
            if let messageData = data.first as? [String: Any],
                          let userId = messageData["userId"] as? String,
                          let message = messageData["message"] as? String {
                DispatchQueue.main.async {
                    self.messages.append(["userId": userId , "message" : message])
                }
            }
        }
    }
    
    func registerUser( userId: String ) {
        socket.emit("registerUser", self.userId )
    }
    
    func sendMessage(_ message: [String: Any]) {
        socket.emit("sendMessage", message )
    }
    
    func disconnect() {
        if let socket = socket {
            socket.disconnect()
        } else {
            print("Socket is nil, cannot disconnect")
        }

    }
}
