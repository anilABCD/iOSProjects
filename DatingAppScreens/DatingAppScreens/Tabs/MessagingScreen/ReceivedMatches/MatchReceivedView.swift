import SwiftUI
import SwiftData

struct MatchReceivedListView: View {
    @StateObject var viewModel: MatchViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.receivedMatches, id: \.id) { match in
                    MatchRowView(match: match)
                        .onAppear {
                            if match == viewModel.receivedMatches.last { // ✅ Load more when reaching last item
                                viewModel.loadMore()
                            }
                        }
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading more...") // ✅ Show loader while fetching more matches
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .refreshable {
                Task {
                    await viewModel.loadRecivedMatches(page: 1) // ✅ Refresh list
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Something went wrong."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}


struct MatchRowView: View {
    let match: MatchEntity

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Match ID: \(match.id)")
                    .font(.headline)

                Text("Status: \(match.status)")
                    .foregroundColor(.gray)

                if let matchedUser = match.getOtherParticipant(currentUserID: "currentUserID") {
                    Text("Matched with: \(matchedUser.name)")
                        .foregroundColor(.blue)
                }
            }
            Spacer()
            Text("\(match.updatedAt, style: .date)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
