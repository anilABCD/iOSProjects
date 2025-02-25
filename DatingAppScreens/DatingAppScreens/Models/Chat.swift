//
//  Chat.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 26/12/24.
//

import Foundation
//
//// MARK: - LastMessage Structure
//struct LastMessage: Decodable {
//    var text: String?
//    var image: String?
//    var timestamp: Date?
//    var sender: String? // The sender's user ID
//    
//    private enum CodingKeys: String, CodingKey {
//        case text, image, sender, timestamp
//    }
//    
//    // Custom date decoding
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.text = try container.decode(String?.self, forKey: .text)
//        self.image = try container.decode(String?.self, forKey: .image)
//        self.sender = try container.decode(String.self, forKey: .sender)
//        
//        let timestampString = try container.decode(String.self, forKey: .timestamp)
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
//        
//        if let timestampDate = dateFormatter.date(from: timestampString) {
//            self.timestamp = timestampDate
//        } else if let timestampDouble = Double(timestampString) {
//            self.timestamp = Date(timeIntervalSince1970: timestampDouble)
//        } else {
//            throw DecodingError.dataCorruptedError(
//                forKey: .timestamp,
//                in: container,
//                debugDescription: "Invalid timestamp format: \(timestampString)"
//            )
//        }
//    }
//}
//

 
// MARK: - LastMessage Structure
struct LastMessage: Identifiable, Codable , Equatable , Hashable {
    var id: String? // Add a unique ID for Identifiable conformance
    var text: String?
    var image: String?
    var timestamp: Date?
    var sender: String? // The sender's user ID
    
    private enum CodingKeys: String, CodingKey {
        case id , text, image, sender, timestamp
    }
    
    
    // Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(text)
        hasher.combine(image)
        hasher.combine(timestamp)
        hasher.combine(sender)
    }

    // Custom initializers (if needed)
    init(text: String? = nil, image: String? = nil, sender: String? = nil, timestamp: Date? = nil) {
        self.id = UUID().uuidString // Assign a unique ID using UUID
        self.text = text
        self.image = image
        self.sender = sender
        self.timestamp = timestamp
    }
    
    
    // Implementing `Equatable` protocol
    static func == (lhs: LastMessage, rhs: LastMessage) -> Bool {
        return lhs.id == rhs.id &&
               lhs.text == rhs.text &&
               lhs.image == rhs.image &&
               lhs.timestamp == rhs.timestamp &&
               lhs.sender == rhs.sender
    }

    // Custom date decoding
      init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString // Provide a default ID if missing
          self.text = try container.decodeIfPresent(String.self, forKey: .text)
          self.image = try container.decodeIfPresent(String.self, forKey: .image)
          self.sender = try container.decodeIfPresent(String.self, forKey: .sender)
          
          // Handle the decoding of `timestamp` properly
          if let timestampString = try container.decodeIfPresent(String.self, forKey: .timestamp) {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
              
              if let timestampDate = dateFormatter.date(from: timestampString) {
                  self.timestamp = timestampDate
              } else if let timestampDouble = Double(timestampString) {
                  self.timestamp = Date(timeIntervalSince1970: timestampDouble)
              } else {
                  
                  throw DecodingError.dataCorruptedError(
                      forKey: .timestamp,
                      in: container,
                      debugDescription: "Invalid timestamp format: \(timestampString)"
                  )
              }
          } else {
              self.timestamp = nil // If timestamp is not provided, set it to nil
          }
      }


    // Encoding to JSON (or other formats)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(image, forKey: .image)
        try container.encode(sender, forKey: .sender)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
        let timestampString = dateFormatter.string(from: timestamp ?? Date())
        
        try container.encode(timestampString, forKey: .timestamp)
    }
}


class Chat: ObservableObject, Identifiable, Codable , Hashable {
    @Published var id: String
    @Published var participants: [Profile]
    @Published var messages: [Message]
    @Published var lastMessage: LastMessage?
    @Published var unreadCounts: [String: Int]?

    // Custom initializer for the class
    init(id: String, participants: [Profile], messages: [Message], lastMessage: LastMessage?, unreadCounts: [String: Int]?) {
        self.id = id
        self.participants = participants
        self.messages = messages
        self.lastMessage = lastMessage
        self.unreadCounts = unreadCounts
    }

    // Manually encode the @Published properties
    enum CodingKeys: String, CodingKey {
        case id, participants, messages, lastMessage, unreadCounts
    }
    
    
       // Conformance to Hashable
       static func == (lhs: Chat, rhs: Chat) -> Bool {
           return lhs.id == rhs.id &&
               lhs.participants == rhs.participants &&
               lhs.messages == rhs.messages &&
               lhs.lastMessage == rhs.lastMessage &&
               lhs.unreadCounts == rhs.unreadCounts
       }
       
