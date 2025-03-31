


import Foundation
import SwiftData

class Service {
    
    private static var _accessToken: String?
    
    static var accessToken: String? {
          get { _accessToken }
      }

    static func setAccessToken(_ token: String) {
            print("Access token set.")
            _accessToken = token
    }
    
}

@Observable
class MatchService : Service {
    private static let cacheExpiryInterval: TimeInterval = 60 * 5 // 5 minutes
    static let shared = MatchService() // ✅ Singleton Instance
    
 
    @MainActor
    func fetchMatches(page: Int, perPage: Int , context: ModelContext) async throws -> [MatchEntity] {
        // ✅ Fetch Cached Data for This Page
        let fetchDescriptor = FetchDescriptor<MatchEntity>()
        let cachedMatches: [MatchEntity] = try context.fetch(fetchDescriptor)

        // ✅ Filter Cached Data for This Page
        let pagedMatches = cachedMatches.filter { $0.pageNumber == page }

        // ✅ Check Expiry for Cached Data
        if let lastUpdated = pagedMatches.first?.updatedAt, Date().timeIntervalSince(lastUpdated) < MatchService.cacheExpiryInterval,
           !pagedMatches.isEmpty  {
            return pagedMatches // ✅ Use Cached Data if Not Expired
        } else {
            // ✅ Cache Expired - Delete Only This Page
            try deleteMatchesByPage(page, context: context)
        }

        
        var data : NoDataEncodable? = nil;
        
        let urlString = Constants.localhost + "/matches/received?page=\(page)&perPage=\(perPage)"
        var request = try createURLRequest(method: "GET", baseURL: urlString, accessToken: MatchService.accessToken ?? "", data: data, parameters: nil)
        // ✅ Fetch from API if Cache Expired

        var decodedResponse : ReceivedMatchesResponse = try await fetchData(from: request)
 
        // ✅ Store the Fetched Data with Page Number
        try context.transaction {
            for match in decodedResponse.receivedMatches {
                let matchEntity = MatchEntity(
                    id: match.id,
                    status: match.status,
                    initiator: match.initiator != nil ? ProfileEntity(id: match.initiator!.id , name : match.initiator!.name , photo: match.initiator!.photo , dob: match.initiator!.dob ) : nil,
                    participants: match.participants?.map {  ProfileEntity(id: $0.id , name : $0.name , photo: $0.photo , dob: $0.dob ) } ?? [],
                    pageNumber: page, // ✅ Store Page Number
                    updatedAt: Date() // ✅ Cache Timestamp
                )
                context.insert(matchEntity)
            }
        }

        return try context.fetch(fetchDescriptor).filter { $0.pageNumber == page } // ✅ Return Cached Page
    }

    func deleteMatchesByPage(_ page: Int, context: ModelContext) throws {
        let fetchDescriptor = FetchDescriptor<MatchEntity>()
        let allMatches: [MatchEntity] = try context.fetch(fetchDescriptor)
        
        try context.transaction {
            for match in allMatches where match.pageNumber == page {
                context.delete(match)
            }
        }
    }
}
