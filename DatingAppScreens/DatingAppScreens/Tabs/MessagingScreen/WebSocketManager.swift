//
//  WebSocketManager.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 21/06/24.
//

import Foundation

import SocketIO

class WebSocketManager: ObservableObject {
    @Published var messages: [String] = []
    @Published private var manager: SocketManager?
    @Published var token : String = ""
    private var socket: SocketIOClient!
    
    
    
    init(token:String ) {
       
        self.token = token;
    }
    
    func connect () {
        guard let url = URL(string: "http://192.168.1.4:8000/peerjs/") else { return }
                // Corrected to use SocketIOClientOption for connectParams
        let config: SocketIOClientConfiguration = [.log(true), .compress, .connectParams(["token": self.token])]
        manager = SocketManager(socketURL: url, config: config)
        socket = manager?.defaultSocket
        
        socket.on(clientEvent: .connect) { _, _ in
            print("WebSocket connected")
        }
        
        socket.on("message") { data, _ in
            if let message = data[0] as? String {
                DispatchQueue.main.async {
                    self.messages.append(message)
                }
            }
        }
        
        socket.connect()
    }
    
    func sendMessage(_ message: String) {
        socket.emit("sendMessage", message)
    }
    
    func disconnect() {
        if let socket = socket {
            socket.disconnect()
        } else {
            print("Socket is nil, cannot disconnect")
        }

    }
}
