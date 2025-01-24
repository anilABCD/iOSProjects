//
//  MessagingScreen.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 21/06/24.
//

import Foundation
import SwiftUI
import PhotosUI


struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var tokenManger : TokenManager;
  
    let profile: Profile?
    let photoUrl : String
    @Binding var hideTabBar : Bool;
    let imageSize = 45.0
    
    var body: some View {
        Button(action: {
            
            hideTabBar = false ;
            self.presentationMode.wrappedValue.dismiss()
            
            
        }) {
            HStack {
                
                HStack {
                    
                    // Back arrow
                                  Image(systemName: "chevron.left")
                                      .resizable()
                                      .aspectRatio(contentMode: .fit)
                                      .frame(width: 21.0, height: 21.0)
                                      .padding(.trailing, 10) // Space between arrow and profile name
                                  
                    
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
    var onBackAction: () -> Void
    @Binding var hideTabBar : Bool ;
    @State var chat: Chat? // The chat data
    @State var messages: [Chat.Message] = [] // The messages to displ
    
    @State var isLoading: Bool = false
    @State var error: String?
    
    @State private var newMessage: String = ""
    
    @ObservedObject var webSocketManager : WebSocketManager ;
    
    @State private var selectedItem: PhotosPickerItem? = nil
      @State private var selectedImage: UIImage? = nil
    
    @State private var selectedImageURL: URL? = nil
    @State private var refreshID = UUID() // Unique ID to force the update

    @State private var showImageViewer: Bool = false
  
    func removeNumberInParenthesesFromMonth(from text: String) -> String {
     
        let regex = try! NSRegularExpression(pattern: "\\(\\s*\\d+\\s*\\)", options: [])
        
        // Use NSRange for the entire string
        let range = NSRange(location: 0, length: text.utf16.count)
        
        // Replace the pattern with an empty string
        let result = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        
        return result
        
    }
    
    // Function to remove any pattern like "( number )"
     func removeNumberInParentheses(from text: String) -> String {
         // Use regular expression to match "( number )" with optional spaces
         
         // Array of keywords to check
//             let keywords = ["Today", "Yesterday"]
//             
//             // Check if the text contains any of the keywords
//             if keywords.contains(where: { text.contains($0) }) {
      
             let regex = try! NSRegularExpression(pattern: "\\(\\s*\\d+\\s*\\)", options: [])
             
             // Use NSRange for the entire string
             let range = NSRange(location: 0, length: text.utf16.count)
             
             // Replace the pattern with an empty string
             let result = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
             
             return result
         
             
//          }
//         else{
//             
//             
//                // Regex pattern to match ( 0 followed by anything ) and capture the first 0
//                  let regex = try! NSRegularExpression(pattern: "\\(\\s*0(\\d*)\\s*\\)", options: [])
//             // Replace the match, keeping the rest of the number intact
//                 let range = NSRange(location: 0, length: text.utf16.count)
//                 let result = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "( $1 )")
//                 
//                 return result.trimmingCharacters(in: .whitespacesAndNewlines) // Clean up extra spaces
//         
//          
//         }
     }
    
    // Function to mark messages as delivered
    func markMessagesAsDelivered(upTo givenTimestamp: Date) {
        messages = messages.map { message in
            if message.timestamp <= givenTimestamp {
                var updatedMessage = message
                updatedMessage.delivered = true
                return updatedMessage
            }
            return message
        }
    }

     
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
    
    
    private func messageStatus( otherUserId : String , message : Chat.Message) -> String {
        if !message.delivered { // Replace with actual delivery check logic
            return "✓" // Not Delivered
        } else if message.isRead(by: otherUserId) {
            return "✓✓" // Delivered and Read
        } else {
            return "✓✓" // Delivered but Not Read
        }
    }
    
    // Group messages by Year, Month, Weekday
    func groupMessagesByDate(_ messages: [Chat.Message]) -> [String: [String: [String: [Chat.Message]]]] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Start of the current day
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)! // Start of yesterday
           
        return Dictionary(grouping: messages) { message -> String in
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: message.timestamp)
        }.mapValues { yearGroup in
            Dictionary(grouping: yearGroup) { message -> String in
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "MMMM" // Full month name
                
                let paddedNumber = String(format: "%02d", Calendar.current.component(.month, from: message.timestamp ))
                
                return "( \(paddedNumber) ) \(monthFormatter.string(from: message.timestamp)) "
              
            }.mapValues { monthGroup in
                Dictionary(grouping: monthGroup) { message -> String in
                    let weekdayFormatter = DateFormatter()
                            
                    weekdayFormatter.dateFormat = "E, d MMM" // Short weekday, day, and month
                    
                    let formattedDate = weekdayFormatter.string(from: message.timestamp)
                                  
                    let paddedNumber = String(format: "%02d", Calendar.current.component(.day, from: message.timestamp))
                    // Check if the message is from today
                    if calendar.isDate(message.timestamp, inSameDayAs: today) {
                        return "( \(paddedNumber) ) Today"
                    }
                    // Check if the message is from yesterday
                    if calendar.isDate(message.timestamp, inSameDayAs: yesterday) {
                        return "( \(paddedNumber) ) Yesterday"
                    }
                   
                    // Otherwise, return the weekday name
                    return "( \(paddedNumber) ) \(weekdayFormatter.string(from: message.timestamp)) "
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
                                           ForEach(groupedMessages.keys.sorted(by: >), id: \.self) { year in
                                               
                                               VStack {
                                                   Section(header: Text(removeNumberInParentheses(from : year)).font(.largeTitle)) {
                                                       // Iterate through Month groups
                                                       ForEach(groupedMessages[year]?.keys.sorted() ?? [], id: \.self) { month in
                                                           VStack {
                                                               Section(header: Text(removeNumberInParenthesesFromMonth(from : month)).font(.title2)) {
                                                                   // Iterate through Weekday groups
                                                                   ForEach(groupedMessages[year]?[month]?.keys.sorted() ?? [], id: \.self) { weekday in
                                                                       Section(header: Text(removeNumberInParentheses(from : weekday)).font(.headline)) {
                                                                           // Safely unwrap and reverse messages
                                                                           if let messages = groupedMessages[year]?[month]?[weekday] {
                                                                               ForEach(messages.reversed(), id: \.id) { message in
                                                                                   HStack {
                                                                                    
                                                                                       if message.sender == tokenManger.userId {
                                                                                           Spacer()
                                                                                           
                                                                                           VStack {
                                                                                               
                                                                                               HStack {
                                                                                                   Spacer() // Push the message to the right
                                                                                                  
//                                                                                                   
                                                                                                   if let imageUrl = message.image, let url = URL(string: "\(tokenManger.localhost)/images/\(imageUrl)") {
                                                                                                                  AsyncImage(url: url) { phase in
                                                                                                                      switch phase {
                                                                                                                      case .empty:
                                                                                                                          ProgressView()
                                                                                                                              .progressViewStyle(CircularProgressViewStyle())
                                                                                                                              .frame(width: 50, height: 50)
                                                                                                                      case .success(let img):
                                                                                                                          img
                                                                                                                              .resizable()
//                                                                                                                              .scaledToFit()
                                                                                                                              .frame(width: 150, height: 150)
                                                                                                                              .onTapGesture {
                                                                                                                                  // Update the selected image URL
                                                                                                                                 print( "\(url)" )
                                                                                                                                  print( "\(url)" )
                                                                                                                                  self.showImageViewer = true // Show image viewer
                                                                                                                              
                                                                                                                          
                                                                                                                                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                                                                                                      
                                                                                                                                      
                                                                                                                                          selectedImageURL = url // Set new URL
                                                                                                                                     
                                                                                                                                  }
                                                                                                                              }
                                                                                                                             
                                                                                                                      case .failure:
                                                                                                                          Text("Failed to load image")
                                                                                                                              .foregroundColor(.red)
                                                                                                                      @unknown default:
                                                                                                                          EmptyView()
                                                                                                                      }
                                                                                                                  }
                                                                                                              }
                                                                                                          
                                                                                                   else {
                                                                                                       Text(message.text)
                                                                                                           .padding()
                                                                                                           .background(Color.blue.opacity(0.2))
                                                                                                           .cornerRadius(10)
                                                                                                   }
//                                                                                                   
                                                                                                 
                                                                                                   // Show read status for messages sent by the current user
                                                                                               }
                                                                                               HStack(spacing: 5) {
                                                                                                   
                                                                                                   Spacer() // Push the message to the right
                                                                                                   Text(message.timestamp, style: .time)
                                                                                                       .font(.caption2)
                                                                                                       .foregroundColor(.gray)
                                                                                                   Text( messageStatus(otherUserId: profile?.id ?? "" , message: message) )
                                                                                                       .font(.caption2)
                                                                                                       .foregroundColor(message.isRead(by: profile?.id ?? "") ? .green : .gray)
                                                                                                   
                                                                                                   // Optionally, show a timestamp or other info here
                                                                                                                                        }
                                                                                           }.frame(maxWidth: .infinity, alignment: .trailing) // Align the text to the right
                                                                                       
                                                                                                            
                                                                                           
                                                                                       } else {
                                                                                           
                                                                                           VStack {
                                                                                               
                                                                                               HStack {
                                                                                                   if let imageUrl = message.image, let url = URL(string: "\(tokenManger.localhost)/images/\(imageUrl)") {
                                                                                                                  AsyncImage(url: url) { phase in
                                                                                                                      switch phase {
                                                                                                                      case .empty:
                                                                                                                          ProgressView()
                                                                                                                              .progressViewStyle(CircularProgressViewStyle())
                                                                                                                              .frame(width: 50, height: 50)
                                                                                                                      case .success(let img):
                                                                                                                          img
                                                                                                                              .resizable()
                                                                                                                              .frame(width: 150, height: 150)
                                                                                                                              .onTapGesture {
                                                                                                                                  selectedImageURL = url // Set new URL
                                                                                                                                  
                                                                                                                              }
                                                                                                                      case .failure:
                                                                                                                          Text("Failed to load image")
                                                                                                                              .foregroundColor(.red)
                                                                                                                      @unknown default:
                                                                                                                          EmptyView()
                                                                                                                      }
                                                                                                                  }
                                                                                                              }
                                                                                                          
                                                                                                   else {
                                                                                                       Text(message.text)
                                                                                                           .padding()
                                                                                                           .background(Color.blue.opacity(0.2))
                                                                                                           .cornerRadius(10)
                                                                                                   }
                                                                                                   
                                                                                                   Spacer() // Push the message to the left
                                                                                                   
                                                                                               }
                                                                                               
                                                                                               HStack{
                                                                                                  
                                                                                                   // Optionally, show a timestamp or other info here
                                                                                                   Text(message.timestamp, style: .time)
                                                                                                       .font(.caption2)
                                                                                                       .foregroundColor(.gray)
                                                                                                   
                                                                                                   
                                                                                                   Spacer() // Push the message to the left
                                                                                               }
                                                                                              
                                                                                           }
                                                                                       
                                                                                           
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
                                       .onChange(of: selectedImageURL ) { newValue in
                                           
                                           if let imageURL = newValue {
                                               
                                               showImageViewer = true;
                                           }
                                           
                                       }
                                       .onChange(of: webSocketManager.messages.count) { _ in
                                           
                                           let message = webSocketManager.messages.last
                                           if let sender = message?["sender"] as? String, let messageText = message?["text"] as? String , let timeStamp = message?["timestamp"]  as? String {
                                               // Handle image, it could be null
                                                     let image = message?["image"] as? String // If image is null, this will be nil
                                                     
                                               let newMessage = Chat.Message( sender: sender, text: messageText, timestamp: timeStamp , image : image )
                                               
                                               
                                               DispatchQueue.main.async {
                                                   
                                                   messages.insert(newMessage , at : 0);
                                                   
                                               }
                                           }
                                       }
//                                       .onReceive(webSocketManager.$deliverdUserIdAndTimeStamp) { deliverdUserIdAndTimeStamp in
//                                           // Safely extract values from the dictionary
//                                           guard
//                                               let receiverId = deliverdUserIdAndTimeStamp["receiverByUserId"] as? String,
//                                               receiverId == profile?.id,
//                                               let timestamp = deliverdUserIdAndTimeStamp["timestamp"] as? Date
//                                           else {
//                                               return // Return early if the required values are missing or invalid
//                                           }
//
//                                           // If conditions pass, update the UI on the main thread
//                                           DispatchQueue.main.async {
//                                               markMessagesAsDelivered(upTo: timestamp)
//                                           }
//                                       }
                            } .sheet(isPresented: $showImageViewer) {
                                
                                 
                                    AsyncImageViewer(imageURL: $selectedImageURL).id(refreshID) .onAppear {
                                        print("Sheet appeared with URL: \(String(describing: selectedImageURL))")
                                    }
                                    .onDisappear {
                                        print("Sheet disappeared")
                                    } // Use refreshID to force re-render
                               
                               
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
                        webSocketManager.otherUserId = profile?.objectId.value ?? "" ;
                        
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
                   
                }.onTapGesture {
                    UIApplication.shared.dismissKeyboard()
                }.onDisappear(){
                    onBackAction()
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        
                        
                        if let selectedImageeee = selectedImage {
                            
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 24))
                                    .padding(.leading)
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        selectedImage = uiImage
                                        //                                               let newMessage = ChatMessage(id: UUID(), text: "", image: uiImage)
                                        //                                               messages.append(newMessage)
                                    }
                                }
                                
                            }
                        }
                        
                        
                        if let selectedImage = selectedImage {
                            
                            HStack {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                
                                
                                Button(action: {
                                    
                                    self.selectedImage = nil
                                    self.selectedItem = nil
                                    
                                }) {
                                    Text("X")
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                    
                    
                    HStack {
                        
                        if let selectedImage = selectedImage {
                        }
                        else {
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 24))
                                    .padding(.leading)
                                
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        selectedImage = uiImage
                                        //                                               let newMessage = ChatMessage(id: UUID(), text: "", image: uiImage)
                                        //                                               messages.append(newMessage)
                                    }
                                }
                            }
                        }
                        
                        VStack {
                            
                            HStack {
                                
                                if let selectedImage = selectedImage {
                                    
                                }
                                else{
                                    TextField("Type a message...", text: $newMessage)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                
                                Button(action: {
                                    
                                    DispatchQueue.main.async {
                                        print("sending message", self.newMessage)
                                        print ( "image base 64" )
                                        print ( "image base 64" , self.selectedImage?.toBase64() ?? "")
                                        
                                        self.webSocketManager.sendMessage(  self.newMessage , imageBase64: self.selectedImage?.toBase64() ?? "" , chatId: self.chat?.id ?? "" , senderId: tokenManger.userId , user2: profile?.id ?? "" )
                                        
                                        
                                        print(" basex " , self.selectedImage?.toBase64() ?? "")
                                        
                                        
                                        self.newMessage = ""
                                        
                                        self.selectedImage = nil
                                        self.selectedItem = nil
                                    }
                                    
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
                        }
                        
                    }
                }
                
                .padding(.bottom , tokenManger.isKeyboardOpen ? 4 : 45)
                
            }
            .onAppear(){
                hideTabBar = true
            }
          
            
        } .navigationBarTitle("") .navigationBarItems(leading: CustomBackButton(profile: profile , photoUrl: photoUrl, hideTabBar: $hideTabBar  )).frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .topLeading).navigationBarBackButtonHidden(true)
    }
}


struct AsyncImageViewer: View {
    @Binding var imageURL: URL?
    @Environment(\.dismiss) var dismiss
       
    var body: some View {
       
        ZStack {
                
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            
                    case .failure:
                        Text("Failed to load image")
                            .foregroundColor(.red)
                    @unknown default:
                        EmptyView()
                    }
                }
                
            // Close Button
                                   VStack {
                                       HStack {
                                           Spacer()
                                           Button(action: {
                                               dismiss()
                                           }) {
                                               Image(systemName: "xmark.circle.fill")
                                                   .resizable()
                                                   .frame(width: 40, height: 40)
                                                   .foregroundColor(.red)
                                                   .padding()
                                           }
                                       }
                                       Spacer()
                                   }
                .padding()
        }.onDisappear(){
            imageURL = nil
        }
       
    }
}

struct ChatViewScreenView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
    @State static var hideTabBar: Bool = false // Dummy state variable for preview

    static var previews: some View {
        ChatView(profile: nil, photoUrl: "", onBackAction: {} , hideTabBar: $hideTabBar, webSocketManager:  WebSocketManager(token: "", userId: "")).environmentObject(TokenManager())
    }
}


