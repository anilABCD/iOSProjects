//
//  LikesEncodable.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/03/25.
//

import Foundation

struct OtherProfile: Identifiable, Codable, Equatable, Hashable {
    var objectId: ObjectId
    var name: String?
    var email: String?
    var photo: String?
    var experience: Int?
    var technologies: [String]?
    var hobbies: [String]?
    var drinking: String?
    var smoking: String?
    var jobRole: String?
    var dob: Date?
    var bio: String?
    var isOnline: Bool?
    var gender: String?
    
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
        case dob
        case hobbies
        case drinking
        case smoking
        case jobRole
        case bio
        case isOnline
        case gender
    }
    
    init(objectId: ObjectId,
         name: String? = nil,
         email: String? = nil,
         photo: String? = nil,
         experience: Int? = nil,
         technologies: [String]? = nil,
         hobbies: [String]? = nil,
         drinking: String? = nil,
         smoking: String? = nil,
         jobRole: String? = nil,
         dob: Date? = nil,
         bio: String? = nil,
         isOnline: Bool? = nil,
         gender: String? = nil) {
        
        self.objectId = objectId
        self.name = name
        self.email = email
        self.photo = photo
        self.experience = experience
        self.technologies = technologies
        self.hobbies = hobbies
        self.drinking = drinking
        self.smoking = smoking
        self.jobRole = jobRole
        self.dob = dob
        self.bio = bio
        self.isOnline = isOnline
        self.gender = gender
    }
    
    // Custom decoder to handle date formatting
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
        
        // Handle date decoding with multiple formats
        if let dobString = try container.decodeIfPresent(String.self, forKey: .dob) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
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
            self.dob = nil
        }
    }
    
    // Implementing Hashable
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
        hasher.combine(dob)
        hasher.combine(bio)
        hasher.combine(isOnline)
        hasher.combine(gender)
    }
    
    // Implementing Equatable
    static func == (lhs: OtherProfile, rhs: OtherProfile) -> Bool {
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
        lhs.dob == rhs.dob &&
        lhs.bio == rhs.bio &&
        lhs.isOnline == rhs.isOnline &&
        lhs.gender == rhs.gender
    }
}

struct OtherProfileEncodable: Encodable {
    var userId: String
}

extension OtherProfile {
    func toProfile() -> Profile {
        return Profile(
            id: self.id,
            name: self.name,
            email: self.email,
            photo: self.photo,
            experience: self.experience,
            technologies: self.technologies,
            hobbies: self.hobbies,
            drinking: self.drinking,
            smoking: self.smoking,
            jobRole: self.jobRole,
            dob: self.dob,
            bio: self.bio,
            isOnline: self.isOnline,
            gender: self.gender
        )
    }
}
