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
    @State var isPopupPresented = false // 1
    @State private var selectedPerson: String = "John Doe"
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    init(){
        
    }
    
    
    @State private var profiles : [Profile] = [Profile(objectId: ObjectId(from:"hello"), name: "")];
    
    
    
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
                       
                        ScrollView  {
                            
                            VStack {
                                
                                ZStack {
                                    GeometryReader { geometry in
                                           AsyncImage(url: URL(string: "\(tokenManger.localhost)/images/\(profiles[index].photo ?? "image.jpg")")) { image in
                                               image
                                                   .resizable()
                                                   .scaledToFill()
                                                   .frame(width: geometry.size.width, height: 500)
                                                   .clipped()
                                                   .cornerRadius(10)
                                                   .overlay(
                                                                      RoundedRectangle(cornerRadius: 20)
                                                                          .stroke(Color.clear, lineWidth: 0)
                                                                          .shadow(color: Color.blue.opacity(0.7), radius: 10, x: 0, y: 0)
                                                                  )
                                                                  .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 0)
                                           } placeholder: {
                                               ProgressView()
                                                   .frame(width: geometry.size.width, height: 500)
                                           }
                                       }
                                    
                                    VStack( alignment: .leading , spacing: 5 ) {
                                        
                                        Spacer().frame(maxHeight:.infinity)
                                       
//                                        VStack{
//                                            Spacer()
                                        GrayCard(title: "Name", content: profiles[index].name ?? "")
                                                         
                                         
                                            GrayCard(title: "Experience", content: "\(profiles[index].experience ?? 0)")
                                                         
                                            GrayCard(title: "Technology", content: profiles[index].technology?.joined(separator: ", ") ?? "")
                                                         
                                         
                                          
                                            
//                                        }
//                                        .frame( maxHeight: .infinity, alignment: .leading)
//                                        .padding()
//                                       
//                                        .cornerRadius(10)
//                                        .shadow(radius: 2)
                                        //                                }
                                        //                                .padding()
                                        
                                     
                                    }.frame(maxWidth : .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                        .padding()
                                }.background(Color.blue.opacity(0.01))
                                
                                     
                                } .frame(height: 500).padding()

//                                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible())], spacing: 20) {
//                                    
//aaaaa
                              
                            Text("Profile Headline:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.bold)
                                .padding()
                        }.scrollIndicators(.hidden)
                        
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
                            
                            Button(action: {
                                
                                withAnimation {
                                                 isPopupPresented = true
                                             }
                            }) {
                                Image(systemName: "message.fill")
                                    .font(.title)
                                
                                
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            @State var showingPopup = false // 1

                        }
                        .padding(.horizontal)
                        
                       
                    }
                    .tag(index)
                }.gesture(DragGesture().onChanged { _ in }) // Disable swipe gestures
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never /* turn of dot page index buttons */))
       
        }  
        .popup(isPresented: $isPopupPresented) {
            ChatPopupView(isPresented: $isPopupPresented, profile: profiles[currentIndex] )
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

extension View {
    func popup<PopupContent: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> PopupContent) -> some View {
        self.modifier(Popup(isPresented: isPresented, content: content))
    }
}



struct Popup<PopupContent: View>: ViewModifier {
    let isPresented: Binding<Bool>
    let content: () -> PopupContent

    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isPresented.wrappedValue {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        self.content()
                            .frame(width: 300, height: 200)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 20)
                            .transition(.scale)
                    }
                }
            )
    }
}



struct  MatchesNewDevsView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        MatchesNewDevsView().environmentObject(TokenManager())
    }
}


struct GrayCard: View {
    var title: String
    var content: String
    
    var body: some View {
      
            HStack ( ) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                 
                Text(content)
                    .font(.caption)
                    .foregroundColor(.white)
                   
              
            }.frame( maxWidth:.infinity, alignment: .topLeading) 
            
//            .background(Color.gray.opacity(0.5))
       
    }
}

struct ChatPopupView: View {
    @Binding var isPresented: Bool
     var profile: Profile
    @State private var message: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Send a message to \(String(describing: profile.name ?? "" ))")
                .font(.headline)
            
            TextField("Enter your message", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button(action: {
                    // Handle send action
                    print("Message sent to \(String(describing: profile.name)): \(message)")
                    
                    withAnimation {
                        
                        isPresented = false
                    }
                    
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    withAnimation {
                        
                        isPresented = false
                    }
                }) {
                    Text("Cancel")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}

