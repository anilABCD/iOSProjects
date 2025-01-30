//
//  UnreadChatCountResponse.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 30/01/25.
//

import Foundation

// Decodable structure to match the JSON response
struct UnreadChatCountResponse: Identifiable , Decodable {
    
    let id : UUID = UUID()
    let count: Int
}
