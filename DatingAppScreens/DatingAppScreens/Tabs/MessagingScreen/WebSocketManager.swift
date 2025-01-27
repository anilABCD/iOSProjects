//
//  WebSocketManager.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 21/06/24.
//

import Foundation

import SocketIO

class DeliveredData: ObservableObject, Equatable  {
    @Published var chatId: String
    @Published var receiverUserId: String
    @Published var timestamp: Date

    init(chatId: String, receiverUserId: String, timestamp: Date) {
        
        self.chatId = chatId
        self.receiverUserId = receiverUserId
        self.timestamp = timestamp
        
    }
    
    // Implementing Equatable to compare all fields
        static func == (lhs: DeliveredData, rhs: DeliveredData) -> Bool {
            return lhs.chatId == rhs.chatId &&
                   lhs.receiverUserId == rhs.receiverUserId &&
                   lhs.timestamp == rhs.timestamp
        }
}

class WebSocketManager: ObservableObject {
    @Published var messages: [[String: Any]] = []
    @Published private var manager: SocketManager?
    @Published var token : String = ""
    @Published var deliveredMessageData : DeliveredData = DeliveredData(chatId : "" , receiverUserId: "", timestamp: Date())
    
    @Published var isOnChatScreen : Bool = false;
    
    private var socket: SocketIOClient!
    
    @Published var otherUserId : String = ""
    @Published var userId : String = "" ;
    
    @Published var loclhost : String = "" ;
    
    init(token:String , userId:String) {
       
        self.token = token;
        self.otherUserId = userId
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
            
            self.registerUser(userId: self.otherUserId)
        }
        
       
        
        socket.connect()
        
        socket.on("messageDelivered") { data, _ in
            
            print ("message from socket" , data)
            
            if let messageData = data as? [[String: Any]] {
                for item in messageData {
                    if let receiverUserId = item["receiverUserId"] as? String,
                        let timestampString = item["timestamp"] ,
                        let chatId = item["chatId"] as? String {
                        
                        var timestamp : Date;
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
                        
                        if let timestampDate = dateFormatter.date(from: timestampString as! String) {
                            timestamp = timestampDate
                        } else if let timestampDouble = Double(timestampString as! Substring) {
                            timestamp = Date(timeIntervalSince1970: timestampDouble)
                        }else{
                            timestamp = Date.now
                        }
                        
                        self.deliveredMessageData =  DeliveredData(chatId : chatId , receiverUserId: receiverUserId , timestamp: timestamp as Date)
                    }
                }
                
            }
        }
        
        socket.on("newMessage") { data, _ in
            
            
            if ( self.isOnChatScreen ) {
                
                print ("message from socket" , data)
                
                if let messageData = data as? [[String: Any]] {
                    for item in messageData {
                        if let chatId = item["chatId"] as? String ,
                           let sender = item["sender"] as? String,
                           let text = item["text"] as? String ,
                           let image = item["image"] ,
                           let timestampString = item["timestamp"] as? String {
                            DispatchQueue.main.async {
                                self.messages.append([ "chatId" : chatId , "sender": sender, "text": text , "image" : image, "timestamp" : timestampString ])
                                
                                
                                print(self.messages)
                            }
                            
                            if( sender != self.userId ) {
                                
                                print("received : \(sender) \(self.otherUserId)")
                                let messageData: [String: Any] = [
                                    "receiverByUserId" : self.userId ,
                                    "sender": sender,
                                    "timestamp" :  item["timestamp"] ?? ""
                                ]
                                
                                
                                self.socket.emit("messageReceieved", messageData );
                                
                                
                            }
                            
                            
                        }
                    }
                }
                else{
                    print("no message")
                }
                
            }
        }
    }
    
    func registerUser( userId: String ) {
        socket.emit("registerUser", self.otherUserId )
    }
    
    func joinChat( chatId: String ) {
        
        print ("join chat" , chatId)
        socket.emit("joinChat", chatId )
    }
    
    func sendMessage(_ newMessageText: String , imageBase64 : String , chatId : String , senderId : String , user2 : String) {
//        socket.emit("sendMessage", message )
      
        guard !newMessageText.isEmpty || !imageBase64.isEmpty else { return }
        
        print("send message base " , imageBase64)

               let messageData: [String: Any] = [
                   "chatId": chatId,
                   "sender": senderId,
                   "text": newMessageText,
                   "imageBase64" : imageBase64 ,
                   "user2" : user2
               ]
        
        
        print( "image base 64" , imageBase64 )

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
