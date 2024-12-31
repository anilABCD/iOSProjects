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
                    self.chat = chat
                    print (chat)
                    DispatchQueue.main.async {
                       
                        self.messages = chat.messages.reversed()
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
    // Group messages by Year, Month, Weekday
    func groupMessagesByDate(_ messages: [Chat.Message]) -> [String: [String: [String: [Chat.Message]]]] {
            let dateFormatter = DateFormatter()

            return Dictionary(grouping: messages) { message -> String in
                dateFormatter.dateFormat = "yyyy"
                return dateFormatter.string(from: message.timestamp)
            }.mapValues { yearGroup in
                Dictionary(grouping: yearGroup) { message -> String in
                    dateFormatter.dateFormat = "MMMM" // Full month name
                    return dateFormatter.string(from: message.timestamp)
                }.mapValues { monthGroup in
                    Dictionary(grouping: monthGroup) { message -> String in
                        dateFormatter.dateFormat = "EEEE" // Weekday name
                        return dateFormatter.string(from: message.timestamp)
                    }
                }
            }
        
           
        }

    var body: some View {
        let groupedMessages = groupMessagesByDate(messages)
       
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
                            ScrollViewReader { proxy in
                                List {
                                           // Iterate through Year groups
                                           ForEach(groupedMessages.keys.sorted(), id: \.self) { year in
                                               
                                               VStack {
                                                   Section(header: Text(year).font(.largeTitle)) {
                                                       // Iterate through Month groups
                                                       ForEach(groupedMessages[year]?.keys.sorted() ?? [], id: \.self) { month in
                                                           VStack {
                                                               Section(header: Text(month).font(.title2)) {
                                                                   // Iterate through Weekday groups
                                                                   ForEach(groupedMessages[year]?[month]?.keys.sorted() ?? [], id: \.self) { weekday in
                                                                       Section(header: Text(weekday).font(.headline)) {
                                                                           // Safely unwrap and reverse messages
                                                                           if let messages = groupedMessages[year]?[month]?[weekday] {
                                                                               ForEach(messages.reversed(), id: \.id) { message in
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
                                                                                   .id(message.id) // Ensure stability
                                                                               }
                                                                           }
                                                                       }
                                                                   }
                                                               }
                                                           }
                                                           
                                                       }
                                                   }
                                                   
                                               }.rotationEffect(.degrees(180)) // Rotate the entire List
                                           }
                                       }
                                       .rotationEffect(.degrees(180)) // Rotate the entire List
                                       .listStyle(PlainListStyle())
                                
//                                .onChange(of: messages.count) { _ in
//                                    
//                                    withAnimation {
//                                       
//                                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
//                                        
//                                        print( "scroll id " , messages.last?.id)
//                                    }
//                                    
//                                }
                                .onChange(of: webSocketManager.messages.count) { _ in
                           
                                    let message = webSocketManager.messages.last
                                    if let sender = message?["sender"] as? String, let messageText = message?["text"] as? String , let timeStamp = message?["timestamp"] {
                                      
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // Adjust the format to match your string
                                        let timestampNew = dateFormatter.date(from: timeStamp as! String)
                                        
                                        
                                        let newMessage = Chat.Message( sender: sender, text: messageText, timestamp: timestampNew as! Date )

                                        
                                      DispatchQueue.main.async {

                                          messages.insert(newMessage , at : 0);
         
                                       }
                                    }
                                   
                                }
                               
                            }
                            
//                            ForEach(webSocketManager.messages.indices, id: \.self) { index in
//                                let message = webSocketManager.messages[index]
//                                if let sender = message["sender"] as? String, let messageText = message["text"] as? String {
//                                    HStack {
//                                        if sender == tokenManger.userId {
//                                            Spacer()
//                                            Text(messageText)
//                                                .padding()
//                                                .background(Color.blue.opacity(0.2))
//                                                .cornerRadius(10)
//                                        } else {
//                                            Text(messageText)
//                                                .padding()
//                                                .background(Color.gray.opacity(0.2))
//                                                .cornerRadius(10)
//                                            Spacer()
//                                        }
//                                    }
//                                }
//                                
//                            }
//                            .padding()
                        }
                        
                     
                    }
                    .onAppear(){
                        webSocketManager.userId = profile?.objectId.value ?? "" ;
                        
                        Task {
                            
                            await fetchChats()
                            
                            print ( groupedMessages)
                            print ("chat id", chat?.id)
                            if ( chat?.id != "" ) {
                                self.webSocketManager.joinChat(chatId: self.chat?.id ?? "")
                            }
                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                                
//                                messages.insert( Chat.Message( sender: "", text: "", timestamp: Date.now), at: 0)  // Insert at the start of the array
//                            }
                            
                            
                        }
                            
                            
                        
                    }
                   
                }
                
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
            
        } .navigationBarTitle("") .navigationBarItems(leading: CustomBackButton(profile: profile, photoUrl: photoUrl )).frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .topLeading)
    }
}

struct ChatViewScreenView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        ChatView(profile: nil, photoUrl: "", webSocketManager:  WebSocketManager(token: "", userId: "")).environmentObject(TokenManager())
    }
}


