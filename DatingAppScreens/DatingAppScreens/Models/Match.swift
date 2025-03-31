//
//  Match.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 30/03/25.
//

import Foundation

// Match Model
struct Match: Codable, Identifiable {
    let id: String
    let status: String
    let initiator: Profile?
    let participants: [Profile]?
}

// API Response for Received Matches
struct ReceivedMatchesResponse: Codable , Identifiable {
    let id = UUID()
    let receivedMatches: [Match]
    let totalReceivedMatches: Int
    let page: Int
    let totalPages: Int
}

// API Response for Sent Matches
struct SentMatchesResponse: Codable {
    let sentMatches: [Match]
    let totalSentMatches: Int
    let page: Int
    let totalPages: Int
}


