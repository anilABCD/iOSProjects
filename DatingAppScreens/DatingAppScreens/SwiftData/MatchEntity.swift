//
//  Match.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 30/03/25.
//


import Foundation
import SwiftData

// Match Model with SwiftData
@Model
class MatchEntity {
    @Attribute(.unique) var id: String
    var status: String
    var initiator: ProfileEntity?
    var participants: [ProfileEntity]
    var updatedAt: Date // ✅ Cache expiry timestamp
    var pageNumber : Int  // ✅ Store Page Number
    
    init(id: String, status: String ,  initiator: ProfileEntity?, participants: [ProfileEntity] , pageNumber : Int, updatedAt : Date) {
        self.id = id
        self.status = status
        self.initiator = initiator
        self.participants = participants
        self.pageNumber = pageNumber
        self.updatedAt = updatedAt
    }
    
    // Computed property to get the matched user excluding self
    func getOtherParticipant(currentUserID: String) -> ProfileEntity? {
        return participants.first { $0.id != currentUserID }
    }
}

 
