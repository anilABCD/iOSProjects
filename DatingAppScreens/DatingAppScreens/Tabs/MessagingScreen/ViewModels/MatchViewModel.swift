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
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMore = true
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
    }

    /// ✅ Load Matches from Cache or API
    func loadRecivedMatches( page: Int) async {
        guard !isLoading else { return }
        isLoading = true

        do {

            let matches = try await MatchService.shared.fetchMatches(page: page, perPage: pageSize, context: modelContext)

            if page == 1 {
                receivedMatches = matches // ✅ First page replaces old data
            } else {

                let uniqueMatches = matches.filter { match in
                    !receivedMatches.contains { $0.id == match.id } // ✅ Avoid Duplicates
                }

                receivedMatches.append(contentsOf: uniqueMatches)
            }

            hasMore = matches.count == pageSize
            self.page += 1

        } catch {
            errorMessage = "Failed to load matches: \(error.localizedDescription)"
        }

        isLoading = false
    }

    /// ✅ Load More Matches for Pagination
    func loadMore() {
        Task {
            if hasMore {
                await loadRecivedMatches( page: page)
            }
        }
    }
}






