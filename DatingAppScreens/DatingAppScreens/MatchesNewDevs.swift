//
//  MatchesNewDevs.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import Foundation

import SwiftUI


struct Profile: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let imageName: String
    let heading: String
}

struct MatchesNewDevsView: View {
    
    
    @State private var profiles = [
        Profile(name: "John", age: 30, imageName: "menu", heading: "Profile 1"),
        Profile(name: "Alice", age: 25, imageName: "filter", heading: "Profile 2"),
        Profile(name: "Bob", age: 35, imageName: "menu", heading: "Profile 3")
    ];
    
    @State private var currentIndex = -1 ;
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            
            HStack {
                
                ForEach(profiles) { profile in
                    
                    VStack {
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible())], spacing: 20) {
                            // Image on the left
                            Image(profile.imageName )
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .cornerRadius(10)
                            
                            // Details on the right
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("Name")
                                    .font(.headline)
                                Text("John").padding(2)
                                Text("Age: 30")
                                    .font(.subheadline)
                                Text("Technology: SwiftUI")
                                    .font(.subheadline)
                                
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                        .padding()
                        
                        Text("Profile Headline : " ).frame( maxWidth: .infinity , alignment: .leading).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding(2)
                        
                        Text ("SwiftUI enthusiast looking for new opportunities.")
                            .font(.subheadline)
                            .lineLimit(nil)
                        
                        
                        Spacer()
                        
                        // Action Buttons
                        HStack(spacing: 30) {
                            Button(action: {
                                // Action for dislike
                                
                                
                                withAnimation{
                                    currentIndex = ( currentIndex + 1) % profiles.count
                                    
                                    
                                    print(currentIndex)
                                    
                                    
                                    if(profiles.count - 1 == currentIndex){
                                        currentIndex = -1 ;
                                    }
                                }
                            }) {
                                Image(systemName: "hand.thumbsdown.fill")
                                    .font(.title)
                                
                                
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            
                            Button(action: {
                                // Action for like
                                
                                withAnimation{
                                    currentIndex = ( currentIndex + 1) %  profiles.count
                                    
                                    
                                    print(currentIndex)
                                    
                                    if(profiles.count - 1 == currentIndex){
                                        currentIndex = -1 ;
                                    }
                                    
                                }
                                
                            }) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .font(.title)
                                
                                
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            
                            Button(action: {
                                // Action for message
                            }) {
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
                }
                
            }
            
            .padding() .frame(width: ( UIScreen.main.bounds.width * CGFloat(profiles.count) ) , alignment: .leading)
            
        }.content.offset(x: -UIScreen.main.bounds.width * CGFloat(currentIndex))
        
    }
}
