//
//  SideMenuView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 02/03/25.
//


import SwiftUI

struct SideMenuView1: View {
    @Binding var isOpen: Bool
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            // Background Overlay
            if isOpen {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isOpen.toggle()
                        }
                    }
            }
            
            // Side Menu
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    // Profile Section
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                        Text("Welcome, User")
                            .font(.title2)
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "title", in: animation)
                    }
                    .padding(.bottom, 20)
                    
                    // Menu Items
                    ForEach(MenuItem.allCases, id: \.self) { item in
                        HStack {
                            Image(systemName: item.icon)
                                .frame(width: 30)
                                .foregroundColor(.white)
                            
                            Text(item.rawValue)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isOpen.toggle()
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(width: 250, height: UIScreen.main.bounds.height)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .offset(x: isOpen ? 0 : -300)
                .animation(.spring(), value: isOpen)
                
                Spacer()
            }
        }
    }
}

// Enum for Menu Items
enum MenuItem: String, CaseIterable {
    case home = "Home"
    case profile = "Profile"
    case settings = "Settings"
    case logout = "Logout"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .profile: return "person.fill"
        case .settings: return "gearshape.fill"
        case .logout: return "arrow.backward.circle.fill"
        }
    }
}

// Main View with Toggle Button
struct SideMenuViewX: View {
    @State private var isMenuOpen = false
    
    var body: some View {
        ZStack (alignment: .leading) {
            
            VStack {
                
                HStack {
                    
                    // Main Content with Toggle Button
                    Button(action: {
                        withAnimation(.spring()) {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .padding()
                    }
                }.padding(.top , 10)
                               
                               Spacer()
                           }
                           .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                           .navigationTitle("Home")
                           
            SideMenuView1(isOpen: $isMenuOpen)
        }.frame( maxWidth : .infinity,  maxHeight: .infinity , alignment: .leading).edgesIgnoringSafeArea(.all) // Ensures full-screen effect
    }
}

// Preview

#if DEBUG

struct SideMenuViewX_Previews: PreviewProvider {
    
    @State static var isMenuOpen = false
    static var previews: some View {
        SideMenuViewX()
    }
    
}

#endif

