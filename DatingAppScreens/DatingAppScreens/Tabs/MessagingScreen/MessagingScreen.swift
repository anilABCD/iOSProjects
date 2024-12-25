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
  
    @State private var newMessage: String = ""
    
    @ObservedObject var webSocketManager : WebSocketManager ;
    
    var body: some View {
        
        NavigationView {
            VStack {
                
               
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
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
                        }                    }
                    .padding()
                }
                
                HStack {
                    TextField("Type a message...", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        
                        // Create a JSON-like object
                               let messageObject: [String: Any] = [
                                "userId": profile?.objectId.value ?? "",
                                "message": self.newMessage
                               ]
                        
                        
                        print("sending message", messageObject)
                        
                        self.webSocketManager.sendMessage( messageObject )
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
            .onAppear(){
                webSocketManager.userId = profile?.objectId.value ?? "" ;
            }
           
            
        }.navigationBarTitle("") .navigationBarItems(leading: CustomBackButton(profile: profile, photoUrl: photoUrl )).frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .topLeading)
    }
}

struct ChatViewScreenView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        ChatView(profile: nil, photoUrl: "", webSocketManager:  WebSocketManager(token: "", userId: "")).environmentObject(TokenManager())
    }
}


