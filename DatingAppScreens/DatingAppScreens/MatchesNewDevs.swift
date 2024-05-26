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
    var photo : String?
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
        case photo
        case experience
        case technology
    
    }
}

struct MatchesNewDevsView: View {
    
    @State private var currentIndex = 0 ;
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    init(){
        
    }
    
    
    @State private var profiles = [Profile(objectId: ObjectId(from:"hello"), name: "")];
    
    
    
    func fetchProfiles() async throws {
        
        
        let data = MatchesFilter(technologies: tokenManger.technologies , minExperience: 0, maxExperience: 5)
        
        print (data)
        
        guard let url = URL(string: "\(tokenManger.localhost)/profiles/matches") else {
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

                DispatchQueue.main.async {
                    
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
                            
                            VStack {
                                
                                VStack {
                                    GeometryReader { geometry in
                                           AsyncImage(url: URL(string: "\(tokenManger.localhost)/images/\(profiles[index].photo ?? "image.jpg")")) { image in
                                               image
                                                   .resizable()
                                                   .scaledToFill()
                                                   .frame(width: geometry.size.width, height: 300)
                                                   .clipped()
                                                   .cornerRadius(10)
                                           } placeholder: {
                                               ProgressView()
                                                   .frame(width: geometry.size.width, height: 300)
                                           }
                                       }
                                     
                                } .frame(height: 300).padding()

//                                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible())], spacing: 20) {
//                                    
//aaaaa
                                VStack {
                                    HStack {
                                        
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Name:")
                                                .font(.headline)
                                            Text(profiles[index].name ?? "")
                                            
                                        }

                                        Spacer()
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Experience:")
                                                .font(.headline)
                                            Text("\(profiles[index].experience ?? 0)")
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Technology:")
                                                .font(.headline)
                                            
                                            Text(profiles[index].technology?.joined(separator: ", ") ?? "")
                                            
                                        }
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
                                    .padding()
                                   
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                    //                                }
                                    //                                .padding()
                                    
                                 
                                }
                            }.background(Color.blue.opacity(0.01))
                            
                            Text("Profile Headline:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.bold)
                                .padding()
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 30) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    currentIndex = min (currentIndex + 1 , profiles.count - 1)
                                    
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                            } .disabled(currentIndex == profiles.count - 1)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    currentIndex = min (currentIndex + 1 , profiles.count - 1)
                                    
                                }
                                
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title)
                            }
                            .disabled(currentIndex == profiles.count - 1)
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
                }.gesture(DragGesture().onChanged { _ in }) // Disable swipe gestures
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never /* turn of dot page index buttons */))
       
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