       func hash(into hasher: inout Hasher) {
           hasher.combine(id)
           hasher.combine(participants)
           hasher.combine(messages)
           hasher.combine(lastMessage)
           hasher.combine(unreadCounts)
       }

    // Decoding from JSON or any other source
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each property
        let id = try container.decode(String.self, forKey: .id)
        let participants = try container.decode([Profile].self, forKey: .participants)
        let messages = try container.decode([Message].self, forKey: .messages)
        let lastMessage = try container.decodeIfPresent(LastMessage.self, forKey: .lastMessage)
        let unreadCounts = try container.decodeIfPresent([String: Int].self, forKey: .unreadCounts)
        
        // Initialize the object
        self.init(id: id, participants: participants, messages: messages, lastMessage: lastMessage, unreadCounts: unreadCounts)
    }

    // Encoding to JSON or other formats
     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         
         // Encode each property
         try container.encode(id, forKey: .id)
         try container.encode(participants, forKey: .participants)
         try container.encode(messages, forKey: .messages)
         try container.encodeIfPresent(lastMessage, forKey: .lastMessage)
         try container.encodeIfPresent(unreadCounts, forKey: .unreadCounts)
     }
    
  
    struct Message: Identifiable, Codable , Equatable , Hashable {
        var id: String
        var sender: String
        var text: String
        var image: String?
        var timestamp: Date
        var readBy: [String] // Array of user IDs who have read the message
        var delivered: Bool
        var monthTemp: String?
        
        var isSent : Bool = true
        
        var isNewMessages : Bool = false 
        
        // Computed property to check if the other person has read the message
        func isRead(by userID: String) -> Bool {
            return readBy.contains(userID)
        }
        
        // Conformance to Hashable
            func hash(into hasher: inout Hasher) {
                hasher.combine(id)
                hasher.combine(sender)
                hasher.combine(text)
                hasher.combine(image)
                hasher.combine(timestamp)
                hasher.combine(readBy)
                hasher.combine(delivered)
                hasher.combine(monthTemp)
                hasher.combine(isSent)
                hasher.combine(isNewMessages)
            }
        
        // Implementing `Equatable` protocol
           static func == (lhs: Message, rhs: Message) -> Bool {
               return lhs.id == rhs.id &&
                      lhs.sender == rhs.sender &&
                      lhs.text == rhs.text &&
                      lhs.image == rhs.image &&
                      lhs.timestamp == rhs.timestamp &&
                      lhs.readBy == rhs.readBy &&
                      lhs.delivered == rhs.delivered &&
                      lhs.isSent == rhs.isSent &&
               lhs.isNewMessages == rhs.isNewMessages
           }
        
        // Custom initializers
        init(sender: String, text: String, timestamp: String? = nil, image: String? = nil , isSent : Bool = false , isNewMessages : Bool = false , delivered: Bool = false, readBy: [String] = []) {
            self.id = UUID().uuidString // Generate a unique ID
            self.sender = sender
            self.text = text
            self.readBy = readBy
            self.delivered = delivered
            self.image = image
            
            self.isSent = isSent
            self.isNewMessages = isNewMessages
            
            let timestampString = timestamp?.isEmpty == false ? timestamp ?? getCurrentUTCTime() : getCurrentUTCTime()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
            dateFormatter.timeZone = TimeZone.current
            
            if let timestampDate = dateFormatter.date(from: timestampString ?? "") {
                self.timestamp = timestampDate
            } else if let timestampDouble = Double(timestampString ?? "") {
                self.timestamp = Date(timeIntervalSince1970: timestampDouble)
            } else {
                self.timestamp = Date.now
            }
        }

        // Enum for coding keys
        private enum CodingKeys: String, CodingKey {
            case id, sender, text, image, readBy, delivered, timestamp
        }

        // Decoding initializer for custom decoding of `timestamp`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try container.decode(String.self, forKey: .id)
            self.sender = try container.decode(String.self, forKey: .sender)
            self.text = try container.decode(String.self, forKey: .text)
            self.image = try container.decodeIfPresent(String.self, forKey: .image)
            self.readBy = try container.decode([String].self, forKey: .readBy)
            self.delivered = try container.decode(Bool.self, forKey: .delivered)
            
            let timestampString = try container.decode(String.self, forKey: .timestamp)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
            dateFormatter.timeZone = TimeZone.current
            
            if let timestampDate = dateFormatter.date(from: timestampString) {
                self.timestamp = timestampDate
            } else if let timestampDouble = Double(timestampString) {
                self.timestamp = Date(timeIntervalSince1970: timestampDouble)
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .timestamp,
                    in: container,
                    debugDescription: "Invalid timestamp format: \(timestampString)"
                )
            }
        }

        // Encoding to JSON (or other formats)
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(id, forKey: .id)
            try container.encode(sender, forKey: .sender)
            try container.encode(text, forKey: .text)
            try container.encodeIfPresent(image, forKey: .image)
            try container.encode(readBy, forKey: .readBy)
            try container.encode(delivered, forKey: .delivered)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
            let timestampString = dateFormatter.string(from: timestamp)
            
            try container.encode(timestampString, forKey: .timestamp)
        }
    }

    
