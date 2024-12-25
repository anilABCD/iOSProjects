//
//  ProfileModel.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 10/06/24.
//

import Foundation


struct Profile: Identifiable, Decodable {
    var objectId: ObjectId
    var name: String?
    var email: String?
    var photo : String?
    var experience: Int?
    var technologies: [String]?
    var bio : String?
    var isOnline : Bool?
  
    // Computed property for Identifiable protocol
    var id: String {
        return objectId.value
    }
    
    enum CodingKeys: String, CodingKey {
        case objectId = "_id"
        case name
        case email
        case photo
        case experience
        case technologies
        case bio
        case isOnline
    }
}

struct ProfileEncodable : Encodable {
    
  
}

