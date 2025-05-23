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
                CachedImageView(
                    url: URL(string: "\(tokenManger.serverImageURL)/\(tokenManger.photo ?? "image.jpg")"),
                    width: 100,
                    height: 100,
                    failureView: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()  .clipShape(Circle()).frame(width: 200, height: 200)
                        
                    },
                    storeInDisk : true
                )
                    .clipShape(Circle()).frame(width: 200, height: 200)
               
                
                HStack {
                    Spacer()
                    Text(tokenManger.name).modifier(ThemedTextModifier()).padding()
                    Spacer()
                }.frame(height: 20)
                
              
                Form {
                    Section(header: Text("User Profile").foregroundColor(themeManager.currentTheme.secondaryColor)) {
                        
                        NavigationLink(destination: UploadYourPhotoView()) {
//                            Text("Photo").foregroundColor(themeManager.currentTheme.primaryColor)
                                   HStack {
                                       Text("Photo")
                                           .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                       Spacer()
                                      
                                       
                                       Text("select")
                                           .lineLimit(1)
                                           .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                           .frame(maxWidth: 60)
                                           .offset(x: 18) // Adjust horizontal position
                                       
                                           Image(systemName: "chevron.right")
                                               .font(.system(size: 13)) // Standard system chevron size
                                               .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                               .background(themeManager.currentTheme.backgroundColor)
                                                   .offset(x: 18) // Adjust horizontal position
                                     
                                            
                                   }.zIndex(1)
                               }
                               .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                               
                               .accentColor(themeManager.currentTheme.primaryColor) // For default arrow (if used)
                        
                        
                        NavigationLink(destination: UploadYourAdditionalPhotosView()) {
//                            Text("Photo").foregroundColor(themeManager.currentTheme.primaryColor)
                                   HStack {
                                       Text("Additional Photo")
                                           .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                       Spacer()
                                      
                                       
                                       Text("select")
                                           .lineLimit(1)
                                           .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                           .frame(maxWidth: 60)
                                           .offset(x: 18) // Adjust horizontal position
                                       
                                           Image(systemName: "chevron.right")
                                               .font(.system(size: 13)) // Standard system chevron size
                                               .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                               .background(themeManager.currentTheme.backgroundColor)
                                                   .offset(x: 18) // Adjust horizontal position
                                     
                                            
                                   }.zIndex(1)
                               }
                               .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                               
                               .accentColor(themeManager.currentTheme.primaryColor) // For default arrow (if used)
                        
                        
                        NavigationLink(destination: UpdateGenderView()) {
//                            Text("Technologies").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Gender")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                                
//                                Text(tokenManger.gender)
                                Text("select")
                                    .lineLimit(1)
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                    .frame(maxWidth: 60)
                                    .offset(x: 18) // Adjust horizontal position
                                
                                
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                        
                        
                        NavigationLink(destination: UpdateTechnologyNewView()) {
//                            Text("Technologies").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Technologies")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                                
//                                Text(tokenManger.technologies.replacingOccurrences(of: "#", with: ""))
                                Text("select")
                                    .lineLimit(1)
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                    .frame(maxWidth: 60)
                                    .offset(x: 18) // Adjust horizontal position
                                
                                
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                        
                        NavigationLink(destination: UpdateHobbiesView()) {
//                            Text("Hobbies").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Hobbies")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                               
//                                Text(tokenManger.hobbies.replacingOccurrences(of: "#", with: "") )
                                Text("select")
                                    .lineLimit(1)
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                    .frame(maxWidth: 60)
                                    .offset(x: 18) // Adjust horizontal position
                                
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                        
                        NavigationLink(destination: UpdateDOBView()) {
//                            Text("Dob , Habbits").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Date Of Birth")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                                
                                
//                                Text(formattedDateddMMMyyy(dateString: tokenManger.dob))
                                Text("select")
                                    .lineLimit(1)
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                    .frame(maxWidth: 60)
                                    .offset(x: 18) // Adjust horizontal position
                                
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                        
                        NavigationLink(destination: UpdateDescribeYourselfView ()) {
//                            Text("Bio").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Bio")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                                
                                
//                                Text(tokenManger.bio)
                                Text("select")
                                    .lineLimit(1)
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                    .frame(maxWidth: 60)
                                    .offset(x: 18) // Adjust horizontal position
                                
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                        
                        NavigationLink(destination: UpdateJobRole2View ()) {
//                            Text("Job Role").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Job Role")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                                
//                                Text(tokenManger.jobRole)
                                Text("select")
                                    .lineLimit(1)
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                    .frame(maxWidth: 60)
                                    .offset(x: 18) // Adjust horizontal position
                               
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }
                            .zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                        
                        
                        NavigationLink(destination: UpdateSmokingView ()) {
//                            Text("Bio").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Smoking")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                               
//                                Text(tokenManger.smoking)
                                Text("select")
                                    .lineLimit(1)
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                    .frame(maxWidth: 60)
                                    .offset(x: 18) // Adjust horizontal position
                                
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                        
                        NavigationLink(destination: UpdateDrinkingView ()) {
//                            Text("Bio").foregroundColor(themeManager.currentTheme.primaryColor)
                            HStack {
                                Text("Drinking")
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                Spacer()
                                
//                                Text(tokenManger.drinking )
                                Text("select")
                                    .lineLimit(1)
                                    .foregroundColor(themeManager.currentTheme.navigationLinkColor.opacity(0.3))
                                    .frame(maxWidth: 60)
                                    .offset(x: 18) // Adjust horizontal position
                                
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13)) // Standard system chevron size
                                        .foregroundColor(themeManager.currentTheme.navigationLinkColor) // Chevron color
                                     
                                        .background(themeManager.currentTheme.backgroundColor)
                                        .offset(x: 18) // Adjust horizontal position
                                
                            }.zIndex(1)
                        } .listRowSeparatorTint(themeManager.currentTheme.secondaryColor)
                        
                        
                        HStack {
                            Spacer()
                            Button("Logout"){
                                tokenManger.resetAccessToken()
                            }
                            Spacer()
                        }
                        
                        
                        Text("Location\(tokenManger.location  ?? "Not Set")")
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
                    
                    
//                    Rectangle().frame(height: 100).background(themeManager.currentTheme.backgroundColor)
                    
                   
                    
                    VStack {
                        
                    }.frame(height: 200).listRowBackground(themeManager.currentTheme.backgroundColor) // Custom
                    
                
                    
                }.scrollContentBackground(.hidden) // Removes default background
                .background(themeManager.currentTheme.backgroundColor)
                .listStyle(.insetGrouped)
                .edgesIgnoringSafeArea(.all)
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
           
        appearance.backgroundColor = UIColor(themeManager.currentTheme.cardBackgroundColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor( themeManager.currentTheme.id == "light" ? .black : themeManager.currentTheme.primaryColor)] // Title color
            
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
