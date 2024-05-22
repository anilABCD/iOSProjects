//
//  MatchesNewDevs.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import Foundation

import SwiftUI

struct ObjectId: Decodable, Hashable {
    let value: String
    
    init(from string: String) {
          self.value = string
      }
      
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let objectIdString = try container.decode(String.self)
        self.value = objectIdString
    }
}

struct Profile: Identifiable, Decodable {
    var objectId: ObjectId
    var name: String?
    var email: String?
   
    var experience: Int?
    var technology: [String]?
  
    // Computed property for Identifiable protocol
    var id: String {
        return objectId.value
    }
    
    enum CodingKeys: String, CodingKey {
        case objectId = "_id"
        case name
        case email
      
        case experience
        case technology
    
    }
}

struct MatchesNewDevsView: View {
    
    @State private var currentIndex = -1 ;
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    init(){
        
    }
    
    
    @State private var profiles = [Profile(objectId: ObjectId(from:"hello"), name: "")];
    
    
    
    func fetchProfiles() async throws {
        
        
        let data = MatchesFilter(technologies: tokenManger.technologies , minExperience: 0, maxExperience: 5)
        
        print (data)
        
        guard let url = URL(string: "http://localhost:8000/profiles/matches") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = tokenManger.accessToken;
        
        print (token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(data)
        } catch {
            print (error.localizedDescription)
            throw error
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw StringError(message: "Invalid response received")
            }
            
            if httpResponse.statusCode >= 400 {
                
                throw StringError(message: "\(httpResponse.statusCode )" )
            }
            
            do {
                print ("decode started")
                
                print (data)
                let decodedResponse = try JSONDecoder().decode([Profile].self, from: data)
                
                print ("decode ended")
                print (decodedResponse)
                DispatchQueue.main.async {
                    
                    currentIndex = -1
                    self.profiles = decodedResponse
                    
                    print(self.profiles)
                }
                
            } catch {
                
                print (error.localizedDescription)
                
                throw StringError(message: "Failed to decode response data")
            }
        }
        
        
        
    };
    
    
    
    
    var body: some View {
        
        
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(profiles.indices, id: \.self) { index in
                    VStack {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible())], spacing: 20) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Name:")
                                        .font(.headline)
                                    Text(profiles[index].name ?? "")
                                    Text("Email:")
                                        .font(.headline)
                                    Text(profiles[index].email ?? "")
                                    Text("Technology:")
                                        .font(.headline)
                                    Text(profiles[index].technology?.joined(separator: ", ") ?? "")
                                    Text("Experience:")
                                        .font(.headline)
                                    Text("\(profiles[index].experience ?? 0)")
                                }
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                            .padding()
                            Text("Profile Headline:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.bold)
                                .padding(2)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 30) {
                            Button(action: {
                                withAnimation {
                                    currentIndex = (currentIndex + 1) % profiles.count
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            
                            Button(action: {
                                withAnimation {
                                    currentIndex = (currentIndex + 1) % profiles.count
                                }
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title)
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            
                            Button(action: {}) {
                                Image(systemName: "message.fill")
                                    .font(.title)
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        }
                        .padding(.horizontal)
                        
                       
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
           
        }
        .onAppear {
            Task {
                do {
                    try await fetchProfiles()
                } catch {
                    // Handle the error
                }
            }
        }
    }
}


struct  MatchesNewDevsView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        MatchesNewDevsView().environmentObject(TokenManager())
    }
}

