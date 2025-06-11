//
//  MatchViewModel.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 30/03/25.
//

import SwiftUI
import SwiftData



@MainActor
class MatchViewModel: ObservableObject , Identifiable {

    let id: UUID = UUID()
    
    @Published var isLoadingReceived = false
    @Published var isLoadingSent = false
    
    
    @Published var errorMessage: String?
    @Published var hasMoreReceived = true
    @Published var hasMoreSent = true
    @Published var receivedMatches: [MatchEntity] = [] // ✅ Store received matches
    @Published var sentMatches: [MatchEntity] = [] // ✅ Store sent matches

    private var page = 1
    private let pageSize = 10
    let modelContext: ModelContext

    init(modelContext: ModelContext , accessToken : String) {
        
        MatchService.setAccessToken(accessToken)
        
        self.modelContext = modelContext
        Task {
            
            await loadRecivedMatches( page: 1)
            
        }
        
        Task {
           
            await loadSentMatches(page: 1)
            
        }
    }


    func loadRecivedMatches( page: Int) async {
        guard !isLoadingReceived else { return }
        isLoadingReceived = true

        do {

            print ("Matches Received STARTED:")
            
            let matches = try await MatchService.shared.fetchMatchesReceived(page: page, perPage: pageSize, context: modelContext)

            
            print ("Matches Received: \(matches)")
            
            if page == 1 {
                DispatchQueue.main.async {
                    self.receivedMatches = matches // ✅ Assigning to `@Published` should update UI
                }
                for match in matches {
                    print ("Match ID: \(match.id)")
                }
            } else {

                let uniqueMatches = matches.filter { match in
                    !receivedMatches.contains { $0.id == match.id } // ✅ Avoid Duplicates
                }
                
                DispatchQueue.main.async {
                    self.receivedMatches.append(contentsOf: uniqueMatches)
                }
               
            }

            hasMoreReceived = matches.count == pageSize
            self.page += 1
            
            // ✅ Force UI update
                        DispatchQueue.main.async {
                            self.objectWillChange.send()
                        }


        } catch {
            errorMessage = "Failed to load matches: \(error.localizedDescription)"
        }

        isLoadingReceived = false
    }

    
    
    
    func loadSentMatches( page: Int) async {
        guard !isLoadingSent else { return }
        isLoadingSent = true

        do {

            print ("Matches Sent STARTED:")
            
            let matches = try await MatchService.shared.fetchMatchesSent(page: page, perPage: pageSize, context: modelContext)

            
            print ("Matches Sent: \(matches)")
            
            if page == 1 {
                DispatchQueue.main.async {
                    self.sentMatches = matches // ✅ Assigning to `@Published` should update UI
                }
                for match in matches {
                    print ("Match ID: \(match.id)")
                }
            } else {

                let uniqueMatches = matches.filter { match in
                    !sentMatches.contains { $0.id == match.id } // ✅ Avoid Duplicates
                }
                
                DispatchQueue.main.async {
                    self.sentMatches.append(contentsOf: uniqueMatches)
                }
               
            }

            hasMoreSent = matches.count == pageSize
            self.page += 1
            
            // ✅ Force UI update
                        DispatchQueue.main.async {
                            self.objectWillChange.send()
                        }


        } catch {
            errorMessage = "Failed to load matches: \(error.localizedDescription)"
        }

        isLoadingSent = false
    }
    
    /// ✅ Load More Matches for Pagination
    func loadMoreReceived() {
        Task {
            if hasMoreReceived {
                await loadRecivedMatches( page: page)
            }
        }
    }
    
    /// ✅ Load More Matches for Pagination
    func loadMoreSent() {
        Task {
            if hasMoreSent {
                await loadSentMatches( page: page)
            }
        }
    }
}






