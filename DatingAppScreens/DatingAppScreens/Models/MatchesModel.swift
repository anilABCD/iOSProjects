//
//  MatchesModel.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 10/06/24.
//

import Foundation

struct Matches : Encodable {
    
   var user2_id : String;
    
    
    init(user2_id: String) {
        self.user2_id = user2_id
    }
    
}

struct MatchesResponse : Identifiable, Decodable {
   
    var user2_id: ObjectId?
    var user1_id: ObjectId?
    var status: String?
    enum CodingKeys: String, CodingKey {
            case user2_id
            case user1_id
            case status
        }
        
    // Computed property for Identifiable protocol
    var id: String {
        return  UUID().uuidString
    }
    
}
