//
//  Profile.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 17/03/25.
//


import Foundation
import SwiftData

@Model
class ProfileEntity: Identifiable {
    @Attribute(.unique) var id: String
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
    
    init(
        id: String ,
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
        gender: String? = nil
    ) {
        self.id = id
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
}

 

import SwiftData

@MainActor
class ProfileService {
     
    static func fetchProfiles(from context: ModelContext) async -> [Profile] {
        let descriptor = FetchDescriptor<ProfileEntity>()
        do {
            let entities = try context.fetch(descriptor)
            return entities.map { entity in
                Profile(
                    id: entity.id,
                    name: entity.name,
                    email: entity.email,
                    photo: entity.photo,
                    experience: entity.experience,
                    technologies: entity.technologies,
                    hobbies: entity.hobbies,
                    drinking: entity.drinking,
                    smoking: entity.smoking,
                    jobRole: entity.jobRole,
                    dob: entity.dob,
                    bio: entity.bio,
                    isOnline: entity.isOnline,
                    gender: entity.gender
                )
            }
        } catch {
            print("Error fetching profiles: \(error)")
            return []
        }
    }
 
    static func saveProfilesToSwiftData(_ newProfiles: [Profile], modelContext: ModelContext) async {
        for profile in newProfiles {
            let profileEntity = ProfileEntity(
                id : profile.id ,
                name: profile.name,
                email: profile.email,
                photo: profile.photo,
                experience: profile.experience,
                technologies: profile.technologies,
                hobbies: profile.hobbies,
                drinking: profile.drinking,
                smoking: profile.smoking,
                jobRole: profile.jobRole,
                dob: profile.dob,
                bio: profile.bio,
                isOnline: profile.isOnline,
                gender: profile.gender
            )
            modelContext.insert(profileEntity) // Insert into SwiftData
        }
        
        do {
            try modelContext.save() // Save changes
            print("Profiles saved successfully!")
        } catch {
            print("Failed to save profiles: \(error.localizedDescription)")
        }
    }
 
    static func deleteProfile(by id: String, from context: ModelContext) async {
           let descriptor = FetchDescriptor<ProfileEntity>(predicate: #Predicate { $0.id == id })
           do {
               if let entity = try context.fetch(descriptor).first {
                   context.delete(entity)
                   try context.save()
               }
           } catch {
               print("Error deleting profile: \(error)")
           }
       }
}
