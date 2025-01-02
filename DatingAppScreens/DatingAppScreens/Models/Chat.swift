//
//  Chat.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 26/12/24.
//

import Foundation

// MARK: - LastMessage Structure
struct LastMessage: Decodable {
    let text: String?
    let image: String?
    let timestamp: Date?
    let sender: String? // The sender's user ID
    
    private enum CodingKeys: String, CodingKey {
        case text, image, sender, timestamp
    }
    
    // Custom date decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.image = try container.decode(String.self, forKey: .image)
        self.sender = try container.decode(String.self, forKey: .sender)
        
        let timestampString = try container.decode(String.self, forKey: .timestamp)
        
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
    }
}

struct Chat: Identifiable, Decodable {
    var id: String // Chat ID
    var participants: [Profile] // User IDs of participants
    var messages: [Message] // Array of messages
    var lastMessage : LastMessage?
    let unreadCounts: [String: Int]? // User ID to unread count mapping
    
    struct Message: Identifiable, Decodable {
        var id: String
        var sender: String
        var text: String
        var timestamp: Date
        
        // Provide a default initializer for `id`
        init(sender: String, text: String, timestamp: Date) {
            self.id = UUID().uuidString // Generate a unique ID
            self.sender = sender
            self.text = text
            self.timestamp = timestamp
        }
        
        private enum CodingKeys: String, CodingKey {
            case id, sender, text, timestamp
        }
        
        // Custom date decoding
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.sender = try container.decode(String.self, forKey: .sender)
            self.text = try container.decode(String.self, forKey: .text)
            
            let timestampString = try container.decode(String.self, forKey: .timestamp)
            
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
        }
    }
    
}
