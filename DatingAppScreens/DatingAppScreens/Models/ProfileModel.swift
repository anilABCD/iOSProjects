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
    
    var dob: Date? // Added Date of Birth
       
    
    var bio: String?
    var isOnline: Bool?
    
    var gender : String?
    
    var leftSwipe : UUID = UUID()
    var rightSwipe : UUID = UUID()
    
    
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
        
        case dob
        
        case hobbies
        case drinking
        case smoking
        case jobRole
        
        case bio
        case isOnline
        
        case gender
    }
    
    // Custom Decoding to Handle dob as String or Timestamp
       init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)

           self.objectId = try container.decode(ObjectId.self, forKey: .objectId)
           self.name = try container.decodeIfPresent(String.self, forKey: .name)
           self.email = try container.decodeIfPresent(String.self, forKey: .email)
           self.photo = try container.decodeIfPresent(String.self, forKey: .photo)
           self.experience = try container.decodeIfPresent(Int.self, forKey: .experience)
           self.technologies = try container.decodeIfPresent([String].self, forKey: .technologies)

           self.hobbies = try container.decodeIfPresent([String].self, forKey: .hobbies)
           self.drinking = try container.decodeIfPresent(String.self, forKey: .drinking)
           self.smoking = try container.decodeIfPresent(String.self, forKey: .smoking)
           self.jobRole = try container.decodeIfPresent(String.self, forKey: .jobRole)

           self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
           self.isOnline = try container.decodeIfPresent(Bool.self, forKey: .isOnline)

           self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
           
           self.leftSwipe = UUID()
           self.rightSwipe = UUID()
           
           // Handle the decoding of `timestamp` properly
           if let dobString = try container.decodeIfPresent(String.self, forKey: .dob) {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
               
               if let dobDate = dateFormatter.date(from: dobString) {
                   self.dob = dobDate
               } else if let dobDouble = Double(dobString) {
                   self.dob = Date(timeIntervalSince1970: dobDouble)
               } else {
                   
                   throw DecodingError.dataCorruptedError(
                       forKey: .dob,
                       in: container,
                       debugDescription: "Invalid date format: \(dobString)"
                   )
               }
           } else {
               self.dob = nil // If timestamp is not provided, set it to nil
           }
           
       }


    // Implementing `Equatable` protocol
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.objectId == rhs.objectId &&
               lhs.name == rhs.name &&
               lhs.email == rhs.email &&
               lhs.photo == rhs.photo &&
               lhs.experience == rhs.experience &&
               lhs.technologies == rhs.technologies &&
       
        lhs.dob == rhs.dob &&
        
                lhs.hobbies == rhs.hobbies &&
                lhs.drinking == rhs.drinking &&
                lhs.smoking == rhs.smoking &&
                lhs.jobRole == rhs.jobRole &&
        
        lhs.leftSwipe == rhs.leftSwipe &&
        lhs.rightSwipe == rhs.rightSwipe &&
        
               lhs.bio == rhs.bio &&
               lhs.isOnline == rhs.isOnline &&
        lhs.gender == rhs.gender
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
           
           
           hasher.combine(leftSwipe)
           hasher.combine(rightSwipe)
           
           hasher.combine(bio)
           hasher.combine(isOnline)
           
           hasher.combine(gender)
           
           hasher.combine(dob)
       }
}

struct ProfileEncodable : Encodable {
    
  
}

struct ProfileParametersEncodable : Encodable {
    
    var technologies : String
    var minExperience : String
    var maxExperience : String
    
    var excludingIds : String
    
}

