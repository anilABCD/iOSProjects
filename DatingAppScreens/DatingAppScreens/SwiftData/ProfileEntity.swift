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

 
func saveProfilesToSwiftData(_ newProfiles: [Profile], modelContext: ModelContext) async {
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
