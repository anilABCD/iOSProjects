


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

@MainActor
class MatchService : Service {
    private static let cacheExpiryInterval: TimeInterval = 1 * 5 // 5 minutes
    static let shared = MatchService() // ✅ Singleton Instance
    
 
    func fetchMatchesReceived(page: Int, perPage: Int , context: ModelContext) async throws -> [MatchEntity] {
        // ✅ Fetch Cached Data for This Page
        let fetchDescriptor = FetchDescriptor<MatchEntity>()
        let cachedMatches: [MatchEntity] = try context.fetch(fetchDescriptor)

        let pagedMatches = cachedMatches
            .filter { $0.pageNumber == page && $0.type == "received" }
            .sorted { $0.updatedAt > $1.updatedAt } // descending: newest first
           
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
        
        
        do {
            try context.transaction {
                for match in decodedResponse.receivedMatches {
                    
                    // ✅ Check if the initiator already exists
                    let existingInitiator = try? context.fetch(FetchDescriptor<ProfileEntity>())
                        .first(where: { $0.id == match.initiator?.id })
                    
                    let initiatorEntity: ProfileEntity? = existingInitiator ?? {
                        if let initiator = match.initiator {
                            let profile = ProfileEntity(
                                id: initiator.id,
                                name: initiator.name,
                                photo: initiator.photo,
                                dob: initiator.dob
                            )
                            context.insert(profile)  // ✅ Insert only if it doesn't exist
                            return profile
                        }
                        return nil
                    }()

                    // ✅ Check if participants already exist
                    let participantEntities: [ProfileEntity] = match.participants?.map { participant -> ProfileEntity in
                        if let existingParticipant = try? context.fetch(FetchDescriptor<ProfileEntity>())
                            .first(where: { $0.id == participant.id }) {
                            return existingParticipant
                        } else {
                            let profile = ProfileEntity(
                                id: participant.id,
                                name: participant.name,
                                photo: participant.photo,
                                dob: participant.dob
                            )
                            context.insert(profile)  // ✅ Insert only if it doesn't exist
                            return profile
                        }
                    } ?? []

                    // ✅ Check if MatchEntity already exists
                    let existingMatch = try? context.fetch(FetchDescriptor<MatchEntity>())
                        .first(where: { $0.id == match.id })

                    if existingMatch == nil {
                        let matchEntity = MatchEntity(
                            id: match.id,
                            status: match.status,
                            initiator: initiatorEntity,
                            participants: participantEntities,
                            pageNumber: page,
                            
                            updatedAt: Date() ,
                            type: "received"
                        )
                        context.insert(matchEntity)  // ✅ Insert MatchEntity only if it doesn't exist
                    }
                }
            }
            
            try context.save() // ✅ Save all changes
            print("✅ Data Saved Successfully!")

        } catch {
            print("❌ Error Saving Context: \(error)")
        }

 

       

        var result = try context.fetch(fetchDescriptor).filter { $0.pageNumber == page && $0.type == "received" } // ✅ Return Cached Page
        
        print("MatchEntity result: \(result)")
        
        return result
    }

    
    
       func fetchMatchesSent(page: Int, perPage: Int , context: ModelContext) async throws -> [MatchEntity] {
           // ✅ Fetch Cached Data for This Page
           let fetchDescriptor = FetchDescriptor<MatchEntity>()
           let cachedMatches: [MatchEntity] = try context.fetch(fetchDescriptor)

           // ✅ Filter Cached Data for This Page
           let pagedMatches = cachedMatches.filter { $0.pageNumber == page && $0.type == "sent" }
               .sorted { $0.updatedAt > $1.updatedAt } // descending: newest first
           // ✅ Check Expiry for Cached Data
           if let lastUpdated = pagedMatches.first?.updatedAt, Date().timeIntervalSince(lastUpdated) < MatchService.cacheExpiryInterval,
              !pagedMatches.isEmpty  {
               return pagedMatches // ✅ Use Cached Data if Not Expired
           } else {
               // ✅ Cache Expired - Delete Only This Page
               try deleteMatchesByPage(page, context: context)
           }
           
         
           
           var data : NoDataEncodable? = nil;
           
           let urlString = Constants.localhost + "/matches/sent?page=\(page)&perPage=\(perPage)"
           var request = try createURLRequest(method: "GET", baseURL: urlString, accessToken: MatchService.accessToken ?? "", data: data, parameters: nil)
           // ✅ Fetch from API if Cache Expired
    
               var decodedResponse : SentMatchesResponse = try await fetchData(from: request)
           print("✅ sent decodedResponse Successfully!")
           
           do {
               try context.transaction {
                   for match in decodedResponse.sentMatches {
                       
                       // ✅ Check if the initiator already exists
                       let existingInitiator = try? context.fetch(FetchDescriptor<ProfileEntity>())
                           .first(where: { $0.id == match.initiator?.id })
                       
                       let initiatorEntity: ProfileEntity? = existingInitiator ?? {
                           if let initiator = match.initiator {
                               let profile = ProfileEntity(
                                   id: initiator.id,
                                   name: initiator.name,
                                   photo: initiator.photo,
                                   dob: initiator.dob
                               )
                               context.insert(profile)  // ✅ Insert only if it doesn't exist
                               return profile
                           }
                           return nil
                       }()

                       // ✅ Check if participants already exist
                       let participantEntities: [ProfileEntity] = match.participants?.map { participant -> ProfileEntity in
                           if let existingParticipant = try? context.fetch(FetchDescriptor<ProfileEntity>())
                               .first(where: { $0.id == participant.id }) {
                               return existingParticipant
                           } else {
                               let profile = ProfileEntity(
                                   id: participant.id,
                                   name: participant.name,
                                   photo: participant.photo,
                                   dob: participant.dob
                               )
                               context.insert(profile)  // ✅ Insert only if it doesn't exist
                               return profile
                           }
                       } ?? []

                       // ✅ Check if MatchEntity already exists
                       let existingMatch = try? context.fetch(FetchDescriptor<MatchEntity>())
                           .first(where: { $0.id == match.id })

                       if existingMatch == nil {
                           let matchEntity = MatchEntity(
                               id: match.id,
                               status: match.status,
                               initiator: initiatorEntity,
                               participants: participantEntities,
                               pageNumber: page,
                               
                               updatedAt: Date() ,
                               type: "sent"
                           )
                           context.insert(matchEntity)  // ✅ Insert MatchEntity only if it doesn't exist
                       }
                   }
               }
               
               try context.save() // ✅ Save all changes
               print("✅ Data Saved Successfully!")

           } catch {
               print("❌ Error Saving Context: \(error)")
           }

    

          

           var result = try context.fetch(fetchDescriptor).filter { $0.pageNumber == page && $0.type == "sent" } // ✅ Return Cached Page
           
           print("MatchEntity result start : \(result)")
           
           for item in result {
               print(item.id)
           }
           
           print("MatchEntity result: \(result)")
           
           return result
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
