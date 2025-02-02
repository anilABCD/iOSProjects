//
//  ProfileModel.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 10/06/24.
//

import Foundation

 
// ObjectId structure
struct ObjectId: Codable, Equatable , Hashable{
    var value: String
    
    // Initializer for ObjectId
    init(value: String) {
        self.value = value
    }
    
    // Decoding ObjectId from a string
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        self.value = stringValue
    }

    // Encoding ObjectId as a string
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }

    // Conformance to Equatable
    static func == (lhs: ObjectId, rhs: ObjectId) -> Bool {
        return lhs.value == rhs.value
    }
    
    // Conformance to Hashable
       func hash(into hasher: inout Hasher) {
           hasher.combine(value)
       }
}

struct Profile: Identifiable, Codable, Equatable, Hashable {
    var objectId: ObjectId
    var name: String?
    var email: String?
    var photo: String?
    var experience: Int?
    var technologies: [String]?
    
    var hobbies: [String]?
    var drinking: String?
    var smoking : String?
    var jobRole : String?
    
    var bio: String?
    var isOnline: Bool?
    
    // Computed property for Identifiable protocol
    var id: String {
        return objectId.value
    }
    
    // Custom enum for decoding (mapping keys)
    enum CodingKeys: String, CodingKey {
        case objectId = "_id"
        case name
        case email
        case photo
        case experience
        case technologies
        
        case hobbies
        case drinking
        case smoking
        case jobRole
        
        case bio
        case isOnline
    }

    // Implementing `Equatable` protocol
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.objectId == rhs.objectId &&
               lhs.name == rhs.name &&
               lhs.email == rhs.email &&
               lhs.photo == rhs.photo &&
               lhs.experience == rhs.experience &&
               lhs.technologies == rhs.technologies &&
        
                lhs.hobbies == rhs.hobbies &&
                lhs.drinking == rhs.drinking &&
                lhs.smoking == rhs.smoking &&
                lhs.jobRole == rhs.jobRole &&
        
        
               lhs.bio == rhs.bio &&
               lhs.isOnline == rhs.isOnline
    }
    
    // Implementing `Hashable` protocol
       func hash(into hasher: inout Hasher) {
           hasher.combine(objectId)
           hasher.combine(name)
           hasher.combine(email)
           hasher.combine(photo)
           hasher.combine(experience)
           hasher.combine(technologies)
           
           hasher.combine(hobbies)
           hasher.combine(drinking)
           hasher.combine(smoking)
           hasher.combine(jobRole)
           
           hasher.combine(bio)
           hasher.combine(isOnline)
       }
}

struct ProfileEncodable : Encodable {
    
  
}

