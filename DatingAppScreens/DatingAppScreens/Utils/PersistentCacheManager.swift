//
//  PersistentCacheManager.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 03/01/25.
//

import Foundation

class PersistentCacheManager {
    static let shared = PersistentCacheManager()
    
    private init() {}
    
    private func getFilePath(forKey key: String) -> URL {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(key)
    }

    func saveJSON<T: Encodable>(_ object: T, forKey key: String) {
        let filePath = getFilePath(forKey: key)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: filePath)
            print("JSON object saved successfully at \(filePath)")
        } catch {
            print("Error saving JSON object: \(error)")
        }
    }

    func loadJSON<T: Decodable>(forKey key: String, as type: T.Type) -> T? {
        let filePath = getFilePath(forKey: key)
        do {
            let data = try Data(contentsOf: filePath)
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch {
            print("Error loading JSON object: \(error)")
            return nil
        }
    }

    func deleteData(forKey key: String) {
        let filePath = getFilePath(forKey: key)
        do {
            try FileManager.default.removeItem(at: filePath)
            print("Data deleted successfully.")
        } catch {
            print("Error deleting data: \(error)")
        }
    }

    func isDataCached(forKey key: String) -> Bool {
        let filePath = getFilePath( forKey: key)
        return FileManager.default.fileExists(atPath: filePath.path)
    }
}






/*
 
  Example : 

import SwiftUI


struct Userx: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}

class APIService {
    static let shared = APIService()

    private init() {}

    func getUsers() async -> [Userx] {
        let cacheKey = "usersCacheKey"

        // Check if cached data exists
        if let cachedUsers = PersistentCacheManager.shared.loadJSON(forKey: cacheKey, as: [Userx].self) {
            print("Loaded users from cache.")
            return cachedUsers
        }

        // Fetch from API
        print("Fetching users from API...")
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return []
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let users = try JSONDecoder().decode([Userx].self, from: data)

            // Cache the fetched data
            PersistentCacheManager.shared.saveJSON(users, forKey: cacheKey)

            return users
        } catch {
            print("Error fetching or decoding users: \(error)")
            return []
        }
    }
}
 
struct UserListView: View {
    @State private var users: [Userx] = []
    @State private var isLoading: Bool = true

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading users...")
            } else if users.isEmpty {
                Text("No users found.")
            } else {
                List(users) { user in
                    VStack(alignment: .leading) {
                        Text(user.name).font(.headline)
                        Text(user.email).font(.subheadline).foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await loadUsers()
            }
        }
    }

    private func loadUsers() async {
        self.isLoading = true
        self.users = await APIService.shared.getUsers()
        self.isLoading = false
    }
}


 */