//    struct Message: Identifiable, Decodable {
//        var id: String
//        var sender: String
//        var text: String
//        var image : String?
//        var timestamp: Date
//        var readBy: [String] // Array of user IDs who have read the message
//        var delivered: Bool
//        
//        var monthTemp : String?
//        // Computed property to check if the other person has read the message
//        func isRead(by userID: String) -> Bool {
//            return readBy.contains(userID)
//        }
//        
//     
//        // Provide a default initializer for `id`
//        init(sender: String, text: String, timestamp: String? , image : String? = nil, delivered : Bool = false ,  readBy : [String] = []) {
//            self.id = UUID().uuidString // Generate a unique ID
//            self.sender = sender
//            self.text = text
//            self.readBy = readBy
//            self.delivered = delivered
//            self.image = image
//            let timestampString = timestamp?.isEmpty == false ? timestamp ?? getCurrentUTCTime() : getCurrentUTCTime()
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
//            dateFormatter.timeZone = TimeZone.current
//            
//            if let timestampDate = dateFormatter.date(from: timestampString ?? "" ) {
//                
//                self.timestamp = timestampDate
//                
//            } else if let timestampDouble = Double(timestampString ?? "") {
//                
//                self.timestamp = Date(timeIntervalSince1970: timestampDouble)
//            }
//            else{
//                
//                self.timestamp = Date.now
//            }
//        }
//        
////        // Provide a default initializer for `id`
////        init(sender: String, text: String, timestampString: String , delivered : Bool = false , readBy : [String] = []) {
////            self.id = UUID().uuidString // Generate a unique ID
////            self.sender = sender
////            self.text = text
////            self.readBy = readBy
////            self.delivered = delivered
////            
////            
////            let dateFormatter = DateFormatter()
////            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
////            dateFormatter.timeZone = TimeZone.current
////            
////            if let timestampDate = dateFormatter.date(from: timestampString) {
////                self.timestamp = timestampDate
////            } else if let timestampDouble = Double(timestampString) {
////                self.timestamp = Date(timeIntervalSince1970: timestampDouble)
////            }
////            else{
////                self.timestamp = Date.now
////            }
////        }
////    
//        
//        private enum CodingKeys: String, CodingKey {
//            case id, sender, text, readBy , image , delivered , timestamp
//        }
//        
//        // Custom date decoding
//        init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            self.id = try container.decode(String.self, forKey: .id)
//            self.sender = try container.decode(String.self, forKey: .sender)
//            self.text = try container.decode(String.self, forKey: .text)
//            self.image = try container.decode(String?.self, forKey: .image)
//            self.delivered = try container.decode( Bool.self , forKey: .delivered)
//            self.readBy = try container.decode([String].self, forKey: .readBy)
//          
//            let timestampString = try container.decode(String.self, forKey: .timestamp)
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
//            dateFormatter.timeZone = TimeZone.current
//            
//            if let timestampDate = dateFormatter.date(from: timestampString) {
//                self.timestamp = timestampDate
//            } else if let timestampDouble = Double(timestampString) {
//                self.timestamp = Date(timeIntervalSince1970: timestampDouble)
//            } else {
//                throw DecodingError.dataCorruptedError(
//                    forKey: .timestamp,
//                    in: container,
//                    debugDescription: "Invalid timestamp format: \(timestampString)"
//                )
//            }
//        }
//    }
    
}
//// Extension to handle MongoDB ObjectId as string
//extension String {
//    // Convert the ObjectId-like string to a plain string if needed
//    static func fromObjectId(objectIdString: String) -> String {
//        if objectIdString.hasPrefix("new ObjectId(") {
//            let id = objectIdString.replacingOccurrences(of: "new ObjectId(\"", with: "").replacingOccurrences(of: "\")", with: "")
//            return id
//        }
//        return objectIdString
//    }
//}
