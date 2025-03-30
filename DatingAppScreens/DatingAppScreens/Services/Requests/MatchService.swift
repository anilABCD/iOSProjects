


import Foundation
import SwiftData

@Observable
class MatchService {
    private static let cacheExpiryInterval: TimeInterval = 60 * 5 // 5 minutes
    static let shared = MatchService() // ✅ Singleton Instance

    @MainActor
    func fetchMatches(page: Int, perPage: Int, context: ModelContext) async throws -> [MatchEntity] {
        // ✅ Step 1: Fetch Cached Data
        let fetchDescriptor = FetchDescriptor<MatchEntity>()
        let cachedMatches: [MatchEntity] = try context.fetch(fetchDescriptor)


        // ✅ Step 2: Apply Pagination
        let startIndex = (page - 1) * perPage
        let endIndex = min(startIndex + perPage, cachedMatches.count)
        let pagedMatches = startIndex < cachedMatches.count ? Array(cachedMatches[startIndex..<endIndex]) : []

        // ✅ Step 2: Check Expiry
        if let lastUpdated = pagedMatches.first?.updatedAt, Date().timeIntervalSince(lastUpdated) < MatchService.cacheExpiryInterval,
           !pagedMatches.isEmpty  {
            return pagedMatches // ✅ Use Cached Data if Not Expired
        } else {
            // ✅ Cache Expired - Delete All Matches
            try deleteAllMatches(context: context)
        }

        // ✅ Step 3: Fetch from API if Cache Expired
        let urlString = Constants.localhost + "/matches/?page=\(page)&perPage=\(perPage)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(ReceivedMatchesResponse.self, from: data)

        // ✅ Step 4: Clear Old Data & Insert New Matches
        try context.transaction {

            for match in decodedResponse.receivedMatches {
                let matchEntity = MatchEntity(
                    id: match.id,
                    status: match.status,
                    initiator: match.initiator != nil ? ProfileEntity(id: match.initiator!.id , name : match.initiator!.name , photo:    match.initiator!.photo , dob: match.initiator!.dob )  : nil,
                    participants: match.participants?.map { ProfileEntity(id: $0.id) } ?? [],
                    updatedAt: Date() // ✅ Update Cache Timestamp
                )
                context.insert(matchEntity)
            }
        }

        return try context.fetch(fetchDescriptor) // ✅ Return Updated Cache

    }
    
    func deleteAllMatches(context: ModelContext) throws {
        let fetchDescriptor = FetchDescriptor<MatchEntity>()
        
        let allMatches: [MatchEntity] = try context.fetch(fetchDescriptor)
        
        try context.transaction {
            for match in allMatches {
                context.delete(match)
            }
        }
    }

}



