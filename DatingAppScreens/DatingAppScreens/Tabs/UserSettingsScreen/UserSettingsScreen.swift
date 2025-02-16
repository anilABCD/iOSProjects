//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI

struct UserSettingsView : View {

    @EnvironmentObject private var tokenManger : TokenManager
    
    
    @EnvironmentObject private var themeManager : ThemeManager
    
    
   
    
  
    @State var items : [String] = ["Photo", "Technologies"]
    
    
    
    
    var body: some View {
     
        NavigationStack {
            VStack {
                AsyncImageView(photoURL: "\(tokenManger.serverImageURL)/\(tokenManger.photo)").frame(width: 200, height: 200).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                   
                Form {
                    Section(header: Text("User Profile").foregroundColor(themeManager.currentTheme.secondaryColor)) {
                        
                        NavigationLink(destination: UploadYourPhotoView()) {
//                            Text("Photo").foregroundColor(themeManager.currentTheme.primaryColor)
                                   HStack {
                                       Text("Photo")
                                           .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                       Spacer()
                                      
                                       
                                           Image(systemName: "chevron.right")
                                               .font(.system(size: 13)) // Standard system chevron size
                                               .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                               .background(themeManager.currentTheme.backgroundColor)
                                                   .offset(x: 18) // Adjust horizontal position
                                     
                                            
                                   }.zIndex(1)
                               }
                               .listRowSeparatorTint(themeManager.currentTheme.navigationLinkColor)
                               
                               .accentColor(themeManager.currentTheme.primaryColor) // For default arrow (if used)
                        
                      
                        
                        NavigationLink(destination: UpdateTechnologyNewView()) {
//                            Text("Technologies").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Technologies")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                               
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.navigationLinkColor)
                        
                        NavigationLink(destination: UpdateHobbiesView()) {
//                            Text("Hobbies").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Hobbies")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                               
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.navigationLinkColor)
                        
                        NavigationLink(destination: UpdateSmokingAndDrinkingAndDOBView()) {
//                            Text("Dob , Habbits").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Dob , Habbits")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                               
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.navigationLinkColor)
                        
                        NavigationLink(destination: UpdateDescribeYourselfView ()) {
//                            Text("Bio").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Bio")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                               
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.navigationLinkColor)
                        
                        NavigationLink(destination: UpdateJobRoleView ()) {
//                            Text("Job Role").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Job Role")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                               
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }
                            .zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.navigationLinkColor)
                    }
                    
//                    .overlay(Rectangle().frame(height: 1).foregroundColor(themeManager.currentTheme.primaryColor), alignment: .bottom)
                        .listRowBackground(themeManager.currentTheme.backgroundColor) // Custom background for User Profile section
                       
                    //                          Section(header: Text("Appearance")) {
                    //                              NavigationLink(destination: AppearanceSettingsView()) {
                    //                                  Text("Theme")
                    //                              }
                    //                              NavigationLink(destination: FontSettingsView()) {
                    //                                  Text("Font")
                    //                              }
                    //                          }
                }.scrollContentBackground(.hidden) // Removes default background
                .background(themeManager.currentTheme.backgroundColor)
                .listStyle(.insetGrouped)
                .accentColor(themeManager.currentTheme.primaryColor) // Global fallback
               
                
            }.navigationBarTitle("Profile Settings" , displayMode: .inline).background(themeManager.currentTheme.backgroundColor).onAppear(){
                
                UITableView.appearance().tintColor = UIColor(themeManager.currentTheme.primaryColor)
                tokenManger.isMenuView = true;
                
            }
          
          
            
        }  .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton {
                // Handle back button action
                tokenManger.isMenuView = false;
               
            })
            .onAppear {
                            updateNavigationBarColor()
                        }

    }
    
    func updateNavigationBarColor() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
           
            appearance.backgroundColor = UIColor(themeManager.currentTheme.backgroundColor)
            appearance.titleTextAttributes = [.foregroundColor: UIColor(themeManager.currentTheme.primaryColor)] // Title color
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
}


struct  UserSettingsView_Previews: PreviewProvider {
   
    static var previews: some View {
        UserSettingsView().environmentObject(TokenManager()).environmentObject(ThemeManager())
    }
}


//struct UserSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSettingsView()
//            .environmentObject(TokenManager())
//            .environmentObject(ThemeManager())
//            .previewLayout(.sizeThatFits) // Ensures the preview adjusts properly
//    }
//}
//

struct AsyncImageView: View {
    
    var photoURL :String = ""
    
    init(photoURL: String) {
        self.photoURL = photoURL
    }
    
    var body: some View {
        // AsyncImage loading the image from a URL
        AsyncImage(url: URL(string: photoURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode:.fill)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill
                    )
            @unknown default:
                EmptyView()
            }
        }
    }
}
