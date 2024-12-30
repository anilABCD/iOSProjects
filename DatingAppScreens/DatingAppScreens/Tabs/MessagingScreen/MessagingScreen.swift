//
//  MessagingScreen.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 21/06/24.
//

import Foundation
import SwiftUI


struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    let profile: Profile?
    let photoUrl : String
    
    let imageSize = 45.0
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            
            
        }) {
            HStack {
                
                HStack {
                    
                    if let photo = profile?.photo {
                        let photoURLString = "resized-\(photo)"
                        if let url = URL(string: "\(photoUrl)/\(photoURLString)") {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: imageSize, height: imageSize)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageSize, height: imageSize)
                                        .clipShape(Circle())
                                case .failure:
                                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: imageSize, height: imageSize )
                                        .clipShape(Circle())
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                        }
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                    }
                    
                    Text(profile?.name ?? "")
                }
                
                Spacer()
            }
            
        }
    }
}



struct ChatView: View {
    
    @EnvironmentObject private var tokenManger : TokenManager
    let profile: Profile?
    let photoUrl : String
    
    @State var chat: Chat? // The chat data
    @State var messages: [Chat.Message] = [] // The messages to displ
    
    @State var isLoading: Bool = false
    @State var error: String?
    
    @State private var newMessage: String = ""
    
    @ObservedObject var webSocketManager : WebSocketManager ;
    
    
    
    func fetchChats () async
    {
        
        self.isLoading = true
        self.error = nil
        
        let baseURL = "\(tokenManger.localhost)/messages/chats"
        let accessToken = tokenManger.accessToken
        let parameters :  [ String:String]? = ["user1": tokenManger.userId , "user2": profile?.objectId.value ?? ""]
        
        do {
            let request = try createURLRequest(
                method: "GET",
                baseURL: baseURL,
                accessToken: accessToken,
                data: Optional<Data>.none, // No body data for GET request
                parameters: parameters
            )
            

                do {
                    let chat: Chat = try await fetchData(from: request)
                    
                    print (chat)
                    DispatchQueue.main.async {
                        self.chat = chat
                        self.messages = chat.messages
                        self.isLoading = false
                        
                        print (self.messages)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.error = "Failed to fetch chat: \(error)"
                        self.isLoading = false
                    }
                }
                
              
       
        } catch {
            self.error = "Failed to create request: \(error)"
            self.isLoading = false
        }
        
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        if isLoading {
                            ProgressView("Loading chat...")
                        } else if let error = error {
                            Text(error)
                                .foregroundColor(.red)
                        } else {
                            List(messages) { message in
                                HStack {
                                    if message.sender == tokenManger.userId {
                                        Spacer()
                                        Text(message.text)
                                            .padding()
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(10)
                                    } else {
                                        Text(message.text)
                                            .padding()
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                        Spacer()
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            
                            
                            
                            ForEach(webSocketManager.messages.indices, id: \.self) { index in
                                let message = webSocketManager.messages[index]
                                if let userId = message["userId"] as? String, let messageText = message["message"] as? String {
                                    HStack {
                                        if userId == tokenManger.userId {
                                            
                                            Text(messageText)
                                                .padding(10)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                            
                                            Spacer() // Push received messages to the left
                                        } else {
                                            
                                            Spacer() // Push current user's messages to the right
                                            Text(messageText)
                                                .padding(10)
                                                .background(Color.gray)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                            
                                        }
                                    }
                                }
                                
                            }
                            .padding()
                        }
                        
                     
                    }
                    .onAppear(){
                        webSocketManager.userId = profile?.objectId.value ?? "" ;
                        
                        Task {
                        
                            await fetchChats()
                            
                        }
                    }
                    
                    
                }.navigationBarTitle("") .navigationBarItems(leading: CustomBackButton(profile: profile, photoUrl: photoUrl )).frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .topLeading)
                
                Spacer()
                
                HStack {
                    TextField("Type a message...", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        
                        print("sending message", self.newMessage)
                        
                        self.webSocketManager.sendMessage(  self.newMessage , chatId: self.chat?.id ?? "" , senderId: tokenManger.userId )
                        self.newMessage = ""
                    }) {
                        Text("Send")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
                .padding()
                
            }
        }
    }
}

struct ChatViewScreenView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        ChatView(profile: nil, photoUrl: "", webSocketManager:  WebSocketManager(token: "", userId: "")).environmentObject(TokenManager())
    }
}


