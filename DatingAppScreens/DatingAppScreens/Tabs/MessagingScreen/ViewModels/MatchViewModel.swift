//
//  MatchViewModel.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 30/03/25.
//

import SwiftUI
import SwiftData

@MainActor
class MatchViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMore = true
    @Published var receivedMatches: [MatchEntity] = [] // ✅ Store received matches
    @Published var sentMatches: [MatchEntity] = [] // ✅ Store sent matches

    private var receivedPage = 1
    private var sentPage = 1
    private let pageSize = 10
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await loadMatches( page: 1)
        }
    }

    /// ✅ Load Matches from Cache or API
    func loadMatches( page: Int) async {
        guard !isLoading else { return }
        isLoading = true

        do {
            let matches = try await MatchService.shared.fetchMatches(page: page, perPage: pageSize, context: modelContext)

            if page == 1 {
                receivedMatches = matches
            } // ✅ First page replaces old data
            else {
                receivedMatches.append(contentsOf: matches)
            } // ✅ Append for pagination

                hasMore = matches.count == pageSize
                receivedPage += 1

        } catch {
            errorMessage = "Failed to load matches: \(error.localizedDescription)"
        }

        isLoading = false
    }

    /// ✅ Load More Matches for Pagination
    func loadMore(isReceived: Bool) {
        Task {
            if hasMore {
                await loadMatches( page: sentPage)
            }
        }
    }
}
