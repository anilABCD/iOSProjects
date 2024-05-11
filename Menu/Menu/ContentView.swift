//
//  ContentView.swift
//  Menu
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var isMenuVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
           
                
                VStack {
                    
                    Button("Menu"){
                       
                        withAnimation {
                            isMenuVisible.toggle()
                        }
                               
                    }
                    
                    Text("Content View")
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isMenuVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                }
                
                
                  if isMenuVisible {
                      Color.white.opacity(0.1).edgesIgnoringSafeArea(.all)
                          .onTapGesture {
                              withAnimation {
                                  isMenuVisible.toggle()
                              }
                          }
                     
                         
                  }
                
                SideMenuView(isMenuVisible: $isMenuVisible)
                
            }
            .navigationBarTitle("", displayMode: .inline)
            
            
        }
    }
}

struct SideMenuView: View {
    @Binding var isMenuVisible: Bool
    
    var body: some View {
         
            GeometryReader { geometry in
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        NavigationLink(destination: Text("Home")) {
                            Text("Home")
                        }
                        NavigationLink(destination: Text("Profile")) {
                            Text("Profile")
                        }
                        NavigationLink(destination: Text("Settings")) {
                            Text("Settings")
                        }
                    }
                    .padding()
                    .frame(width: geometry.size.width / 2)
                    .background(Color.white)
                    .offset(x: isMenuVisible ? 0 : -geometry.size.width / 2 )
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}


#Preview {
    ContentView()
}
